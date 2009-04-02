#import "LCImageDownloadQueue.h"
#import "LCURLConnection.h"


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
  
  if(!sharedQueue)
  {
    // first check if the user is loaded
    sharedQueue = [[LCImageDownloadQueue alloc] init];
  }
  
  return sharedQueue;
}

#pragma mark -
#pragma mark Init

- (id) init
{
  self = [super init];
  if (self != nil) 
  {
    isDownloading = NO;    
    queue = [[NSMutableArray alloc] init];
  }
  return self;
}

#pragma mark -
#pragma mark Downloading


- (void) queueImage:(NSString*)imageURL forRequester:(id)requester
{
  NSLog(@"queueImage %@", imageURL);
  // add this request to the queue
  [queue addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:imageURL, requester, nil]
                                               forKeys:[NSArray arrayWithObjects:@"url", @"requester", nil]]];
  [self downloadNextImageInQueue];
}
  

- (void) downloadNextImageInQueue
{
  if(!isDownloading && [queue count] > 0)
  {
    NSDictionary *nextImage = [queue objectAtIndex:0];
    [self downloadImage:[nextImage objectForKey:@"url"]];
  }
}


- (void) downloadImage:(NSString*)imageURL
{
  isDownloading = YES;
  // create a request!
  [[LCURLConnection alloc] initWithURL:imageURL delegate:self];
}


- (void) connectionDidFinishLoading:(LCURLConnection*)connection
{
  NSDictionary *downloadRequest = [queue objectAtIndex:0];
  id requester = [downloadRequest objectForKey:@"requester"];

  // get the image instance and return it
  UIImage *theImage = [connection image];

  // inform the requester
  if([requester respondsToSelector:@selector(queueDidLoadImage:)])
  {
    [requester performSelector:@selector(queueDidLoadImage:) withObject:self withObject:theImage];
  }

  // remove this request from the queue
  [queue removeObjectAtIndex:0]; 
  // release the connection
  [connection release];
  
  isDownloading = NO;
  
  // download the next one
  if([queue count] > 0)
  {
    [self downloadNextImageInQueue];
  }
}


- (void) connection:(LCURLConnection*)connection didFailWithError:(NSError*)error
{
  // return an error image
  NSLog(@"Image download error!, %@", error);
  
  NSDictionary *request = [queue objectAtIndex:0];
  id requester = [request objectForKey:@"requester"];
  NSString *url = [request objectForKey:@"url"];
  
  // dequeue the request
  [queue removeObjectAtIndex:0];
  [connection release];
  
  // pass the error image
  if([requester respondsToSelector:@selector(queue:didFailWithError:)])
  {
    [requester performSelector:@selector(queue:didFailWithError:) withObject:url withObject:error];
  }
  
  isDownloading = NO;
  
  // get the next one
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
