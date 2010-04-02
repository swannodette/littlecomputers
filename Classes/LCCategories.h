#import <Foundation/Foundation.h>

@interface NSString (LittleComputers)
+ (NSString*) template:(NSDictionary*)aDict;
@end

@interface NSDictionary (LittleComputers)
+ (NSDictionary*) read:(NSString*)name;
- (BOOL) write:(NSString*)name;
@end

@interface NSArray (LittleComputers)
+ (NSArray*) read:(NSString*)name;
- (BOOL) write:(NSString*)name;
@end