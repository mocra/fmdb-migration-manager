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
}
@property (retain) FMDatabase *db;

- (id)initWithDatabase:(FMDatabase *)sqliteDatabase;
- (void)createTable:(NSString *)tableName;
@end
