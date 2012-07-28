//
//  NSObject_Utils.h
//  Piconfirm
//
//  Created by Hilario Perez Corona on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../JSON/SBJson.h"

@interface NSData (NSData_ToUTF8String)

- (NSString*)UTF8String;

- (NSString*)ASCIIString;

- (id)JSONValue;

@end

@interface NSString (NSString_URLEncode)

- (NSString*)URLEncoded;

@end
