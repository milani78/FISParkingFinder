//
//  FISSign.m
//  FISParkingFinder
//
//  Created by Flatiron on 11/15/15.
//  Copyright © 2015 Flatiron. All rights reserved.
//

#import "FISSign.h"
#import "FISCircle.h"
#import "ViewController.h"
#import <CoreLocation/CLAvailability.h>
#import <CoreLocation/CLLocation.h>
#import <MapKit/MapKit.h>


@implementation FISSign



- (instancetype)init
{
    self = [self init];
    return self;
}

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)coordinates
                         hourStarts:(NSUInteger)hourStarts
                           hourEnds:(NSUInteger)hourEnds
                           signDays:(NSArray *)signDays
                         regulation:(NSString *)regulation
                        withMapView:(MKMapView *)mapView
                     withDatePicker:(UIDatePicker *)datePicker

{
    self = [super init];
    if (self)
    {
        _coordinates = coordinates;
        _hourStarts = hourStarts;
        _hourEnds = hourEnds;
        _signDays = signDays;
        _regulation = regulation;

//        mapView.delegate = self;
        self.circleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.circleButton.backgroundColor = [UIColor clearColor];
        
        //commenting for now to test IF STATEMENT
//        FISCircle *aCircle = (FISCircle *)[FISCircle circleWithCenterCoordinate:coordinates radius:9];
//        aCircle.color = [UIColor colorWithRed:0 green:255 blue:213 alpha:0.8];
//        [mapView addOverlay:aCircle];
        
         // adding sign to the map as overlay
        
//        [self displayCircle];
    }
    
    return self;
}




//- (MKCircleRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
//{
//    
//    NSLog(@"GETTING CALLED MAP VIEW THING\n\n\n\n\n HI HI HI HI\n\n\n\n\n");
//    
//    if ([overlay isKindOfClass:FISCircle.class]) {
//        
//        FISCircle *circle = (FISCircle *)overlay;
//        UIColor *colorOfCircle = circle.color;
//        
//        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
//        circleView.fillColor = colorOfCircle;
//        
//        return circleView;
//    }
//    
//    return nil;
//}
//


// WRITE TIME CONSTRAINT METHOD. SHOULD IT GO INTO THE VIEW CONTROLLER?  Need Date Picker & database

- (BOOL)displayCircle
{
    
    // hide circle if...
    
    // default time:
    // sign start time (7) <= default time < sign end time (19=7pm)    &&    default day isEqual to array's day
    
    // selected time:
    // sign start time (7) <= selected time < sign end time (19=7pm)   &&    selected day isEqual to array's day          from Date Picker
    //                             hh:mm

    
    
    NSDate *currentDate = self.datePicker.date;
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [currentCalendar components:(NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currentDate];
    NSUInteger dayOfWeek = [dateComponents weekday]; // number at index
    NSUInteger hour = [dateComponents hour];
    
    
    for (NSUInteger i=0; i<self.signDays.count; i++) {
        // need obj index number
        
        // check if sign array contains the days that dayOfWeek array contains...
        
//        if ([daysOfTheWeek containsObject:([NSString stringWithFormat:@"%@",(signDays[i])])
//             {
//             }
        
             
        
        if ((self.hourStarts <= hour) && (hour < self.hourEnds) && (dayOfWeek == i))
        {
            
            // hide the circle
            
            return YES;
        }
        
    }
    
    return NO;

}






















// keeping FISCircle class because we need to add color

//- (void)addCircle:(MKMapView *)mapView withCoordinates:(CLLocationCoordinate2D)coordinates
//{
//    FISCircle *aCircle = (FISCircle *)[FISCircle circleWithCenterCoordinate:coordinates radius:9];
//    aCircle.color = [UIColor colorWithRed:0 green:255 blue:213 alpha:0.8];
//    [mapView addOverlay:aCircle]; // adding sign to the map as overlay
//}













@end


