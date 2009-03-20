//
//  MyCustomView.m
//  Form
//
//  Created by David Nolen on 2/24/09.
//  Copyright 2009 David Nolen. All rights reserved.
//

#import "MyCustomView.h"


@implementation MyCustomView


- (id)initWithFrame:(CGRect)frame 
{
  if (self = [super initWithFrame:frame]) 
  {
    // Initialization code
  }
  return self;
}


- (void)drawRect:(CGRect)rect 
{
  // Grab the drawing context
  CGContextRef ctxt = UIGraphicsGetCurrentContext();
  
  // Set red stroke
  CGContextSetRGBStrokeColor(ctxt, 1.0, 0.0, 0.0, 1.0);
  CGContextSetRGBFillColor(ctxt, 0.0, 0.0, 1.0, 1.0);
  
  // begin a path
  CGContextSaveGState(ctxt);

  CGContextSetShadow(ctxt, CGSizeMake(30, -30), 50);

  CGContextBeginPath(ctxt);
  CGContextMoveToPoint(ctxt, 50, 320);
  CGContextAddLineToPoint(ctxt, 50, 200);
  CGContextAddLineToPoint(ctxt, 80, 200);
  CGContextAddCurveToPoint(ctxt, 40, 50, 60, 50, 120, 50);
  CGContextAddCurveToPoint(ctxt, 260, 50, 280, 50, 240, 200);
  CGContextAddLineToPoint(ctxt, 270, 200);
  CGContextAddLineToPoint(ctxt, 270, 320);
  CGContextClosePath(ctxt);

  // consumes the last path
  CGContextFillPath(ctxt);
  
  // get rid of the shadow
  CGContextRestoreGState(ctxt);

  CGContextSetLineWidth(ctxt, 5);
  CGContextBeginPath(ctxt);
  CGContextMoveToPoint(ctxt, 50, 320);
  CGContextAddLineToPoint(ctxt, 50, 200);
  CGContextAddLineToPoint(ctxt, 80, 200);
  CGContextAddCurveToPoint(ctxt, 40, 50, 60, 50, 120, 50);
  CGContextAddCurveToPoint(ctxt, 260, 50, 280, 50, 240, 200);
  CGContextAddLineToPoint(ctxt, 270, 200);
  CGContextAddLineToPoint(ctxt, 270, 320);
  CGContextClosePath(ctxt);

  // consumes the last path
  CGContextStrokePath(ctxt);
}


- (void)dealloc 
{
  [super dealloc];
}


@end
