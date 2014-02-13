//
//  PGNetworkUtility.h
//  Ping
//
//  Created by Shoumik Palkar on 2/12/14.
//  Copyright (c) 2014 Shoumik Palkar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGNetworkUtility : NSObject

+(NSString *)getIPAddress:(BOOL)preferIPv4;

+(BOOL)isIPv4Address:(NSString *)address;
+(BOOL)isIPv6Address:(NSString *)address;

@end
