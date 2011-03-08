//
//  TestStylesheetBasic.m
//  libnetsurf
//
//  Created by Andrew Pouliot on 3/7/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TestStylesheetBasic.h"

#import "DNCSSStylesheet.h"
#import "DNCSSContext.h"
#import "DNCSSStyle.h"

#import "CSSSelectHandlerBase.h"
#import "NSString-wapcaplet.h"

// CSS selection handlers
css_error node_name(void *pw, void *n, lwc_string **name) {
	lwc_string *node = n;
	*name = lwc_string_ref(node);
	return CSS_OK;
}
css_error node_has_name(void *pw, void *n, lwc_string *name, bool *match) {
	lwc_string *node = n;
	assert(lwc_string_caseless_isequal(node, name, match) == lwc_error_ok);
	return CSS_OK;
}


@implementation TestStylesheetBasic

- (void)setUp;
{
	
}

- (void)testBasic {
	NSString *stylesheetText = @"body {color:#ff0000;}\n";
	
	// setup select handler
    css_select_handler handler;
    CSSSelectHandlerInitToBase(&handler);
    handler.node_name = &node_name;
    handler.node_has_name = &node_has_name;
    
    // select "body" element
    lwc_string *elementNameNode = [@"body" LWCString];
	
	NSError *error = nil;
	DNCSSStylesheet *stylesheet = [[DNCSSStylesheet alloc] initWithData:[stylesheetText dataUsingEncoding:NSUTF8StringEncoding]
																baseURL:nil
																  error:&error];

	DNCSSContext *context = [[DNCSSContext alloc] initWithStylesheet:stylesheet];
	
	DNCSSStyle *computedStyle = [context computedStyleForNode:elementNameNode withSelectHandlers:&handler];
	
	STAssertEqualObjects(computedStyle.color, [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0], @"body color should be red");
	
	lwc_string_unref(elementNameNode); elementNameNode = NULL;

}

@end
