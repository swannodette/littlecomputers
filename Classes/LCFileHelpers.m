#import "LCFileHelpers.h"

@implementation LCFileHelpers

+ (NSArray*) allDocuments
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentDirectory = [(NSString*)[paths objectAtIndex:0] stringByAppendingFormat:@"/"];
  paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDirectory error:NULL];
  return paths;
}

+ (NSString*) pathToFileInDocuments:(NSString*)fileName
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  return [documentsDirectory stringByAppendingPathComponent:fileName];
}

@end
