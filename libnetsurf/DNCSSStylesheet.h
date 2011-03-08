//
//  DNCSSStylesheet.h
//  libnetsurf
//
//  Created by Andrew Pouliot on 3/7/11.
//  Copyright 2011 Darknoon. All rights reserved.
//  Based on work from

#import <Foundation/Foundation.h>

#include <libcss/libcss.h>

@interface DNCSSStylesheet : NSObject {
@package
	css_stylesheet *_stylesheet;
	NSURL *_baseURL;
}

//Load from static data.
//For now, the stylesheet may not reference external stylesheets
//Pass in UTF-8 encoded string data
- (id)initWithData:(NSData *)inData baseURL:(NSURL *)inBaseURL error:(NSError **)outError;

@property (nonatomic, readonly) NSURL *baseURL;

@end
