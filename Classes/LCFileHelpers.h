// if you want gzip/zip suport you need to uncomment the ZLIB_SUPPORT define
// and make sure to add -lz to the Other Linker Flags in the build tab
// your project target (get info on your project target to find it)
// Thanks to Martin Ceperly.

//#define ZLIB_SUPPORT // don't uncomment this until you add the -lz linker flag to your project target

#ifdef ZLIB_SUPPORT
#import "zlib.h"
#endif

#import <Foundation/Foundation.h>

@interface LCFileHelpers : NSObject
{
}

+ (NSArray*) allDocuments;
+ (NSString*) pathToFileInDocuments:(NSString*)fileName;

#ifdef ZLIB_SUPPORT
+ (BOOL) ungzipFile: (NSString *)sourceFilenameString toDestination:(NSString *)destFilenameString;
#endif

@end