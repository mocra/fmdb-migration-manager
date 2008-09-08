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
	NSArray *migrations_;
	NSInteger currentVersion_;
}
@property (retain) FMDatabase *db;
@property (retain) NSArray *migrations;
@property (assign,readonly) NSInteger currentVersion;

+ (id)executeForDatabase:(FMDatabase *)db withMigrations:(NSArray *)migrations;

- (id)initWithDatabase:(FMDatabase *)db;
- (void)executeMigrations;
- (int)currentVersion;

#pragma mark -
#pragma mark Internal methods

- (void)initializeSchemaMigrationsTable;
- (NSString *)schemaMigrationsTableName;
- (void)performMigrations;
- (void)recordVersionStateAfterMigrating:(NSInteger)version;
@end
