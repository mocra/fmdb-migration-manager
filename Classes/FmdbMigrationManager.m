//
//  FmdbMigrationManager.h
//  FmdbMigrationManager
//
//  Created by Dr Nic Williams on 2008-09-06.
//  Copyright 2008 Mocra and Dr Nic Williams. All rights reserved.
//

#import "FmdbMigrationManager.h"


@implementation FmdbMigrationManager

@synthesize db=db_;

- (id)initWithDatabase:(FMDatabase *)db {
  if ([super init]) {
    db_ = db;
    return self;
  }
  return nil;
}

- (void)createTable:(NSString *)tableName {
  NSString *sql = [NSString stringWithFormat:@"create table %@ (id integer primary key autoincrement)", tableName];
  [db_ executeUpdate:sql];
}

- (void)dropTable:(NSString *)tableName {
  NSString *sql = [NSString stringWithFormat:@"drop table if exists %@", tableName];
  [db_ executeUpdate:sql];
}

- (void)dealloc
{
 [db_ close];
 [db_ release];
 
 [super dealloc];
}
@end


// This initialization function gets called when we import the Ruby module.
// It doesn't need to do anything because the RubyCocoa bridge will do
// all the initialization work.
// The rbiphonetest test framework automatically generates bundles for 
// each objective-c class containing the following line. These
// can be used by your tests.
void Init_FmdbMigrationManager() { }
