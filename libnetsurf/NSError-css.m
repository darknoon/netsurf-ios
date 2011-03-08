#import "NSError-css.h"

#include <libcss/errors.h>

NSString *CSSErrorDomain = @"org.netsurf-browser.libcss";

@implementation NSError (CSS)

+ (NSError*)errorWithCSSStatus:(int)status;
{
	NSString *msg = [NSString stringWithUTF8String:css_error_to_string(status)];
	NSDictionary *info = [NSDictionary dictionaryWithObject:msg
													 forKey:NSLocalizedDescriptionKey];
	return [NSError errorWithDomain:CSSErrorDomain code:status userInfo:info];
}

+ (NSError*)libcssHTTPErrorWithStatusCode:(int)status {
  NSString *msg = [NSHTTPURLResponse localizedStringForStatusCode:status];
  NSDictionary *info =
      [NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey];
  return [NSError errorWithDomain:NSURLErrorDomain code:status userInfo:info];
}

@end
