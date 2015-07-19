//
//  NSDictionary+PushCradle.h
//  Push Cradle
//
//  Created by Joe Newbry on 7/18/15.
//  Copyright (c) 2015 Joe Newbry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface NSDictionary (PushCradle)

+ (instancetype)convertLocations:(RLMResults *)locations;

@end
