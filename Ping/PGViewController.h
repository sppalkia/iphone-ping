//
//  PGViewController.h
//  Ping
//
//  Created by Shoumik Palkar on 2/12/14.
//  Copyright (c) 2014 Shoumik Palkar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimplePing.h"

typedef enum {
    kPingButtonStatePing,
    kPingButtonStateStop,
} PGPingButtonState;


@interface PGViewController : UIViewController <SimplePingDelegate> {
    PGPingButtonState _buttonState;
    SimplePing *_pinger;
}

@property (strong, nonatomic) IBOutlet UILabel *ipLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ipSegmentControl;
@property (strong, nonatomic) IBOutlet UIButton *pingButton;

@property (nonatomic) NSUInteger pingsSent;
@property (nonatomic) NSUInteger pingsReceived;

@property (strong, nonatomic) NSTimer *pingTimer;

@end
