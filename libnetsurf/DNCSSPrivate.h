#define CSS_LOG_ERROR(status, label) \
NSLog(@"DNCSS error: %@ => %s", label, css_error_to_string(status))

#import "css-cf-realloc.h"

#import "NSString-wapcaplet.h"
#import "NSError-css.h"