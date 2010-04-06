#import "LCCategories.h"

@implementation NSMutableString (LittleComputers)
- (NSString*) template:(NSDictionary*)aDict
{
  NSMutableString *mutableCopy = [NSMutableString stringWithString:self];
  for (NSString *key in aDict) {
    int len = [mutableCopy length];
    id value = [aDict objectForKey:key];
    if([value isKindOfClass:[NSNumber class]]) {
      value = [value stringValue];
    } else if (![value isKindOfClass:[NSString class]]) {
      continue;
    }
    [mutableCopy replaceOccurrencesOfString:[NSString stringWithFormat:@"{%@}",key] 
                                 withString:value
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, len)];
  }
  NSLog(@"done!");
  return mutableCopy;
}
@end


@implementation NSDictionary (LittleComputers)

+ (NSDictionary*) read:(NSString*)name
{
  NSString *fileName = [NSString stringWithFormat:@"%@.plist", name];
  NSString *path;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  path = [rootPath stringByAppendingPathComponent:fileName];
  // on the iPhone because of security restrictions you cannot write to the normal
  // resource path. so we first check if the file exists in the Documents directory
  // and if it doesn't it's the first time we've loaded the file, get it from the
  // bundle resource path instead
  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
  {
    path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
  }
#else
  path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
#endif
  if(path) {
    return [NSDictionary dictionaryWithContentsOfFile:path];  
  } else {
    NSLog(@"NSDictionary could not read %@", fileName);
    return nil;
  }
}

- (BOOL) write:(NSString*)name
{
  BOOL success = YES;
  NSString *errorDesc;
  NSString *fileName = [NSString stringWithFormat:@"%@.plist", name];
  NSString *path;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  path = [rootPath stringByAppendingPathComponent:fileName];
#else
  path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
#endif
  NSData *data = [NSPropertyListSerialization dataFromPropertyList:self 
                                                            format:NSPropertyListXMLFormat_v1_0 
                                                  errorDescription:&errorDesc];
  if(data) {
    NSError *error;
    success = [data writeToFile:path options:NSAtomicWrite error:&error];
    if(!success) NSLog(@"Error writing NSDictionary to plist: %@", error);
  } else {
    NSLog(@"Error serializing NSDictionary to xml: %@", errorDesc);
    [errorDesc release];
    success = NO;
  }
  
  return success;
}

@end


@implementation NSArray (LittleComputers)

+ (NSArray*) read:(NSString*)name
{
  NSString *fileName = [NSString stringWithFormat:@"%@.plist", name];
  NSString *path;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  path = [rootPath stringByAppendingPathComponent:fileName];
  // SEE NSDictionary +read
  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
    path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
  }
#else
  path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
#endif
  if(path) {
    return [NSArray arrayWithContentsOfFile:path];  
  } else {
    NSLog(@"NSArray could not read %@", fileName);
    return nil;
  }
}


- (BOOL) write:(NSString*)name
{
  BOOL success = YES;
  NSString *errorDesc;
  NSString *fileName = [NSString stringWithFormat:@"%@.plist", name];
  NSString *path;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  path = [rootPath stringByAppendingPathComponent:fileName];
#else
  path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
#endif
  NSData *data = [NSPropertyListSerialization dataFromPropertyList:self 
                                                            format:NSPropertyListXMLFormat_v1_0 
                                                  errorDescription:&errorDesc];
  if(data) {
    NSError *error;
    success = [data writeToFile:path options:NSAtomicWrite error:&error];
    if(!success) NSLog(@"Error writing NSArray to plist: %@", error);
  } else {
    NSLog(@"Error serializing NSArray to xml: %@", errorDesc);
    [errorDesc release];
    success = NO;
  }
  
  return success;
}

@end
