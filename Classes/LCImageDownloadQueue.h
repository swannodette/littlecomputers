#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import "LCURLRequest.h"

@class LCImageDownloadQueue;

@protocol LCImageDownloadQueueRequester <NSObject>
@required
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
- (void) queueDidLoadImage:(UIImage*)image;
#else
- (void) queueDidLoadImage:(NSImage*)image;
#endif
- (void) queueDidFailToLoadImage:(NSString*)imageUrl withError:(NSError*)error;
@end

@interface LCImageDownloadQueue : NSObject <LCURLRequestDelegate>
{
  id                          delegate;
@private
  BOOL                        isDownloading;
  NSMutableArray              *queue;
}

+ (LCImageDownloadQueue *) sharedQueue;
- (void) queueImage:(NSString*)imageURL forRequester:(id)requester;

@end
