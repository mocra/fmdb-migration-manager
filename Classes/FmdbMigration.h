//
//  FmdbMigrationColumn.h
//  fmdb-migration-manager
//
//  Created by Dr Nic on 6/09/08.
//  Copyright 2008 Mocra. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FMDatabase.h"

@interface FmdbMigration : NSObject {
  FMDatabase *db_;
}
- (void)up;
- (void)down;

- (void)upWithDatabase:(FMDatabase *)db;
- (void)downWithDatabase:(FMDatabase *)db;

- (void)createTable:(NSString *)tableName;
- (void)dropTable:(NSString *)tableName;
@end
