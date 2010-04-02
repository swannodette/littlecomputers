//
//  LCURLConnection.m
//  iPickUp
//
//  Created by David Nolen on 8/4/08.
//  Copyright 2008 New York University. All rights reserved.
//

#import "LCURLRequest.h"

#ifdef JSON_SUPPORT
#import "JSON.h"
#endif

#pragma mark -
#pragma mark NSDictionary URLHelpers Category

@implementation NSDictionary (NSDictionary_URLHelpers)

- (NSString*) toURLParameters
{
  NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
  NSArray *keys = [self allKeys];
  NSInteger count = [keys count];
  for(int i = 0; i < count; i++) {
    NSString *key = [keys objectAtIndex:i];
    id value = [self objectForKey:key];
    [result appendFormat:@"%@=%@", key, value];
    if(i < count-1) {
      [result appendString:@"&"];
    }
  }
  return result;
}

@end

#pragma mark -
#pragma mark Private Methods

@interface LCURLRequest (private)
- (void) dataRequest:(NSString*)aURL;
@end

@implementation LCURLRequest (private)

- (void) dataRequest:(NSString*)aURL
{
  NSString *encodedURLString = [aURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
  
  NSURL *encodedURL = [NSURL URLWithString:encodedURLString];
  NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:encodedURL
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
  [theRequest setHTTPMethod:method];
  if(headers) {
    for(NSString *header in headers) {
      [theRequest setValue:[headers objectForKey:header] forHTTPHeaderField:header];
    }
  }

  NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
  
  if(theConnection) {
    if(receivedData != nil) {
      [receivedData release];
    }
    receivedData = [[NSMutableData data] retain];
  } else {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Could not establish connection", NSLocalizedDescriptionKey, nil];
    [self connection:nil didFailWithError:[NSError errorWithDomain:@"LCURLConnection" code:1 userInfo:dict]];
  }
}

@end

#pragma mark -
#pragma mark Public Methods

@implementation LCURLRequest

#pragma mark Init

- (id) initWithURL:(NSString*)aURL delegate:(id)aDelegate;
{
  return [self initWithURL:aURL method:@"GET" parameters:nil headers:nil delegate:aDelegate];
}

- (id) initWithURL:(NSString*)aURL method:(NSString*)aMethod delegate:(id)aDelegate
{
  return [self initWithURL:aURL method:method parameters:nil headers:nil delegate:delegate];
}

- (id) initWithURL:(NSString*)aURL method:(NSString*)aMethod parameters:(NSDictionary*)theParameters delegate:(id)aDelegate
{
  return [self initWithURL:aURL method:method parameters:theParameters headers:nil delegate:delegate];
}

- (id) initWithURL:(NSString*)aURL method:(NSString*)aMethod parameters:(NSDictionary*)theParameters headers:(NSDictionary*)theHeaders delegate:(id)aDelegate
{
  if(self = [super init]) {
    urlString = [aURL copy];
    method = [aMethod copy];
    parameters = [theParameters retain];
    headers = [theHeaders retain]; 
    delegate = [aDelegate retain];
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

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  [connection release];
  if([delegate respondsToSelector:@selector(request:didFailWithError:)]) {
    [delegate performSelector:@selector(request:didFailWithError:) withObject:self withObject:error];
  }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
  [connection release];
  if([delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
    [delegate performSelector:@selector(requestDidFinishLoading:) withObject:self];
  }
}

#pragma mark Data Accessors

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
- (UIImage*) image
{
  return [UIImage imageWithData:receivedData];
}
#else
- (NSImage*) image
{
  return [[[NSImage alloc] initWithData:receivedData] autorelease];
}
#endif

- (NSString*) response
{
  // might need to add string terminator ? - David
  return [NSString stringWithCString:[receivedData bytes] encoding:NSUTF8StringEncoding];
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
  [urlString release];
  urlString = nil;
  [method release];
  method = nil;
  [headers release];
  headers = nil;
  [receivedData release];
  [super dealloc];
}

@end
