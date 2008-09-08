//
//  FmdbMigrationManager.h
//  FmdbMigrationManager
//
//  Created by Dr Nic Williams on 2008-09-06.
//  Copyright 2008 Mocra and Dr Nic Williams. All rights reserved.
//

#import "FmdbMigrationManager.h"
#import "FmdbMigration.h"
#import "FmdbMigrationColumn.h"
#import "FMResultSet.h"

#ifndef INVALID_VERSION_NUMBER
#define INVALID_VERSION_NUMBER -1
#endif

@implementation FmdbMigrationManager

@synthesize db=db_, migrations=migrations_;

+ (id)executeForDatabase:(FMDatabase *)db withMigrations:(NSArray *)migrations {
	FmdbMigrationManager *manager = [[[self alloc] initWithDatabase:db] autorelease];
	manager.migrations = migrations;
	[manager executeMigrations];
	return manager;
}

- (void)executeMigrations {
	[self initializeSchemaMigrationsTable];
	[self performMigrations];
}

#pragma mark -
#pragma mark Internal methods

- (void)initializeSchemaMigrationsTable {
	// create schema_info table if doesn't already exist
	NSString *tableName = [self schemaMigrationsTableName];
	NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (version INTEGER unique default 0)", tableName];
	[db_ executeUpdate:sql];
	// TODO: add index on version column 'unique_schema_migrations'
	
	[self currentVersion]; // generates first version or stores version in currentVersion_
}

- (void)performMigrations {
	NSInteger i;
	for(i = self.currentVersion; i < [self.migrations count]; ++i)
	{
		FmdbMigration *migration = [self.migrations objectAtIndex:i];
		[migration upWithDatabase:self.db];
		[self recordVersionStateAfterMigrating:i + 1];
		currentVersion_ = i + 1;
	}
}

- (NSInteger)currentVersion
{
	if(currentVersion_ == INVALID_VERSION_NUMBER)	{
		NSString *tableName = [self schemaMigrationsTableName];
		FMResultSet *rs = [db_ executeQuery:[NSString stringWithFormat:@"SELECT version FROM %@ ORDER BY version DESC", tableName]];
		if([rs next]) {
			currentVersion_ = [rs intForColumn:@"version"];
		} else {
			currentVersion_ = 0;
			[db_ executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ (version) VALUES (0)", tableName]];
		}
		[rs close];
	}
	return currentVersion_;
}

- (void)recordVersionStateAfterMigrating:(NSInteger)version {
	NSString *tableName = [self schemaMigrationsTableName];
	if (version < self.currentVersion) {
		[db_ executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE version = ?", tableName],
							[NSNumber numberWithInteger:version]];
	} else if (version > self.currentVersion) {
		[db_ executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ (version) VALUES (?)", tableName],
							[NSNumber numberWithInteger:version]];
	}
}

- (NSString *)schemaMigrationsTableName {
	return @"schema_info";
}

- (id)initWithDatabase:(FMDatabase *)db {
	if ([super init]) {
		self.db = db;
		currentVersion_ = INVALID_VERSION_NUMBER;
		return self;
	}
	return nil;
}

- (void)dealloc
{
	[db_ release];
	[migrations_ release];
	
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
