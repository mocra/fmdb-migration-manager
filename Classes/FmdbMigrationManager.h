//
//  FmdbMigrationManager.h
//  FmdbMigrationManager
//
//  Created by Dr Nic Williams on 2008-09-06.
//  Copyright 2008 Mocra and Dr Nic Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface FmdbMigrationManager : NSObject {
  FMDatabase *db_;
  int currentVersion_;
}
@property (retain) FMDatabase *db;
@property (assign) int currentVersion;

+ (id)executeForDatabase:(FMDatabase *)db;

- (id)initWithDatabase:(FMDatabase *)db;

- (void)executeMigrations;
- (int)currentVersion;

#pragma mark -
#pragma mark Internal methods

- (void)initializeSchemaMigrationsTable;
- (NSString *)schemaMigrationsTableName;
@end
