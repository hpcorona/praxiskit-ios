//
//  PaginadorConsulta.h
//  Piconfirm
//
//  Created by Hilario Perez Corona on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PaginadorConsulta : NSObject {
  
  int dummy_count;
  NSMutableArray *dummy_rows;
  
}

@property int pageSize;
@property (readonly) sqlite3* db;
@property (nonatomic) NSString* querySql;
@property (nonatomic) NSString* countSql;

- (id)initWithPageSize:(int)pageSize andDatabase:(sqlite3*)db;

- (void)reload;

- (int)count;

- (id)objectAtIndex:(int)idx;

- (id)makeRow:(sqlite3_stmt*)statement;

@end
