#import <UIKit/UIKit.h>
#import "LCURLConnection.h"

@class LCImageDownloadQueue;

@protocol LCImageDownloadQueueRequester <NSObject>
@required
- (void) queuedidLoadImage:(UIImage*)image;
- (void) queueDidFailToLoadImage:(NSString*)imageUrl withError:(NSError*)error;
@end

@interface LCImageDownloadQueue : NSObject <LCURLConnectionDelegate>
{
  BOOL                        isDownloading;
  NSMutableArray              *queue;
}

+ (LCImageDownloadQueue *) sharedQueue;

- (void) queueImage:(NSString*)imageURL forRequester:(id)requester;

@end
