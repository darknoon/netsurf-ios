#import "DNCSSStyle.h"
#import "DNCSSStylesheet.h"
#import "DNCSSContext.h"
#import "CSSSelectHandlerBase.h"
#import "UIColor-CSSColor.h"

#include "css-cf-realloc.h"
#include "NSString-wapcaplet.h"

#import "NSError-css.h"
#include <libcss/select.h>

static CGFloat _UIScaleFactor() {
  return 1.0;
}


@implementation DNCSSStyle

@synthesize style = _style;



- (id)init {
	if (!(self = [super init])) return nil;
	
	css_error status = css_computed_style_create(&css_cf_realloc, 0, &_style);
	if (status != CSS_OK) {
		[self release];
		return nil;
	}
	return self;
}


- (void)dealloc {
	if (_styles) {
		css_select_results_destroy(_styles);
	}
	[super dealloc];
}


- (DNCSSStyle *)styleByMergingWithStyle:(DNCSSStyle *)child error:(NSError **)outError;
{
	DNCSSStyle *mergedStyle = [[isa alloc] init];
	
	css_error status = css_computed_style_compose(_style, child->_style,
												  CSSSelectHandlerBase.compute_font_size, self, mergedStyle.style);
	if (status != CSS_OK) {
		if (outError) {
			*outError = [NSError errorWithCSSStatus:status];
		}
		[mergedStyle release];
		mergedStyle = nil;
	}
	return [mergedStyle autorelease];
}


#pragma mark -
#pragma mark Style properties


static CGFloat CSSDimensionToFontPoints(css_unit unit, css_fixed value) {
  // em and ex whould have been computed into "absolute" units already
  assert(unit != CSS_UNIT_EM);
  assert(unit != CSS_UNIT_EX);

	switch (unit) {
	case CSS_UNIT_PX:
		return FIXTOFLT(value);;
		break;
	case CSS_UNIT_IN:
		// TODO: in
		break;
	case CSS_UNIT_CM:
		// TODO: cm
		break;
	case CSS_UNIT_MM:
		// TODO: mm
		break;
	case CSS_UNIT_PT:
		return FIXTOFLT(value);
		break;
	case CSS_UNIT_PC:
		// TODO: pc
		break;
	case CSS_UNIT_PCT:
		// TODO: %
		break;
	case CSS_UNIT_DEG:
		// TODO: deg
		break;
	case CSS_UNIT_GRAD:
		// TODO: grad
		break;
	case CSS_UNIT_RAD:
		// TODO: rad
		break;
	case CSS_UNIT_MS:
		// TODO: ms
		break;
	case CSS_UNIT_S:
		// TODO: s
		break;
	case CSS_UNIT_HZ:
		// TODO: Hz
		break;
	case CSS_UNIT_KHZ:
		// TODO: kHz
		break;
	case CSS_UNIT_EX:
		// TODO: ex
		break;
	case CSS_UNIT_EM:
		// TODO: em
		break;
	}
  return FIXTOFLT(value); // FIXME
}


// Color
#define SYNTHESIZE_COLOR(name, fun_suffix) - (UIColor *)name { \
  css_color rgba; \
  uint8_t type = css_computed_##fun_suffix(_style, &rgba); \
  if (type == CSS_COLOR_INHERIT) return nil; \
  else return [UIColor colorWithCSSColor:rgba]; \
}

SYNTHESIZE_COLOR(color, color)
SYNTHESIZE_COLOR(backgroundColor, background_color)
SYNTHESIZE_COLOR(outlineColor, outline_color)
SYNTHESIZE_COLOR(borderTopColor, border_top_color)
SYNTHESIZE_COLOR(borderRightColor, border_right_color)
SYNTHESIZE_COLOR(borderBottomColor, border_bottom_color)
SYNTHESIZE_COLOR(borderLeftColor, border_left_color)


// Border widths

// TODO: convert non-pixel values to pixels
#define SYNTHESIZE_BORDER_WIDTH(name, direction) \
- (CGFloat)name { \
  css_fixed value; \
  css_unit unit; \
	uint8_t r = css_computed_border_##direction##_width(_style, &value, &unit); \
	switch (r) { \
    case CSS_BORDER_WIDTH_THIN: return 0.5; \
    case CSS_BORDER_WIDTH_MEDIUM: return 1.0; \
    case CSS_BORDER_WIDTH_THICK: return 3.0; \
    case CSS_BORDER_WIDTH_WIDTH: return FIXTOFLT(value); \
    default: return 0.0; \
	} \
}

SYNTHESIZE_BORDER_WIDTH(borderLeftWidth, left)
SYNTHESIZE_BORDER_WIDTH(borderTopWidth, top)
SYNTHESIZE_BORDER_WIDTH(borderRightWidth, right)
SYNTHESIZE_BORDER_WIDTH(borderBottomWidth, bottom)


// Block dimensions


- (CGFloat)width {
  css_unit unit;
  css_fixed value;
	switch (css_computed_width(_style, &value, &unit)) {
    case CSS_WIDTH_AUTO:
      return NAN;
    case CSS_WIDTH_SET:
      return CSSDimensionToFontPoints(unit, value);
    default:
      return 0.0;
	}
}

- (CGFloat)height {
  css_unit unit;
  css_fixed value;
	switch (css_computed_height(_style, &value, &unit)) {
    case CSS_HEIGHT_AUTO:
      return NAN;
    case CSS_HEIGHT_SET:
      return CSSDimensionToFontPoints(unit, value);
    default:
      return 0.0;
	}
}


// Font

