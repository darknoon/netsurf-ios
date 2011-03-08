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
@private
	css_stylesheet *_stylesheet;
}

//Load from static data.
//For now, the stylesheet may not reference external stylesheets
- (id)initWithData:(NSData *)inData error:(NSError **)outError;

@end
