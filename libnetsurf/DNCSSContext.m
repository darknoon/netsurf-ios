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

@end
