//
//  Data.h
//  PraxisKit
//
//  Created by Hilario Perez Corona on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Data : NSObject

+ (NSDictionary*)loadPlist:(NSString*)name;
+ (sqlite3*)openDatabase:(NSString*)name;

@end
