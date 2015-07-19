//
//  NSDictionary+PushCradle.m
//  Push Cradle
//
//  Created by Joe Newbry on 7/18/15.
//  Copyright (c) 2015 Joe Newbry. All rights reserved.
//

#import "NSDictionary+PushCradle.h"
#import "JSNLocation.h"

@implementation NSDictionary (PushCradle)

+ (instancetype)convertLocations:(RLMResults *)locations
{
    NSMutableArray *locationsArray = [NSMutableArray new];
    for (JSNLocation *location in locations) {
        [locationsArray addObject:[location dictionaryRepresentation]];
    }

    return @{@"locations" : locationsArray};

}

@end
