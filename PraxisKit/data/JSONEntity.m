//
//  JSONEntity.m
//  PraxisKit
//
//  Created by Hilario Perez Corona on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONEntity.h"

@implementation JSONEntity

- (void)usingDictionary:(NSDictionary *)dictionary {
  NSArray *keys = [[dictionary keyEnumerator] allObjects];
  
  for (int i = 0; i < [keys count]; i++) {
    NSString *method = [NSString stringWithFormat:@"set%@:",[keys objectAtIndex:i]];
    
    SEL selector = NSSelectorFromString(method);
    
    if ([self respondsToSelector:selector]) {
      [self performSelector:selector withObject:[dictionary objectForKey:[keys objectAtIndex:i]]];
    }
  }
}

+ (NSArray*)arrayUsingJson:(NSArray *)array {
  NSMutableArray *entities = [[NSMutableArray alloc] initWithCapacity:[array count]];
  
  for (int i = 0; i < [array count]; i++) {
    JSONEntity *obj = [[[self class] alloc] init];
    
    [obj usingDictionary:[array objectAtIndex:i]];
    
    [entities addObject:obj];
  }
  
  return entities;
}

+ (NSString*)NewUid:(NSString*)_pre {
    NSString* result;
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    int num = (int)([[NSDate date] timeIntervalSince1970]);
        
    result =[NSString stringWithFormat:@"%@/%d/%@", _pre, num, string];
    assert(result != nil);

    return result;
}

@end
