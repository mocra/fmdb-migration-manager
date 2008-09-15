//
//  FmdbMigrationColumn.m
//  fmdb-migration-manager
//
//  Created by Dr Nic on 6/09/08.
//  Copyright 2008 Mocra. All rights reserved.
//

#import "FmdbMigration.h"


@implementation FmdbMigration
@synthesize db=db_;

+ (id)migration {
	return [[[self alloc] init] autorelease];
}

#pragma mark -
#pragma mark up/down methods

- (void)up 
{
	NSLog([NSString stringWithFormat:@"%s: -up method not implemented", NSStringFromClass([self class])]);
}

- (void)down 
{
	NSLog([NSString stringWithFormat:@"%s: -down method not implemented", NSStringFromClass([self class])]);
}

- (void)upWithDatabase:(FMDatabase *)db 
{
	self.db = db;
	[self up];
}
- (void)downWithDatabase:(FMDatabase *)db 
{
	self.db = db;
	[self down];
}

#pragma mark -
#pragma mark Helper methods for manipulating database schema

- (void)createTable:(NSString *)tableName withColumns:(NSArray *)columns 
{
	[self createTable:tableName];
	for (FmdbMigrationColumn *migrationColumn in columns) {
		[self addColumn:migrationColumn forTableName:tableName];
	}
}

- (void)createTable:(NSString *)tableName 
{
	NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer primary key autoincrement)", tableName];
	[db_ executeUpdate:sql];
}

- (void)dropTable:(NSString *)tableName 
{
	NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
	[db_ executeUpdate:sql];
}

- (void)addColumn:(FmdbMigrationColumn *)column forTableName:(NSString *)tableName 
{
	NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@", tableName, [column sqlDefinition]];
	[db_ executeUpdate:sql];
}


#pragma mark -
#pragma mark Unit testing helpers

- (id)initWithDatabase:(FMDatabase *)db 
{
	if ([super init]) {
		self.db = db;
		return self;
	}
	return nil;
}

- (void)dealloc
{
	[db_ release];
	
	[super dealloc];
}


@end
