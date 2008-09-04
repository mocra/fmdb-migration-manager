#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class FMDatabase;
@class FMStatement;

@interface FMResultSet : NSObject {
    FMDatabase *parentDB;
    FMStatement *statement;
    
    NSString *query;
    NSMutableDictionary *columnNameToIndexMap;
    BOOL columnNamesSetup;
}


+ (id) resultSetWithStatement:(FMStatement *)statement usingParentDatabase:(FMDatabase*)aDB;

- (void) close;

- (NSString *)query;
- (void)setQuery:(NSString *)value;

- (FMStatement *)statement;
- (void)setStatement:(FMStatement *)value;

- (void)setParentDB:(FMDatabase *)newDb;

- (BOOL) next;

- (int) intForColumn:(NSString*)columnName;
- (int) intForColumnIndex:(int)columnIdx;

- (long) longForColumn:(NSString*)columnName;
- (long) longForColumnIndex:(int)columnIdx;

- (BOOL) boolForColumn:(NSString*)columnName;
- (BOOL) boolForColumnIndex:(int)columnIdx;

- (double) doubleForColumn:(NSString*)columnName;
- (double) doubleForColumnIndex:(int)columnIdx;

- (NSString*) stringForColumn:(NSString*)columnName;
- (NSString*) stringForColumnIndex:(int)columnIdx;

- (NSDate*) dateForColumn:(NSString*)columnName;
- (NSDate*) dateForColumnIndex:(int)columnIdx;

- (NSData*) dataForColumn:(NSString*)columnName;
- (NSData*) dataForColumnIndex:(int)columnIdx;

- (void) kvcMagic:(id)object;

@end
