//
//  TestCSSColor.m
//  libnetsurf
//
//  Created by Andrew Pouliot on 3/8/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TestCSSColor.h"
#import "UIColor-CSSColor.h"

@implementation TestCSSColor

- (void)testBasicColor {
    
	STAssertEqualObjects([UIColor colorWithCSSColor:(css_color)0xff00ff00], [UIColor colorWithRed:0 green:255.0/255.0 blue:0.0 alpha:1.0], @"Bad color initializiation");

}

@end
