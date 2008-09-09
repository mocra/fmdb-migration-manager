//
//  FmdbMigrationColumn.h
//  fmdb-migration-manager
//
//  Created by Dr Nic on 6/09/08.
//  Copyright 2008 Mocra. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FmdbMigrationColumn : NSObject {
	NSString *columnName_;
	NSString *columnType_;
	id defaultValue_;
}
@property (retain) NSString *columnName;
@property (retain) NSString *columnType;
@property (retain) id defaultValue;

+ (FmdbMigrationColumn*)columnWithColumnName:(NSString*)columnName
                                  columnType:(NSString*)columnType;
+ (FmdbMigrationColumn*)columnWithColumnName:(NSString*)columnName
                                  columnType:(NSString*)columnType
                                defaultValue:(id)defaultValue;

// Used for sql queries "ALTER TABLE table_name ADD COLUMN [column sqlDefinition]"
- (NSString *)sqlDefinition;

// Used for sql queries to display the column type, i.e.
//  * type ::=	typename |
//  *           typename ( number ) |
//  *           typename ( number , number )
- (NSString *)columnTypeDefinition;
@end
