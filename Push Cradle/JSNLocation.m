//
//  JSNLocation.m
//  Push Cradle
//
//  Created by Joe Newbry on 7/14/15.
//  Copyright (c) 2015 Joe Newbry. All rights reserved.
//

#import "JSNLocation.h"

@implementation JSNLocation

+ (NSString *)primaryKey
{
    return @"uniqueId";
}

- (instancetype)init
{
    [NSException raise:NSInternalInconsistencyException format:@"Find me in code and use the initilizer with init with lat and long"];

    return self;
}

- (instancetype)initWithLatitude:(float)latitude AndLongitude:(float)longitude
{
    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
        self.createdAt = [NSDate date];
        self.savedToServer = false;
        self.uniqueId = [[NSUUID UUID] UUIDString];
    }

    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    return [self dictionaryWithValuesForKeys:@[@"createdAt", @"latitude", @"longitude", @"savedToServer", @"uniqueId"]];
}

@end
