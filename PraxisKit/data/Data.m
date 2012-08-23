//
//  Data.m
//  PraxisKit
//
//  Created by Hilario Perez Corona on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Data.h"

@implementation Data

+ (NSDictionary*)loadPlist:(NSString *)name {
  NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
  return [[NSDictionary alloc] initWithContentsOfFile:filePath];
}

+ (sqlite3*)openDatabase:(NSString *)name {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDir = [paths objectAtIndex:0];
  NSString* databasePath = [documentsDir stringByAppendingPathComponent:name];
  
  sqlite3* _db;
  
  NSLog(@"Database: %@",databasePath);
  if (sqlite3_open([databasePath UTF8String], &_db) != SQLITE_OK) {
    NSLog(@"No se pudo abrir la base de datos");
    _db = nil;
  }
  
  return _db;
}

@end
