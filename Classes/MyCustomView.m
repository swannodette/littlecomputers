//
//  MyCustomView.m
//  RotateMe
//
//  Created by David Nolen on 2/16/09.
//  Copyright 2009 David Nolen. All rights reserved.
//

#import "MyCustomView.h"

#define kAccelerometerFrequency        10 //Hz

@implementation MyCustomView


- (id)initWithFrame:(CGRect)frame 
{
  if (self = [super initWithFrame:frame]) 
  {
  }
  return self;
}

- (void) awakeFromNib
{
  // you have to initialize your view here since it's getting
  // instantiated by the nib
  squareSize = 100.0f;
  twoFingers = NO;
  rotation = 0.5f;
  // You have to explicity turn on multitouch for the view
  self.multipleTouchEnabled = YES;
  
  // configure for accelerometer
  [self configureAccelerometer];
}


-(void)configureAccelerometer
{
  UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
  
  if(theAccelerometer)
  {
    theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;
    theAccelerometer.delegate = self;
  }
  else
  {
    NSLog(@"Oops we're not running on the device!");
  }
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
  UIAccelerationValue x, y, z;
  x = acceleration.x;
  y = acceleration.y;
  z = acceleration.z;
  
  // Do something with the values.
  xField.text = [NSString stringWithFormat:@"%.5f", x];
  yField.text = [NSString stringWithFormat:@"%.5f", y];
  zField.text = [NSString stringWithFormat:@"%.5f", z];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  if([touches count] > 1)
  {
    twoFingers = YES;
  }
  
  // tell the view to redraw
  [self setNeedsDisplay];
}


- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
  // update rotate
  UITouch *first = (UITouch*)[[touches allObjects] objectAtIndex:0];
  
  CGPoint now = [first locationInView:[first view]];
  CGPoint then = [first previousLocationInView:[first view]];
  
  CGFloat dy = now.y - then.y;
  
  if(dy >= 0.0f)
  {
    rotation += 0.1f;   
  }
  else
  {
    rotation -= 0.1f;
  }
  
  // tell the view to redraw
  [self setNeedsDisplay];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  // reset the var
  twoFingers = NO;
  
  // tell the view to redraw
  [self setNeedsDisplay];
}


- (void) drawRect:(CGRect)rect 
{
  NSLog(@"drawRect");
  
  CGFloat centerx = rect.size.width/2;
  CGFloat centery = rect.size.height/2;
  CGFloat half = squareSize/2;
  CGRect theRect = CGRectMake(-half, -half, squareSize, squareSize);
  
  // Grab the drawing context
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // like Processing pushMatrix
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, centerx, centery);
  
  // Uncomment to see the rotated square
  CGContextRotateCTM(context, rotation);
  
  // Set red stroke
  CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
  
  // Set different based on multitouch
  if(!twoFingers)
  {
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);    
  }
  else
  {
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1.0);
  }
  
  // Draw a rect with a red stroke
  CGContextFillRect(context, theRect);
  CGContextStrokeRect(context, theRect);
  
  // like Processing popMatrix
  CGContextRestoreGState(context);
}


- (void) dealloc 
{
  [super dealloc];
}


@end
