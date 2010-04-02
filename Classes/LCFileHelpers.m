#import "LCFileHelpers.h"

#ifdef ZLIB_SUPPORT
#define CHUNK_SIZE 256000 // 256K buffer in memory
#endif

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

#ifdef ZLIB_SUPPORT
+ (BOOL) ungzipFile: (NSString *)sourceFilenameString toDestination:(NSString *)destFilenameString
{
  const char *sourceFilename = [sourceFilenameString cStringUsingEncoding:NSUTF8StringEncoding];
  const char *destFilename = [destFilenameString cStringUsingEncoding:NSUTF8StringEncoding];
  
  unsigned char out[CHUNK_SIZE];
  
  gzFile theFile = gzopen(sourceFilename, "rb");
  if(theFile == NULL) {
    NSLog(@"error opening gz file");
    return NO;
  }
  
  FILE *outFile = fopen(destFilename, "wb");
  if(outFile == NULL) {
    NSLog(@"error opening destination file");
    return NO;
  }
  
  long totalBytes = 0;
  int readResult = 0;
  
  do {
    readResult = gzread(theFile, out, CHUNK_SIZE);
    if(readResult > 0) {
      fwrite(out, 1, readResult, outFile);
      totalBytes += readResult;
    }
  } while (readResult > 0);
  
  gzclose(theFile);
  fclose(outFile);
  
  if(readResult == 0) {
    NSLog(@"successfully uncompressed gz file, resulting file is %d bytes", totalBytes);
    return YES;
  } else {
    NSLog(@"error reading data from gz file");
    return NO;
  }
}
#endif

@end
