#import <Foundation/Foundation.h>

@interface LCFileHelpers : NSObject
{
}

+ (NSArray*) allDocuments;
+ (NSString*) pathToFileInDocuments:(NSString*)fileName;

@end
