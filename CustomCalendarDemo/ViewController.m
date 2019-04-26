//
//  ViewController.m
//  CustomCalendarDemo
//
//  Created by Martina Makasare on 3/25/19.
//  Copyright © 2019 Martina Makasare. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    datesWithEvent = [NSMutableArray new];
    // Do any additional setup after loading the view, typically from a nib.
    calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [calendar setValue:[NSTimeZone timeZoneWithName:@"Asia/Kolkata"] forKey:@"timeZone"];
    calendar.dataSource = self;
    calendar.delegate = self;
    
//    [calendar setValue:[NSTimeZone timeZoneWithName:@"Asia/Kolkata"] forKey:@"timeZone"];
    
    NSLog(@"datasource and delegates set");
    [self.view addSubview:calendar];
//    self.calendar = calendar;
    NSLog(@"view set");
    
//    NSArray* stringDates = [NSArray arrayWithObjects:@"2019-03-03 18:30:00 +0000", @"2019-03-26 18:30:00 +0000", @"2019-03-12 18:30:00 +0000", @"2019-04-20 18:30:00 +0000", nil];
//    datesWithEvent = [NSArray arrayWithObjects:@"2019-03-09 08:39:20 0000", @"2019-03-26 10:39:20 0000", @"2019-03-12 04:39:20 0000", nil];
    datesWithEvent = [NSArray arrayWithObjects:@"2019-04-09 00:00:00", @"2019-04-26 13:06:00", @"2019-04-12 01:30:10", nil];
    [calendar reloadData];
    center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!granted) {
                                  NSLog(@"Something went wrong");
                              }
                          }];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
            NSLog(@"Notifications not allowed");
        }
        else{
            NSLog(@"Notifications allowed");
        }
    }];
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
//    dateFormatter.dateFormat = @"yyyy-MM-dd";

//    for (int i = 0; i < stringDates.count; i++)
//    {
//
//        [datesWithEvent addObject:[stringDates objectAtIndex:i]];
//    }

    
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Kolkata"]];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString* stringDate = [dateFormatter stringFromDate:date];
//    NSDateComponents *components = [gregorian components: NSYearCalendarUnit|
//                                    NSMonthCalendarUnit|
//                                    NSDayCalendarUnit
//                                               fromDate:[dateFormatter dateFromString:stringDate]];
    NSDateComponents *components = [gregorian components: NSCalendarUnitYear|
                                    NSCalendarUnitMonth|
                                    NSCalendarUnitDay
                                                fromDate:[dateFormatter dateFromString:stringDate]];
    [components setHour:13];
    [components setMinute:06];
    [components setSecond:00];
    NSDate *newDate = [gregorian dateFromComponents:components];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Kolkata"]];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString* newDateStr = [dateFormatter stringFromDate:newDate];

    NSLog(@"newDate is %@", newDateStr);
    
    if ([datesWithEvent containsObject:newDateStr])
    {
     //    Schedule the notification
        
        [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Kolkata"]];

        newDate = [newDate dateByAddingTimeInterval:1];

        NSLog(@"NSDate:%@",newDate);

//        NSDateComponents *components = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSTimeZoneCalendarUnit fromDate:newDate];
        NSDateComponents *components = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:newDate];
        UNMutableNotificationContent * objNotificationContent = [[UNMutableNotificationContent alloc] init];
        objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"Notification!" arguments:nil];
        objNotificationContent.body = [NSString localizedUserNotificationStringForKey:@"This is local notification message!"
                                                                            arguments:nil];
        objNotificationContent.sound = [UNNotificationSound defaultSound];

        /// 4. update application icon badge number
        objNotificationContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);


        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];


        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UYLLocalNotification"
                                                                              content:objNotificationContent trigger:trigger];
        /// 3. schedule localNotification
        center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Local Notification succeeded");
            }
            else {
                NSLog(@"Local Notification failed");
            }
        }];
        return 1;
    }
    else{
        NSLog(@"........Events List........");
    }
    return 0;
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    NSLog(@"hasEventForDate date is %@", date);
    
    return 0;
}

@end
