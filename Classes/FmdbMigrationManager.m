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

@implementation FmdbMigrationManager

@synthesize db=db_, currentVersion=currentVersion_, migrations=migrations_;

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
	
	FMResultSet *rs = [db_ executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@", tableName]];
	if([rs next]) {
		currentVersion_ = [rs intForColumn:@"version"];
		[rs close];
	} else {
		currentVersion_ = 0;
		[rs close];
		[self.db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ DEFAULT VALUES", tableName]];
	}
}

- (NSString *)schemaMigrationsTableName {
	return @"schema_info";
}

- (void)performMigrations {
	NSInteger i;
	for(i = self.currentVersion; i < [self.migrations count]; ++i)
	{
		FmdbMigration *migration = [self.migrations objectAtIndex:i];
		[migration upWithDatabase:self.db];
	}
}

- (id)initWithDatabase:(FMDatabase *)db {
	if ([super init]) {
		self.db = db;
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
