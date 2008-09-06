//
//  FmdbMigrationColumn.m
//  fmdb-migration-manager
//
//  Created by Dr Nic on 6/09/08.
//  Copyright 2008 Mocra. All rights reserved.
//

#import "FmdbMigrationColumn.h"


@implementation FmdbMigrationColumn
@synthesize columnName=columnName_, columnType=columnType_, defaultValue=defaultValue_;
+ (FmdbMigrationColumn*)columnWithColumnName:(NSString*)columnName
                                  columnType:(NSString*)columnType
{
  return [[[FmdbMigrationColumn alloc] init] autorelease];
}

+ (FmdbMigrationColumn*)columnWithColumnName:(NSString*)columnName
                                  columnType:(NSString*)columnType
                                defaultValue:(id)defaultValue
{
  FmdbMigrationColumn* column = [self columnWithColumnName:columnName columnType:columnType];
  column.defaultValue = defaultValue;
  return column;
}

@end
