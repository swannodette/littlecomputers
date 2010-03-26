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
- (void) dataRequest:(NSString*)urlString;
@end

@implementation LCURLRequest (private)

- (void) dataRequest:(NSString*)urlString
{
  NSString *encodedURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
  
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

- (id) initWithURL:(NSString*)urlString delegate:(id) aDelegate;
{
  self = [super init];
  if (self != nil)  {
    [self initWithURL:urlString method:@"GET" headers:nil delegate:delegate];
  }
  return self;
}

- (id) initWithURL:(NSString*)urlString method:(NSString*)method delegate:(id)delegate
{
  
}

- (id) initWithURL:(NSString*)urlString method:(NSString*)method headers:(NSDictionary*)headers delegate:(id)delegate
{
  self = [super init];
  if(self != nil) {
    delegate = aDelegate;
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
  if([delegate respondsToSelector:@selector(connection:didFailWithError:)]) {
    [delegate performSelector:@selector(connection:didFailWithError:) withObject:self withObject:error];
  }
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
  [connection release];
  if([delegate respondsToSelector:@selector(connectionDidFinishLoading:)]) {
    [delegate performSelector:@selector(connectionDidFinishLoading:) withObject:self];
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
  return [NSImage initi
}
#endif


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
