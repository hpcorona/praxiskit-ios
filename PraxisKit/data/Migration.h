//
//  Migration.h
//  PraxisKit
//
//  Created by Hilario Perez Corona on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Migration : NSObject {
  sqlite3* db;
  int version;
}

- (id)init:(sqlite3*)_db;
- (void)update:(NSString*)plist;

@end
