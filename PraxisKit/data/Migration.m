//
//  Migration.m
//  PraxisKit
//
//  Created by Hilario Perez Corona on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Migration.h"
#import "Data.h"

@implementation Migration

- (id)init:(sqlite3 *)_db {
  self = [super init];
  if (self) {
    db = _db;
    version = -1;
  }
  return self;
}

- (void)update:(NSString*)plist {
  int nextVersion = [self fetchSchemaVersionOrInitialize];
  if (nextVersion == -1) {
    NSLog(@"Internal error");
    return;
  }
  
  NSLog(@"Your schema version is %d",nextVersion);
  
  NSDictionary* dct = [Data loadPlist:plist];
  NSArray* migrations = [dct objectForKey:@"Migration"];
  
  NSLog(@"The migration database has version %d",[migrations count]);
  
  for (int i = nextVersion; i < [migrations count]; i++) {
    NSArray *commands = [migrations objectAtIndex:i];
    NSLog(@"Upgrading to version %d with %d commands",(i+1),[commands count]);
    
    for (int j = 0; j < [commands count]; j++) {
      NSString *cmd = [commands objectAtIndex:j];
      if (sqlite3_exec(db, [cmd UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
        NSLog(@"Command %d failed, continuint anyway: %@",j,cmd);
      } else {
        NSLog(@"Command %d succeeded: %@",j,cmd);
      }
    }
  }
  
  NSLog(@"Updating praxis version schema");
  version = [migrations count];
  [self updateVersion];
  
  NSLog(@"Done.");
}

- (int)fetchSchemaVersionOrInitialize {
  sqlite3_stmt* statement;
  
  if (sqlite3_prepare_v2(db, "SELECT name FROM sqlite_master WHERE type='table' AND name='praxis_version';", -1, &statement, NULL) != SQLITE_OK) {
    NSLog(@"Internal fatal error while trying to fetch tables");
    version = -1;
    return version;
  }
  
  if (sqlite3_step(statement) == SQLITE_ROW) {
    sqlite3_finalize(statement);
    return [self fetchSchemaVersion];
  }
  sqlite3_finalize(statement);
  
  [self initializeSchemaVersion];
  return version;
}

- (int)fetchSchemaVersion {
  sqlite3_stmt* statement;
  
  if (sqlite3_prepare_v2(db, "SELECT version FROM praxis_version;", -1, &statement, NULL) != SQLITE_OK) {
    NSLog(@"Could not retrieve version from praxis table, trying to insert the first version...");
    if (sqlite3_exec(db, "INSERT INTO praxis_version (version) VALUES (0);", NULL, NULL, NULL) != SQLITE_OK) {
      NSLog(@"Impossible to create first record");
      return -1;
    } else {
      version = 0;
      return version;
    }
  }
  
  version = -1;
  if (sqlite3_step(statement) == SQLITE_ROW) {
    version = sqlite3_column_int(statement, 0);
  } else {
    NSLog(@"No version record found");
  }
  sqlite3_finalize(statement);
  
  return version;
}

- (void)initializeSchemaVersion {
  if (sqlite3_exec(db, "CREATE TABLE praxis_version (version int);", NULL, NULL, NULL) != SQLITE_OK) {
    NSLog(@"Could not create database table praxis_version");
    return;
  }
  
  if (sqlite3_exec(db, "INSERT INTO praxis_version (version) VALUES (0);", NULL, NULL, NULL) != SQLITE_OK) {
    NSLog(@"Could not setup the first record on the praxis_version table");
    return;
  }
  
  version = 0;
}

- (void)updateVersion {
  const char* qry = sqlite3_mprintf("UPDATE praxis_version SET version = %d;", version);
  
  if (sqlite3_exec(db, qry, NULL, NULL, NULL) != SQLITE_OK) {
    NSLog(@"Could not update version number on praxis version");
  }
}

@end
