//
//  PGPulseView.m
//  Ping
//
//  Created by Shoumik Palkar on 2/12/14.
//  Copyright (c) 2014 Shoumik Palkar. All rights reserved.
//

#import "PGPulseView.h"
#import "PGConstants.h"

@implementation PGPulseView

-(void)awakeFromNib {
    self.backgroundColor = [PGConstants redColor];
    _isRed = NO;
}

-(void)pulse {
    
    CGFloat toValue = _isRed ? 1.0 : 1.3;
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = 0.5f;
    pulseAnimation.toValue = [NSNumber numberWithFloat:toValue];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = 0;
    [self.layer addAnimation:pulseAnimation forKey:nil];
    
    if (_isRed) {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.backgroundColor = [PGConstants blueColor];
                         }];
    }
    _isRed = NO;
}

-(void)turnRed {
    
    if (_isRed)
        return;
        
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.backgroundColor = [PGConstants redColor];
                     }];
    _isRed = YES;
}

@end
