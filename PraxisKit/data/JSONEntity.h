//
//  JSONEntity.h
//  PraxisKit
//
//  Created by Hilario Perez Corona on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../JSON/SBJson.h"

@interface JSONEntity : NSObject

- (void)usingDictionary:(NSDictionary*)dictionary;
+ (NSArray*)arrayUsingJson:(NSArray*)array;

@end
