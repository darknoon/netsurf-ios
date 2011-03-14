//
//  DNCSSStylesheet.m
//  libnetsurf
//
//  Created by Andrew Pouliot on 3/7/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "DNCSSStylesheet.h"

#import "DNCSSPrivate.h"

//For some reason, these aren't coming through the import. investigate
#import "NSString-wapcaplet.h"
#import "NSError-css.h"

#include <libcss/types.h>

static css_error resolve_url(void *pw, const char *base, lwc_string *rel,
                             lwc_string **abs) {
	DNCSSStylesheet *self = (DNCSSStylesheet*)pw;
	NSString *rels = [NSString stringWithLWCString:rel];
	NSURL *url = [NSURL URLWithString:rels relativeToURL:self.baseURL];
	*abs = [url.absoluteString LWCString];
	return CSS_OK;
}


static css_error dummy_url_resolver(void *pw, const char *base, lwc_string *rel,
                                    lwc_string **abs) {
	//pw = pw; base = base;
	*abs = lwc_string_ref(rel);
	return CSS_OK;
}

@interface DNCSSStylesheet (Private)
- (BOOL)appendData:(NSData *)data
			 error:(NSError **)outError
	   expectsMore:(BOOL *)expectsMore;
@end

@implementation DNCSSStylesheet

@synthesize baseURL = _baseURL;

- (id)initWithData:(NSData *)inData baseURL:(NSURL *)inBaseURL error:(NSError **)outError;
{
	return [self initWithData:inData baseURL:inBaseURL isInline:NO error:outError];
}

- (id)initWithData:(NSData *)inData baseURL:(NSURL *)inBaseURL isInline:(BOOL)inIsInline error:(NSError **)outError;
{
	self = [super init];
	if (!self) return nil;

	_baseURL = [inBaseURL retain];

	css_stylesheet_params params = {
		/** The language level of the stylesheet */
		.level = CSS_LEVEL_DEFAULT,
		
		/** The charset of the stylesheet data, or NULL to detect */
		.charset = "UTF-8",
		/** URL of stylesheet */
		.url = _baseURL ? [_baseURL.absoluteString cStringUsingEncoding:NSASCIIStringEncoding] : "",
		/** Title of stylesheet */
		.title = "DNCSS_GENERIC_STYLESHEET_NAME",
		
		/** Permit quirky parsing of stylesheet */
		.allow_quirks = false,
		/** This stylesheet is an inline style */
		.inline_style = inIsInline,
		
		/** URL resolution function */
		.resolve = resolve_url,
		/** Client private data for resolve */
		.resolve_pw = self,
		
		/** Import notification function */
		.import = (css_import_notification_fn)NULL,
		/** Client private data for import */
		.import_pw = (void *)NULL,
		
		/** Colour resolution function */
		.color = (css_color_resolution_fn)NULL,
		/** Client private data for color */
		.color_pw = (void *)NULL,
		
		/** Font resolution function */
		.font = (css_font_resolution_fn)NULL,
		/** Client private data for font */
		.font_pw = (void *)NULL,
	};

	css_error status = css_stylesheet_create(&params, css_cf_realloc, NULL, &_stylesheet);
	
	if (status != CSS_OK) {
		if (outError) {
			*outError = [NSError errorWithCSSStatus:status];
		}
		CSS_LOG_ERROR(status, @"Couldn't create a stylesheet");
		[self release];
		return nil;
	}

	NSError *dataError = nil;
	BOOL ok = [self appendData:inData error:&dataError expectsMore:NULL];
	if (!ok) {
		if (outError) {
			*outError = dataError;
		}
		CSS_LOG_ERROR(status, @"Couldn't add data to a stylesheet");
		[self release];
		return nil;
	}
	
	status = css_stylesheet_data_done(_stylesheet);
	if (status != CSS_OK) {
		if (outError) {
			*outError = [NSError errorWithCSSStatus:status];
		}
		CSS_LOG_ERROR(status, @"Couldn't parse a stylesheet?");
		[self release];
		return nil;
	}
	
	return self;

}

- (BOOL)appendData:(NSData*)data
             error:(NSError**)outError
       expectsMore:(BOOL*)expectsMore {
	assert(data != nil);
	css_error status = css_stylesheet_append_data(_stylesheet,
												  (const uint8_t *)data.bytes,
												  data.length);
	if (status != CSS_OK && status != CSS_NEEDDATA) {
		if (outError)
			*outError = [NSError errorWithCSSStatus:status];
		if (expectsMore != nil) *expectsMore = NO;
		return NO;
	} else if (expectsMore != nil) {
		*expectsMore = (status == CSS_NEEDDATA);
	}
	return YES;
}


- (void)dealloc {
    if (_stylesheet) {
		css_stylesheet_destroy(_stylesheet);
	}
	[_baseURL release];
    [super dealloc];
}

@end
