//
//  LCURLConnection.h
//  iPickUp
//
//  Created by David Nolen on 8/4/08.
//  Copyright 2008 New York University. All rights reserved.
//

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

//#define JSON_SUPPORT // uncomment if you've included the JSON.framework to your project

@class LCURLRequest;

@protocol LCURLRequestDelegate <NSObject>
@required
- (void) requestDidFinishLoading:(LCURLRequest*)request;
- (void) request:(LCURLRequest*)request didFailWithError:(NSError*)error;
@end

@interface NSDictionary ( NSDictionary_URLHelpers )
- (NSString*) toURLParameters;
@end

@interface LCURLRequest : NSObject 
{
@private
  id                  delegate;           // store a reference to the delegate
  NSString            *method;            // the HTTP method
  NSDictionary        *headers;            // the headers
  NSMutableData       *receivedData;      // internal NSData object
}

- (id) initWithURL:(NSString*)urlString delegate:(id)aDelegate;
- (id) initWithURL:(NSString*)urlString method:(NSString*)aMethod delegate:(id)aDelegate;
- (id) initWithURL:(NSString*)urlString method:(NSString*)aMethod headers:(NSDictionary*)theHeaders delegate:(id)aDelegate;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
- (UIImage*) image;
#else
- (NSImage*) image;
#endif

- (NSString*) response;

#ifdef JSON_SUPPORT
- (id) jsonData;
#endif

@end
