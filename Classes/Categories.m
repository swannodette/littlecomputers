#import "Categories.h"

@implementation NSDictionary (LittleComputers)

+ (NSDictionary*) read:(NSString*)name
{
  NSString *fileName = [NSString stringWithFormat:@"%@.plist", name];
  NSString *path;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  path = [rootPath stringByAppendingPathComponent:fileName];
#else
  path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
#endif
  if(path)
  {
    return [[NSDictionary alloc] initWithContentsOfFile:path];  
  }
  else 
  {
    NSLog(@"Could not read %@", fileName);
    return nil;
  }
}

+ (BOOL) write:(NSString*)name
{
  BOOL success = YES;
  NSString *errorDesc;
  NSString *fileName = [NSString stringWithFormat:@"%@.plist", name];
  NSString *path;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
  path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
#else
  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  path = [rootPath stringByAppendingPathComponent:fileName];
#endif
  NSData *data = [NSPropertyListSerialization dataFromPropertyList:self 
                                                            format:NSPropertyListXMLFormat_v1_0 
                                                  errorDescription:&errorDesc];
  if(data)
  {
    NSError *error;
    success = [data writeToFile:path options:NSAtomicWrite error:&error];
    if(!success) NSLog(@"Error writing plist: %@", error);
  }
  else 
  {
    NSLog(@"Error writing plist: %@", errorDesc);
    [errorDesc release];
    success = NO;
  }
  
  return success;
}

@end


@implementation NSArray (LittleComputers)

/*
+ (NSArray*) read:(NSString*)name
{
}

+ (NSArray*) write:(NSString*)name
{

}
*/

@end
