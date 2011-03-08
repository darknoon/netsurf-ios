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
	NSString *node = n;
	*name = [node LWCString];
	return CSS_OK;
}

css_error node_has_name(void *pw, void *n, lwc_string *name, bool *match) {
	NSString *node = n;
	
	lwc_string *nodeTempString = [node LWCString];
	//Returns by ref to the *match
	assert(lwc_string_caseless_isequal(nodeTempString, name, match) == lwc_error_ok);
	lwc_string_unref(nodeTempString);
	
	return CSS_OK;
}


@implementation TestStylesheetBasic

- (void)setUp;
{
    //Nodes are just NSStrings for this test suite
    CSSSelectHandlerInitToBase(&handler);
    handler.node_name = &node_name;
    handler.node_has_name = &node_has_name;	
}

- (void)testBasic {
	NSString *stylesheetText = @"body {color:#ff0000; font: bold 18px sans-serif} div {color:blue}\n";
	
	NSError *error = nil;
	DNCSSStylesheet *stylesheet = [[[DNCSSStylesheet alloc] initWithData:[stylesheetText dataUsingEncoding:NSUTF8StringEncoding]
																baseURL:nil
																  error:&error] autorelease];
	
	STAssertNotNil(stylesheet, @"Stylesheet could not be created");

	DNCSSContext *context = [[[DNCSSContext alloc] initWithStylesheet:stylesheet] autorelease];

	STAssertNotNil(context, @"context could not be created");
	
	DNCSSStyle *bodyStyle = [context computedStyleForNode:@"body" withSelectHandlers:&handler];

	STAssertNotNil(bodyStyle, @"style could not be computed");
	
	STAssertEqualObjects(bodyStyle.color, [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0], @"body color should be red");
	
	CTFontDescriptorRef bodyFontDescriptor = [bodyStyle fontDescriptor];
	
	STAssertNotNil((id)bodyFontDescriptor, @"Body font not returned");
	
	NSDictionary *bodyFontAttributes = (NSDictionary *)CTFontDescriptorCopyAttributes(bodyFontDescriptor);
	NSLog(@"body font: %@", bodyFontAttributes);
	STAssertEqualObjects([bodyFontAttributes objectForKey:(id)kCTFontNameAttribute], @"Helvetica", @"Font should be Helvetica");
	STAssertTrue([[bodyFontAttributes objectForKey:(id)kCTFontWeightTrait] floatValue] > 0.0f, @"Helvetica", @"Font should be bold");
	[bodyFontAttributes release];

	DNCSSStyle *divStyle = [context computedStyleForNode:@"div" withSelectHandlers:&handler];
	STAssertEqualObjects(divStyle.color, [UIColor colorWithRed:0.0 green:0 blue:1.0 alpha:1.0], @"div color should be blue");

}

- (void)testBasicFontSupport;
{
	
}

@end
