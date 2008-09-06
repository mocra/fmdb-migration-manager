//
//  FmdbMigrationColumn.m
//  fmdb-migration-manager
//
//  Created by Dr Nic on 6/09/08.
//  Copyright 2008 Mocra. All rights reserved.
//

#import "FmdbMigrationColumn.h"


@implementation FmdbMigration

- (void)createTable:(NSString *)tableName {
  NSString *sql = [NSString stringWithFormat:@"create table %@ (id integer primary key autoincrement)", tableName];
  [db_ executeUpdate:sql];
}

- (void)dropTable:(NSString *)tableName {
  NSString *sql = [NSString stringWithFormat:@"drop table if exists %@", tableName];
  [db_ executeUpdate:sql];
}


@end
