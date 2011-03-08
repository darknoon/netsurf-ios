
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import <libcss/libcss.h>

@class DNCSSContext, DNCSSStylesheet;

@interface DNCSSStyle : NSObject {
	@package
	css_select_results *_styles;
	//This is the default (non-pseudo-element) style
	//TODO: define a different class relationship to handle this separation
	css_computed_style *_style;
}

@property(readonly, nonatomic) css_computed_style *style;

/**
 * Merge this style (parent) with another style (child). |child| has
 * precedence. A new autoreleased CSSStyle object is returned.
 */
- (DNCSSStyle *)styleByMergingWithStyle:(DNCSSStyle *)child error:(NSError **)outError;

#pragma mark -
#pragma mark Style properties

// Color. A value of nil means "inherit".
@property(readonly, nonatomic) UIColor    *color;
@property(readonly, nonatomic) UIColor    *backgroundColor;
@property(readonly, nonatomic) UIColor    *outlineColor;
@property(readonly, nonatomic) UIColor    *borderTopColor;
@property(readonly, nonatomic) UIColor    *borderRightColor;
@property(readonly, nonatomic) UIColor    *borderBottomColor;
@property(readonly, nonatomic) UIColor    *borderLeftColor;

// Border width
@property(readonly, nonatomic) CGFloat    borderLeftWidth;
@property(readonly, nonatomic) CGFloat    borderTopWidth;
@property(readonly, nonatomic) CGFloat    borderRightWidth;
@property(readonly, nonatomic) CGFloat    borderBottomWidth;

// Block dimensions. Note: NaN is returned for e.g. "width:auto"
@property(readonly, nonatomic) CGFloat
    width,
    height;

// Font
@property(readonly, nonatomic) int
    fontWeight, // 100, 400, ...
    fontStyle, // CSS_FONT_STYLE_ITALIC, ...
    fontVariant; // CSS_FONT_VARIANT_SMALL_CAPS..
@property(readonly, nonatomic) CGFloat fontSize; // in points
@property(readonly, nonatomic) NSArray *fontFamilyNames; // nil means "inherit"
@property(readonly, nonatomic) CTFontDescriptorRef fontDescriptor; // nil means "inherit" or no font family could be found

// text
@property(readonly, nonatomic) int
    textDecoration; // CSS_TEXT_DECORATION_UNDERLINE, ...

@end
