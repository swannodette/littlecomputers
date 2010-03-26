#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import "LCURLRequest.h"

@class LCImageDownloadQueue;

@protocol LCImageDownloadQueueRequester <NSObject>
@required
- (void) queueDidLoadImage:(UIImage*)image;
- (void) queueDidFailToLoadImage:(NSString*)imageUrl withError:(NSError*)error;
@end

@interface LCImageDownloadQueue : NSObject <LCURLRequestDelegate>
{
  BOOL                        isDownloading;
  id                          delegate;
@private
  NSMutableArray              *queue;
}

+ (LCImageDownloadQueue *) sharedQueue;

- (void) queueImage:(NSString*)imageURL forRequester:(id)requester;

@end
