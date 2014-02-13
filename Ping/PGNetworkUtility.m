//
//  PGNetworkUtility.m
//  Ping
//
//  Created by Shoumik Palkar on 2/12/14.
//  Copyright (c) 2014 Shoumik Palkar. All rights reserved.
//

#import "PGNetworkUtility.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

@interface PGNetworkUtility(Private)
+ (NSDictionary *)_getIPAddresses;
@end

@implementation PGNetworkUtility

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

+(NSString *)getIPAddress:(BOOL)preferIPv4 {
    
    NSArray *searchArray;
    if (preferIPv4) {
        searchArray = @[ IOS_WIFI @"/" IP_ADDR_IPv4,
                         IOS_WIFI @"/" IP_ADDR_IPv6,
                         IOS_CELLULAR @"/" IP_ADDR_IPv4,
                         IOS_CELLULAR @"/" IP_ADDR_IPv6 ];
    }
    else {
        searchArray = @[ IOS_WIFI @"/" IP_ADDR_IPv6,
                         IOS_WIFI @"/" IP_ADDR_IPv4,
                         IOS_CELLULAR @"/" IP_ADDR_IPv6,
                         IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    }

    
    NSDictionary *addresses = [PGNetworkUtility _getIPAddresses];
    
    __block NSString *address;
    
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
         address = addresses[key];
         if (address)
             *stop = YES;
     }];
    
    if (!address) {
        if (preferIPv4) {
            return @"0.0.0.0";
        }
        else {
            return @"0:0:0:0:0:0:0:0";
        }
    }
    
    return address;
}

+(BOOL)isIPv4Address:(NSString *)address {
    return ![PGNetworkUtility isIPv6Address:address];
}

+(BOOL)isIPv6Address:(NSString *)address {
    if (!address) {
        return NO;
    }
    
    return [address rangeOfString:@":"].location != NSNotFound;
}

+ (NSDictionary *)_getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    struct ifaddrs *interfaces;
    
    if (!getifaddrs(&interfaces)) {
        struct ifaddrs *interface;
        
        for (interface = interfaces; interface != NULL; interface = interface->ifa_next) {
            // don't want down interfaces or the loopback interface
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue;
            }
            
            const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
            if (addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6)) {
                
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                
                if (inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name,
                                     addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        freeifaddrs(interfaces);
    }
    
    if ([addresses count] <= 0) {
        return nil;
    }
    
    return addresses;
}


@end
