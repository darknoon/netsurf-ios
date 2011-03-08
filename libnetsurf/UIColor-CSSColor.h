//
//  UIColor-CSSColor.h
//  libnetsurf
//
//  Created by Andrew Pouliot on 3/7/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#include <libcss/types.h>

@interface UIColor (UIColor_CSSColor)
+ (UIColor*)colorWithCSSColor:(css_color)rgba;
@end
