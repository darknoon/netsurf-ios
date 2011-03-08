//
//  DNCSSContext.h
//  libnetsurf
//
//  Created by Andrew Pouliot on 3/7/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <libcss/libcss.h>

@class DNCSSStylesheet;
@interface DNCSSContext : NSObject {
	@package
	css_select_ctx *_selectContext;
}

- (id)initWithStylesheet:(DNCSSStylesheet*)inStyleSheet;

- (void)addStylesheet:(DNCSSStylesheet *)inStyleSheet;

//TODO:
//- (void)insertStylesheet:(CSSStylesheet*)stylesheet atIndex:(NSUInteger)index;
//- (CSSStylesheet*)stylesheetAtIndex:(NSUInteger)index;
//- (void)removeStylesheet:(CSSStylesheet*)stylesheet;
//- (void)removeStylesheetAtIndex:(NSUInteger)index;
//- (NSUInteger)count;
//
///// Fast enumeration support
//- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
//                                  objects:(id *)stackbuf
//                                    count:(NSUInteger)len;

@end
