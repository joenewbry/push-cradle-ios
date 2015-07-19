//
//  AppDelegate.m
//  Push Cradle
//
//  Created by Joe Newbry on 7/14/15.
//  Copyright (c) 2015 Joe Newbry. All rights reserved.
//

#import "AppDelegate.h"
#import <Realm/Realm.h>
#import <AFNetworking/AFNetworking.h>
#import "JSNLocation.h"
#import "NSDictionary+PushCradle.h"
#import <AdSupport/ASIdentifierManager.h>

@interface AppDelegate ()

@property NSTimer *locationUpdateTimer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // run migrations before opening default realm

    [RLMRealm setSchemaVersion:1 forRealmAtPath:[RLMRealm defaultRealmPath] withMigrationBlock:^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < 1) {
//            [migration enumerateObjects:JSNLocation.className block:^(JSNLocation *oldObject, JSNLocation *newObject) {
//                newObject[@"primaryKeyProperty"] = @"
//            }];
        };
    }];

    [RLMRealm defaultRealm];

    // check to make sure we can do background processing
    UIAlertView *alert;
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else{

        // send locations to server every 10 seconds
        NSTimeInterval time = 10.0;
        self.locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:YES];
    }

    return YES;
}

- (void)updateLocation
{
   RLMResults *locations = [JSNLocation objectsInRealm:[RLMRealm defaultRealm] where:@"savedToServer == false"];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary convertLocations:locations]];

    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [params setValue:idfa forKey:@"idfa"];

    if (locations.count > 0) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://localhost:3000/v1/locations" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
                // stranger danger
                NSArray *savedObjectIds = (NSArray *)[responseObject objectForKey:@"objects_saved"];

                [[RLMRealm defaultRealm] beginWriteTransaction];
                for (int i = 0; i < [savedObjectIds count]; i ++) {
                    NSString *objectId = savedObjectIds[i];
                    JSNLocation *aLocation = [JSNLocation objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:objectId];
                    aLocation.savedToServer = YES;
                }
                [[RLMRealm defaultRealm] commitWriteTransaction];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Request failed");
        }];
    }

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];

    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];

    // Create a new notification.
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    if (alarm)
    {
        alarm.fireDate = [NSDate date];
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 0;
        alarm.soundName = UILocalNotificationDefaultSoundName;
        alarm.alertBody = @"No longer tracking location because application is terminated";
        
        [app scheduleLocalNotification:alarm];
    }
}

@end
