//
//  FirstViewController.m
//  Push Cradle
//
//  Created by Joe Newbry on 7/14/15.
//  Copyright (c) 2015 Joe Newbry. All rights reserved.
//

#import "PushAndGPSStateViewController.h"
#import "JSNLocation.h"
#import <Realm/Realm.h>

@interface PushAndGPSStateViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pushStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpsStateLabel;

@property CLLocationManager *locationManager;

@end

@implementation PushAndGPSStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressEnablePush:(id)sender {
}

- (IBAction)didPressEnableGPS:(id)sender {

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;

    /* Need to request authorization.  See here:
     * http://matthewfecher.com/app-developement/getting-gps-location-using-core-location-in-ios-8-vs-ios-7/
     */
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
//    NSLog(@"Authorization state changed");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [locations enumerateObjectsUsingBlock:^(CLLocation *aLocation, NSUInteger idx, BOOL *stop) {
//        NSLog(@"A location is lat: %f and long: %f", aLocation.coordinate.latitude, aLocation.coordinate.longitude);

        CGFloat latitude = aLocation.coordinate.latitude;
        CGFloat longitude = aLocation.coordinate.longitude;
        JSNLocation *location = [[JSNLocation alloc] initWithLatitude:latitude AndLongitude:longitude];
        [realm addObject:location];
    }];
    [realm commitWriteTransaction];
}



@end
