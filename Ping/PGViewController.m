//
//  PGViewController.m
//  Ping
//
//  Created by Shoumik Palkar on 2/12/14.
//  Copyright (c) 2014 Shoumik Palkar. All rights reserved.
//

#import "PGViewController.h"
#import "PGNetworkUtility.h"
#import "PGPulseView.h"

@implementation PGViewController

#define TIMEOUT                     3.0f
#define HOST                        @"8.8.8.8"

# pragma mark - Custom Properties

-(CGFloat)fractionPingsReceived {
    return (float)self.pingsReceived / (float)self.pingsSent;
}

-(CGFloat)fractionPingsDropped {
    return 1 - self.fractionPingsReceived;
}

# pragma mark - View Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pingerReady = NO;
    _lastPingTime = [NSDate timeIntervalSinceReferenceDate];
    
    self.pingsReceived = 0;
    self.pingsSent = 0;
    
    self.ipLabel.text = @"0.0.0.0";
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSString *address = [PGNetworkUtility getIPv4Address];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.ipLabel.text = address;
        });
    });
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startPings];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [self stopPings];
    [super viewDidDisappear:animated];
}

# pragma mark - Pings

- (void)timerFired:(NSTimer *)timer {
    if (_pinger) {
        [_pinger sendPingWithData:nil];
        
        // if delay is more than TIMEOUT, turn pulsing view red to indicate no connection
        if ([NSDate timeIntervalSinceReferenceDate] - _lastPingTime > TIMEOUT) {
            [self.pulseView turnRed];
        }
    }
}

-(void)startPings {
    if (_pingerReady) {
        if (!self.pingTimer || ![self.pingTimer isValid]) {
            self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                              target:self
                                                            selector:@selector(timerFired:)
                                                            userInfo:nil
                                                             repeats:YES];
        }
    }
    else {
        _pinger = [SimplePing simplePingWithHostName:HOST];
        _lastPingTime = [NSDate timeIntervalSinceReferenceDate];
        _pinger.delegate = self;
        [_pinger start];
    }
}

-(void)stopPings {
    [self.pingTimer invalidate];
    self.pingTimer = nil;
    
    if (_pingerReady) {
        [_pinger stop];
    }
    
    [self.pulseView.layer removeAllAnimations];
    
    _pinger = nil;
    _pingerReady = NO;
}

# pragma mark - SimplePingDelegate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
    assert(_pinger == pinger);
    _pingerReady = YES;
    [self startPings];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
    assert(_pinger == pinger);
    _pingerReady = NO;
    NSLog(@"pinger failed: %@", [error localizedDescription]);
    [self stopPings];
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet {
    assert(_pinger == pinger);
    self.pingsSent++;
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
    assert(_pinger == pinger);
    self.pingsReceived++;
    
    _lastPingTime = [NSDate timeIntervalSinceReferenceDate];
    [self.pulseView pulse];
}




@end
