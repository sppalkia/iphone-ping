//
//  PGViewController.h
//  Ping
//
//  Created by Shoumik Palkar on 2/12/14.
//  Copyright (c) 2014 Shoumik Palkar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimplePing.h"

@class PGPulseView;
@interface PGViewController : UIViewController <SimplePingDelegate> {
    SimplePing *_pinger;
    BOOL _pingerReady;
    NSTimeInterval _lastPingTime;
}

// Label that displays the IP Address
@property (strong, nonatomic) IBOutlet UILabel *ipLabel;

// Pulsing View to indicate received pings
@property (strong, nonatomic) IBOutlet PGPulseView *pulseView;

// Timer to control when to send ICMP ping packets
@property (strong, nonatomic) NSTimer *pingTimer;

// Ping Statistics
@property (nonatomic, assign) NSUInteger pingsSent;
@property (nonatomic, assign) NSUInteger pingsReceived;
@property (nonatomic, readonly) CGFloat fractionPingsReceived;
@property (nonatomic, readonly) CGFloat fractionPingsDropped;

-(void)startPings;
-(void)stopPings;


@end
