
#include "NSObject_Utils.h"

@implementation NSData (NSData_ToUTF8String)

- (NSString*)UTF8String {
  return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString*)ASCIIString {
  return [[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding];
}

- (id)JSONValue {
  return [[self UTF8String] JSONValue];
}

@end

@implementation NSString (NSString_URLEncode)

- (NSString*)URLEncoded {
  return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

@end
