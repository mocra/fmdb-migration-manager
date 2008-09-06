//
//  FmdbMigrationColumn.m
//  fmdb-migration-manager
//
//  Created by Dr Nic on 6/09/08.
//  Copyright 2008 Mocra. All rights reserved.
//

#import "FmdbMigration.h"


@implementation FmdbMigration

+ (id)migration {
  return [[[self alloc] init] autorelease];
}

#pragma mark -
#pragma mark up/down methods

- (void)up {
  NSLog([NSString stringWithFormat:@"%s: -up method not implemented", [self className]]);
}

- (void)down {
  NSLog([NSString stringWithFormat:@"%s: -up method not implemented", [self className]]);
}

- (void)upWithDatabase:(FMDatabase *)db {
  db_ = db;
  [self up];
}
- (void)downWithDatabase:(FMDatabase *)db {
  db_ = db;
  [self down];
}

#pragma mark -
#pragma mark Helper methods for manipulating database schema

- (void)createTable:(NSString *)tableName {
  NSString *sql = [NSString stringWithFormat:@"create table %@ (id integer primary key autoincrement)", tableName];
  [db_ executeUpdate:sql];
}

- (void)dropTable:(NSString *)tableName {
  NSString *sql = [NSString stringWithFormat:@"drop table if exists %@", tableName];
  [db_ executeUpdate:sql];
}


#pragma mark -
#pragma mark Unit testing helpers

- (id)initWithDatabase:(FMDatabase *)db {
  if ([super init]) {
    self.db = db;
    return self;
  }
  return nil;
}

@end
