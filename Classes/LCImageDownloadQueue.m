#import "LCImageDownloadQueue.h"
#import "LCURLRequest.h"

@interface LCImageDownloadQueue (private)
- (void) downloadNextImageInQueue;
- (void) downloadImage:(NSString*)imageURL;
@end

@implementation LCImageDownloadQueue

#pragma mark -
#pragma mark Class Methods

+ (LCImageDownloadQueue *) sharedQueue
{
  static LCImageDownloadQueue *sharedQueue = nil;
  if(!sharedQueue) {
    sharedQueue = [[LCImageDownloadQueue alloc] init];
  }
  return sharedQueue;
}

#pragma mark -
#pragma mark Init

- (id) init
{
  self = [super init];
  if (self != nil) {
    isDownloading = NO;    
    queue = [[NSMutableArray alloc] init];
  }
  return self;
}

#pragma mark -
#pragma mark Downloading


- (void) queueImage:(NSString*)imageURL forRequester:(id)requester
{
  [queue addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:imageURL, requester, nil]
                                               forKeys:[NSArray arrayWithObjects:@"url", @"requester", nil]]];
  [self downloadNextImageInQueue];
}
  

- (void) downloadNextImageInQueue
{
  if(!isDownloading && [queue count] > 0) {
    NSDictionary *nextImage = [queue objectAtIndex:0];
    [self downloadImage:[nextImage objectForKey:@"url"]];
  }
}


- (void) downloadImage:(NSString*)imageURL
{
  isDownloading = YES;
  [[LCURLRequest alloc] initWithURL:imageURL delegate:self];
}


- (void) requestDidFinishLoading:(LCURLRequest*)connection
{
  NSDictionary *downloadRequest = [queue objectAtIndex:0];
  id requester = [downloadRequest objectForKey:@"requester"];
  id theImage = [connection image];
  
  if([requester respondsToSelector:@selector(queueDidLoadImage:)]) {
    [requester performSelector:@selector(queueDidLoadImage:) withObject:theImage];
  }

  [queue removeObjectAtIndex:0]; 
  [connection release];
  
  isDownloading = NO;
  if([queue count] > 0)
  {
    [self downloadNextImageInQueue];
  }
}


- (void) request:(LCURLRequest*)connection didFailWithError:(NSError*)error
{
  NSDictionary *request = [queue objectAtIndex:0];
  id requester = [request objectForKey:@"requester"];
  NSString *url = [request objectForKey:@"url"];
  
  if([requester respondsToSelector:@selector(queueDidFailToLoadImage:withError:)]) {
    [requester performSelector:@selector(queueDidFailToLoadImage:withError:) withObject:url withObject:error];
  }
  
  [queue removeObjectAtIndex:0];
  [connection release];
  
  isDownloading = NO;
  [self downloadNextImageInQueue];
}

#pragma mark -
#pragma mark Dealloc

- (void) dealloc
{
  [queue release];
  [super dealloc];
}


@end
