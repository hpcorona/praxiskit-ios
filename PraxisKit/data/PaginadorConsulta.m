//
//  PaginadorConsulta.m
//  Piconfirm
//
//  Created by Hilario Perez Corona on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaginadorConsulta.h"

@implementation PaginadorConsulta 

@synthesize db = _db;
@synthesize pageSize, querySql, countSql;

- (id)initWithPageSize:(int)_pageSize andDatabase:(sqlite3 *)db {
  self = [super init];
  if (self) {
    _db = db;
    self.pageSize = _pageSize;
    querySql = @"";
    countSql = @"";
    dummy_count = 0;
    dummy_rows = [[NSMutableArray alloc] initWithCapacity:100];
  }
  return self;
}

- (void)reload {
  [dummy_rows removeAllObjects];
  dummy_count = 0;
  
  [self runCountQuery];
}

- (void)runCountQuery {
  sqlite3_stmt* statement;
  if (sqlite3_prepare_v2(_db, [countSql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
    NSLog(@"No se pudo contar los registros: %@",querySql);
    return;
  }
  
  if (sqlite3_step(statement) == SQLITE_ROW) {
    dummy_count = sqlite3_column_int(statement, 0);
  }
  sqlite3_finalize(statement);
}

- (void)fetchPageIncludingIndex:(int)idx {
  int page = idx / pageSize;
  int offset = page * pageSize;
  
  NSString* fetchPageQry = [NSString stringWithFormat:@"%@ limit %d,%d",querySql,offset,pageSize];
  
  sqlite3_stmt* statement;
  if (sqlite3_prepare_v2(_db, [fetchPageQry UTF8String], -1, &statement, NULL) != SQLITE_OK) {
    NSLog(@"No se pudo ejecutar el query: %@",fetchPageQry);
    return;
  }
  
  while (sqlite3_step(statement) == SQLITE_ROW) {
    id row = [self makeRow:statement];
    
    [dummy_rows replaceObjectAtIndex:offset withObject:row];
    
    offset += 1;
  }
  sqlite3_finalize(statement);
  
}

- (int)count {
  return dummy_count;
}

- (id)objectAtIndex:(int)idx {
  if (idx >= dummy_count || idx < 0) {
    @throw [NSException exceptionWithName:@"Data index out of bounds" reason:[NSString stringWithFormat:@"You are asking for the index %d and we only give you the elements between 0 and %d-1 from the data set",idx,dummy_count] userInfo:nil];
  }
  
  // Nos aseguramos de que tengamos las paginas suficientes de datos
  [self fillNeededPages:idx];

  id element = [dummy_rows objectAtIndex:idx];
  if (element == [NSNull null]) {
    [self fetchPageIncludingIndex:idx];
    
    element = [dummy_rows objectAtIndex:idx];
  }

  return element;
}

- (void)fillNeededPages:(int)idx {
  while (idx >= [dummy_rows count]) {
    for (int i = 0; i < pageSize; i++) {
      [dummy_rows addObject:[NSNull null]];
    }
  }
}

- (id)makeRow:(sqlite3_stmt *)statement {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}

@end
