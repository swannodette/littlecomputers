//
//  LCURLConnection.m
//  iPickUp
//
//  Created by David Nolen on 8/4/08.
//  Copyright 2008 New York University. All rights reserved.
//

#import "LCURLConnection.h"

#ifdef JSON_SUPPORT
#import "JSON.h"
#endif

#pragma mark -
#pragma mark Private Methods

@interface LCURLConnection (private)
- (void) dataRequest:(NSString*)urlString;
@end

@implementation LCURLConnection (private)
- (void) dataRequest:(NSString*)urlString
{
  // TODO: First check if we have a network connection! - David
  
  // create the request
  NSString *encodedURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
  
  NSURL *encodedURL = [NSURL URLWithString:encodedURLString];
  NSURLRequest *theRequest = [NSURLRequest requestWithURL:encodedURL
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
  
  // TODO: temporary, for https connection to mobilekwan - David
  [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[encodedURL host]];
  
  // create the connection with the request
  // and start loading the data
  NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
  
  if(theConnection) 
  {
    if(receivedData != nil)
    {
      [receivedData release];
    }
    
    receivedData = [[NSMutableData data] retain];
  }
  else
  {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Could not establish connection", NSLocalizedDescriptionKey, nil];
    [self connection:nil didFailWithError:[NSError errorWithDomain:@"LCURLConnection" code:1 userInfo:dict]];
  }
}
@end

#pragma mark -
#pragma mark Public Methods

@implementation LCURLConnection

@synthesize delegate;

#pragma mark Init

- (id) initWithURL:(NSString*)urlString delegate:(id) aDelegate;
{
  self = [super init];
  
  if (self != nil) 
  {
    self.delegate = aDelegate;
    [self dataRequest:urlString];
  }
  return self;
}

#pragma mark NSURLConnection Delegate Methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  [receivedData setLength:0];
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [receivedData appendData:data];
}


- (void) connection:(NSURLConnection *)connection
   didFailWithError:(NSError *)error
{
  if([self.delegate respondsToSelector:@selector(connection:didFailWithError:)])
  {
    [self.delegate performSelector:@selector(connectionDidFinishLoading:) withObject:self withObject:error];
  }
  
  [connection release];
  [receivedData release];
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
  if([self.delegate respondsToSelector:@selector(connectionDidFinishLoading:)])
  {
    [self.delegate performSelector:@selector(connectionDidFinishLoading:) withObject:self];
  }
  
  [connection release];
}

#pragma mark Data Accessors

- (UIImage*) image
{
  return [UIImage imageWithData:receivedData];
}


- (NSString*) response
{
  return [NSString stringWithCString:[receivedData bytes] length:[receivedData length]];
}

#ifdef JSON_SUPPORT
- (id) jsonData
{
  NSString *jsonString = [NSString stringWithCString:[receivedData bytes] length:[receivedData length]];
  return [jsonString JSONValue];
}
#endif

#pragma mark Dealloc

- (void) dealloc
{
  [receivedData release];
  
  [super dealloc];
}

@end
