//
//  JSNLocation.h
//  Push Cradle
//
//  Created by Joe Newbry on 7/14/15.
//  Copyright (c) 2015 Joe Newbry. All rights reserved.
//

#import "RLMObject.h"

@interface JSNLocation : RLMObject

@property NSDate *createdAt;
@property float latitude;
@property float longitude;
@property BOOL savedToServer;
@property NSString *uniqueId;

- (instancetype)initWithLatitude:(float)latitude AndLongitude:(float)longitude;
- (NSDictionary *)dictionaryRepresentation;

@end
