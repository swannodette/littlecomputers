//
//  LCURLConnection.h
//  iPickUp
//
//  Created by David Nolen on 8/4/08.
//  Copyright 2008 New York University. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define JSON_SUPPORT // uncomment if you've included the JSON.framework to your project

@class LCURLConnection;


@protocol LCURLConnectionDelegate <NSObject>
@required
- (void) connectionDidFinishLoading:(LCURLConnection*)connection;
- (void) connection:(LCURLConnection*)connection didFailWithError:(NSError*)error;
@end


@interface NSDictionary ( NSDictionary_URLHelpers )
- (NSString*) toURLParameters;
@end


@interface LCURLConnection : NSObject 
{
  id                  delegate;           // store a reference to the delegate
  NSMutableData       *receivedData;      // internal NSData object
}

@property (nonatomic, assign) id delegate;

- (id) initWithURL:(NSString*)urlString delegate:(id)delegate;

- (UIImage*) image;
- (NSString*) response;

#ifdef JSON_SUPPORT
- (id) jsonData;
#endif

@end
