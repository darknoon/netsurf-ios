//
//  UIColor-CSSColor.m
//  libnetsurf
//
//  Created by Andrew Pouliot on 3/7/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "UIColor-CSSColor.h"


@implementation UIColor (UIColor_CSSColor)

+ (UIColor *)colorWithCSSColor:(css_color)rgba {
	return [UIColor colorWithRed:((rgba >> 16) & 0xFF) / 255.0
						   green:((rgba >> 8) & 0xFF) / 255.0
							blue:(rgba & 0xFF) / 255.0
						   alpha:((rgba >> 24) & 0xFF) / 255.0];
}

@end
