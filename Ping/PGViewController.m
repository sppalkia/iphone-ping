//
//  PGViewController.m
//  Ping
//
//  Created by Shoumik Palkar on 2/12/14.
//  Copyright (c) 2014 Shoumik Palkar. All rights reserved.
//

#import "PGViewController.h"
#import "PGNetworkUtility.h"

@interface PGViewController ()
- (IBAction)pingButtonTapped:(id)sender;
- (IBAction)ipSegmentControlTapped:(id)sender;
- (void)setPingButtonState:(PGPingButtonState)state;

-(void)startPings;
-(void)stopPings;

@property(strong, nonatomic, readonly) UIColor *defaultButtonColor;

@end

@implementation PGViewController

#define IP_SEGMENT_CONTROL_IPV4     0
#define IP_SEGMENT_CONTROL_IPV6     1


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _defaultButtonColor = [self.pingButton titleColorForState:UIControlStateNormal];
    
    self.pingsReceived = 0;
    self.pingsSent = 0;
    
    [self setPingButtonState:kPingButtonStatePing];
    
    [self.ipSegmentControl setSelectedSegmentIndex:IP_SEGMENT_CONTROL_IPV4];
    self.ipLabel.text = [PGNetworkUtility getIPAddress:YES];

}

- (IBAction)pingButtonTapped:(id)sender {
    
    if (_buttonState == kPingButtonStatePing) {
        
        _pinger = [SimplePing simplePingWithHostName:@"8.8.8.8"];
        _pinger.delegate = self;
        [_pinger start];
        
        [self setPingButtonState:kPingButtonStateStop];
    }
    else {
        [self stopPings];
        [self setPingButtonState:kPingButtonStatePing];
    }
}

- (IBAction)ipSegmentControlTapped:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if (control != self.ipSegmentControl)
        return;
    
    if (control.selectedSegmentIndex == IP_SEGMENT_CONTROL_IPV4) {
        self.ipLabel.text = [PGNetworkUtility getIPAddress:YES];
    }
    else {
        NSString *address = [PGNetworkUtility getIPAddress:NO];
        if (![PGNetworkUtility isIPv6Address:address]) {
            self.ipLabel.text = @"Unavailable";
        }
        else {
            self.ipLabel.text = address;
        }
    }
}

- (void)setPingButtonState:(PGPingButtonState)state {
    if (state == kPingButtonStatePing) {
        [self.pingButton setTitle:@"Ping" forState:UIControlStateNormal];
        [self.pingButton setTitleColor:self.defaultButtonColor forState:UIControlStateNormal];
    }
    else {
        [self.pingButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self.pingButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    _buttonState = state;
}

- (void)timerCallback:(NSTimer *)timer {
    if (_pinger) {
        [_pinger sendPingWithData:nil];
    }
}

-(void)startPings {
    self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(timerCallback:)
                                                    userInfo:nil
                                                     repeats:YES];
}

-(void)stopPings {
    [self.pingTimer invalidate];
    self.pingTimer = nil;
    [_pinger stop];
    _pinger = nil;
}

# pragma mark - SimplePingDelegate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
    assert(_pinger == pinger);
    [self startPings];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
    assert(_pinger == pinger);
    NSLog(@"pinger failed: %@", [error localizedDescription]);
    [self setPingButtonState:kPingButtonStatePing];
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet {
    assert(_pinger == pinger);
    self.pingsSent++;
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
    assert(_pinger == pinger);
    self.pingsReceived++;
    
    const struct ICMPHeader *icmpHdr = [SimplePing icmpInPacket:packet];
    NSLog(@"sequence number %d", icmpHdr->sequenceNumber);
}




@end