- (int)fontWeight { return css_computed_font_weight(_style); }
- (int)fontStyle { return css_computed_font_style(_style); }
- (int)fontVariant { return css_computed_font_variant(_style); }


- (CGFloat)fontSize {
  css_fixed value;
  css_unit unit;
  uint8_t type = css_computed_font_size(_style, &value, &unit);
  CGFloat points = 0.0;
  if (type == CSS_FONT_SIZE_DIMENSION)
    points = CSSDimensionToFontPoints(unit, value);
  return points;
}

- (NSArray *)fontFamilyNames {
  //lwc_string **names style->font_family
  NSMutableArray *names = nil;
  lwc_string **string_list = NULL;
  uint8_t family_class = css_computed_font_family(_style, &string_list);
  if (family_class != CSS_FONT_FAMILY_INHERIT) {
    names = [NSMutableArray array];
		if (string_list != NULL) {
			while (*string_list != NULL) {
        NSString *name = [NSString stringWithLWCString:*(string_list++)];
        [names addObject:name];
			}
		}
    switch (family_class) {
      case CSS_FONT_FAMILY_SERIF: [names addObject:@"serif"]; break;
      case CSS_FONT_FAMILY_SANS_SERIF: [names addObject:@"sans-serif"]; break;
      case CSS_FONT_FAMILY_CURSIVE: [names addObject:@"cursive"]; break;
      case CSS_FONT_FAMILY_FANTASY: [names addObject:@"fantasy"]; break;
      case CSS_FONT_FAMILY_MONOSPACE: [names addObject:@"monospace"]; break;
    }
  }
  return names;
}

- (CTFontDescriptorRef)fontDescriptor {
	CTFontSymbolicTraits fontTraitMask = 0;
	
	// retrieve family names
	lwc_string **familyNamesPtr = NULL;
	uint8_t familyClass = css_computed_font_family(_style, &familyNamesPtr);
	if (familyClass == CSS_FONT_FAMILY_INHERIT)
		return nil;
	
	// font style
	switch (self.fontStyle) {
		case CSS_FONT_STYLE_ITALIC:
		case CSS_FONT_STYLE_OBLIQUE:
			fontTraitMask |= kCTFontItalicTrait;
			break;
	}
	
	// font variant
	//TODO: implement CSS_FONT_VARIANT_SMALL_CAPS
	//	if (self.fontVariant == CSS_FONT_VARIANT_SMALL_CAPS)
	//		fontTraitMask |= kCTFontTraitsAttribute;
	
	// font weight (currently only "bold" is supported)
	switch (self.fontWeight) {
		case CSS_FONT_WEIGHT_BOLD:
		case CSS_FONT_WEIGHT_BOLDER:
			fontTraitMask |= kCTFontBoldTrait;
			break;
	}
	
	CTFontDescriptorRef matchedFontDescriptor = NULL;
	
	NSMutableDictionary *fontAttributes = [[NSMutableDictionary alloc] initWithCapacity:4];
	NSMutableDictionary *fontTraits = [[NSMutableDictionary alloc] initWithCapacity:4];	
	[fontAttributes setObject:fontTraits forKey:(id)kCTFontTraitsAttribute];

	[fontTraits setObject:[NSNumber numberWithInt:fontTraitMask] forKey:(id)kCTFontSymbolicTrait];
	[fontAttributes setObject:[NSNumber numberWithFloat:self.fontSize] forKey:(id)kCTFontSizeAttribute];
	
	
	NSSet *requiredAttributes = [[NSSet alloc] initWithObjects:(id)kCTFontNameAttribute, nil];

	// try family names in order and stop at first found
	if (familyNamesPtr) {
		//Font must match name, and traits
		while (*familyNamesPtr != NULL && !matchedFontDescriptor) {
			NSString *familyName = [NSString stringWithLWCString:*(familyNamesPtr++)];

			if (familyName) [fontTraits setObject:fontAttributes forKey:(id)kCTFontNameAttribute];
			CTFontDescriptorRef fontDescriptor =  CTFontDescriptorCreateWithAttributes((CFDictionaryRef)fontAttributes);
			//Attempt to find a matching font
			matchedFontDescriptor = CTFontDescriptorCreateMatchingFontDescriptor(fontDescriptor, (CFSetRef)requiredAttributes);
			CFRelease(fontDescriptor);
		}
	}
	
	// try symbolic class
	if (!matchedFontDescriptor) {
			
		NSString *familyName = nil;
		switch (familyClass) {
			//Font of last resort: Times
			default:
			case CSS_FONT_FAMILY_SERIF: familyName = @"Times New Roman"; break;
			case CSS_FONT_FAMILY_SANS_SERIF: familyName = @"Helvetica"; break;
			case CSS_FONT_FAMILY_CURSIVE: familyName = @"SnellRoundhand"; break;
			case CSS_FONT_FAMILY_FANTASY: familyName = @"Zapfino"; break;
			case CSS_FONT_FAMILY_MONOSPACE: familyName = @"Courier"; break;
		}
		[fontAttributes setObject:familyName forKey:(id)kCTFontNameAttribute];
		
		CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)fontAttributes);
		
		matchedFontDescriptor = CTFontDescriptorCreateMatchingFontDescriptor(fontDescriptor, (CFSetRef)requiredAttributes);
		
		CFRelease(fontDescriptor);

	}
	
	[fontTraits release];
	[requiredAttributes release];

	//In case we have GC...
		
	return (CTFontDescriptorRef)[NSMakeCollectable(matchedFontDescriptor) autorelease];
}

// text

- (int)textDecoration { return css_computed_text_decoration(_style); }

@end
