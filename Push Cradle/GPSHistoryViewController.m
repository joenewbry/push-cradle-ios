//
//  SecondViewController.m
//  Push Cradle
//
//  Created by Joe Newbry on 7/14/15.
//  Copyright (c) 2015 Joe Newbry. All rights reserved.
//

#import "GPSHistoryViewController.h"
#import <Realm/Realm.h>
#import "JSNLocation.h"

@interface GPSHistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property RLMResults *locations;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property RLMNotificationToken *token;

@end

@implementation GPSHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // load all realm objects
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.locations = [JSNLocation allObjects];
    [self.tableView reloadData];

    self.token = [[RLMRealm defaultRealm] addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
        NSLog(@"Notification is %@" , notification);
        self.locations = [JSNLocation allObjects];
        [self.tableView reloadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[RLMRealm defaultRealm] removeNotification:self.token];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];

    JSNLocation *location = [self.locations objectAtIndex:indexPath.row];
    // TODO -- use NSDateFormatter to display nice date
//    NSDateFormatter
    cell.textLabel.text = [NSString stringWithFormat:@"Time: %@, lat: %f, long: %f", location.createdAt, location.latitude, location.longitude];

    return cell;
}

@end
