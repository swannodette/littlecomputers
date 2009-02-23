//
//  MyCustomView.h
//  RotateMe
//
//  Created by David Nolen on 2/16/09.
//  Copyright 2009 David Nolen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyCustomView : UIView <UIAccelerometerDelegate> 
{
  CGFloat                    squareSize;
  CGFloat                    rotation;
  CGFloat                    then;
  CGColorRef                 aColor;
  BOOL                       twoFingers;
  BOOL                       newTouch;
  
  IBOutlet UILabel           *xField;
  IBOutlet UILabel           *yField;
  IBOutlet UILabel           *zField;
}

- (void) configureAccelerometer;

@end
