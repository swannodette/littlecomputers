#import <Foundation/Foundation.h>

@interface NSDictionary (LittleComputers)
+ (NSDictionary*) read:(NSString*)name;
+ (BOOL) write:(NSString*)name;
@end

@interface NSArray (LittleComputers)
+ (NSArray*) read:(NSString*)name;
+ (BOOL) write:(NSString*)name;
@end
