#import "NSString-wapcaplet.h"
#import <libwapcaplet/libwapcaplet.h>

@implementation NSString (wapcaplet)

- (id)initWithLWCString:(struct lwc_string_s*)str;
{
	return [self initWithBytes:lwc_string_data(str)
						length:lwc_string_length(str)
					  encoding:NSUTF8StringEncoding];
}

+ (NSString*)stringWithLWCString:(lwc_string*)str {
	return [[[self alloc] initWithLWCString:str] autorelease];
}

- (lwc_string*)LWCString {
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
  lwc_string *str = NULL;
  lwc_intern_string((const char *)data.bytes, data.length, &str);
  return str;
}

@end
