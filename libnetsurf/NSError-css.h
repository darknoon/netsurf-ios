//  From libcss-osx

extern NSString *CSSErrorDomain;

@interface NSError (CSS)
+ (NSError*)errorWithCSSStatus:(int)status;
//+ (NSError*)libcssHTTPErrorWithStatusCode:(int)status;
@end
