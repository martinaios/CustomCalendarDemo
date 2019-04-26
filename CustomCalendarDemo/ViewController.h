//
//  ViewController.h
//  CustomCalendarDemo
//
//  Created by Martina Makasare on 3/25/19.
//  Copyright © 2019 Martina Makasare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import <UserNotifications/UserNotifications.h>
@interface ViewController :UIViewController<FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance>

//@property (weak, nonatomic) IBOutlet FSCalendar *view;
{
    FSCalendar * calendar;
    NSArray * datesWithEvent;
    NSCalendar * gregorian;
    NSDateFormatter* nsformatter;
    UNUserNotificationCenter *center;

}



@end

