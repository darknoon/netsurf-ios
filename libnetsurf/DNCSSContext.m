//
//  DNCSSContext.m
//  libnetsurf
//
//  Created by Andrew Pouliot on 3/7/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "DNCSSContext.h"

#import "DNCSSStylesheet.h"
#import "css-cf-realloc.h"
#import "DNCSSStyle.h"

@implementation DNCSSContext

- (id)init {
	if (!(self = [super init])) return nil;
	
	css_error status = css_select_ctx_create(&css_cf_realloc, 0, &_selectContext);
	if (status != CSS_OK) {
		[self release];
		return nil;
	}
	
	
	return self;
}

- (id)initWithStylesheet:(DNCSSStylesheet*)inStyleSheet;
{
	self = [self init];
	if (!self) return nil;
	
	[self addStylesheet:inStyleSheet];
	
	return self;
}


- (void)addStylesheet:(DNCSSStylesheet *)inStyleSheet;
{
	css_select_ctx_append_sheet(_selectContext, inStyleSheet->_stylesheet, CSS_ORIGIN_AUTHOR, CSS_MEDIA_ALL);
}

- (DNCSSStyle *)computedStyleForNode:(void *)node inlineStylesheet:(DNCSSStylesheet *)inInlineStylesheet withSelectHandlers:(css_select_handler *)inHandlers;
{
	DNCSSStyle *style = [[[DNCSSStyle alloc] init] autorelease];
	if (!style) return nil;
	/**
	 * Select a style for the given node
	 *
	 * \param ctx             Selection context to use
	 * \param node            Node to select style for
	 * \param media           Currently active media types
	 * \param inline_style    Corresponding inline style for node, or NULL
	 * \param handler         Dispatch table of handler functions
	 * \param pw              Client-specific private data for handler functions
	 * \param result          Pointer to location to receive result set
	 * \return CSS_OK on success, appropriate error otherwise.
	 *
	 * In computing the style, no reference is made to the parent node's
	 * style. Therefore, the resultant computed style is not ready for
	 * immediate use, as some properties may be marked as inherited.
	 * Use css_computed_style_compose() to obtain a fully computed style.
	 *
	 * This two-step approach to style computation is designed to allow
	 * the client to store the partially computed style and efficiently
	 * update the fully computed style for a node when layout changes.
	 */
	
	css_media_type mediaType = CSS_MEDIA_SCREEN;
	
	css_error status = css_select_style(_selectContext, //ctx
										node, //node
										mediaType, //media
										(inInlineStylesheet ? inInlineStylesheet->_stylesheet : NULL), //inline_style
										inHandlers,//handler
										NULL, //handler data
										&style->_styles);
	
	if (status != CSS_OK) {
		[style release];
		style = nil;
	}

	style->_style = style->_styles->styles[CSS_PSEUDO_ELEMENT_NONE];
	
	return style;	
}

- (DNCSSStyle *)computedStyleForNode:(void *)node withSelectHandlers:(css_select_handler *)inHandlers;
{
	return [self computedStyleForNode:node inlineStylesheet:nil withSelectHandlers:inHandlers];
}

@end
