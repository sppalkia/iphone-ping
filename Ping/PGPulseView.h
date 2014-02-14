//
//  PGPulseView.h
//  Ping
//
//  Created by Shoumik Palkar on 2/12/14.
//  Copyright (c) 2014 Shoumik Palkar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PGPulseView : UIView

@property(nonatomic, readonly) BOOL isRed;

-(void)pulse;
-(void)turnRed;

@end
