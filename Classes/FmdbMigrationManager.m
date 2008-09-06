//
//  FmdbMigrationManager.h
//  FmdbMigrationManager
//
//  Created by Dr Nic Williams on 2008-09-06.
//  Copyright 2008 Mocra and Dr Nic Williams. All rights reserved.
//

#import "FmdbMigrationManager.h"


@implementation FmdbMigrationManager

@synthesize db;

- (id)initWithDatabase:(FMDatabase *)sqliteDatabase {
  if ([super init]) {
    db = sqliteDatabase;
    return self;
  }
  return nil;
}

- (void)createTable:(NSString *)tableName {
  NSString *cmd = [@"create table " stringByAppendingString:tableName];
  [db executeUpdate:[cmd stringByAppendingString:@" (id integer)"]];
}
@end


// This initialization function gets called when we import the Ruby module.
// It doesn't need to do anything because the RubyCocoa bridge will do
// all the initialization work.
// The rbiphonetest test framework automatically generates bundles for 
// each objective-c class containing the following line. These
// can be used by your tests.
void Init_FmdbMigrationManager() { }
