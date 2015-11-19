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



- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                          latitude:(CGFloat)latitude
                         longitude:(CGFloat)longitude
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
        _coordinate = coordinate;
        _latitude = latitude;
        _longitude = longitude;
        _hourStarts = hourStarts;
        _hourEnds = hourEnds;
        _signDays = signDays;
        _regulation = regulation;
        
        mapView.delegate = self;
        
        // added from Matt's files
        self.circleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.circleButton.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}



+(instancetype)signFromDictionary:(NSDictionary *)dictionary withMapView:(MKMapView*)mapView datePicker:(UIDatePicker*)datePicker
{
    NSInteger hourStarts = [dictionary[@"hourStarts"] integerValue];
    NSInteger hourEnds = [dictionary[@"hourEnds"] integerValue];
    CGFloat latitude = [dictionary[@"latitude"] floatValue];
    CGFloat longitude = [dictionary[@"longitude"] floatValue];
    NSString *regulation = dictionary[@"regulation"];
    NSArray *signDays = dictionary[@"signDays"];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    FISSign *newSign = [[FISSign alloc] initWithCoordinate:coordinate latitude:latitude longitude:longitude hourStarts:hourStarts hourEnds:hourEnds signDays:signDays regulation:regulation withMapView:mapView withDatePicker:datePicker];
    
    return newSign;
}



- (MKCircleRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    
    NSLog(@"GETTING CALLED MAP VIEW THING\n\n\n HI HI HI HI\n\n\n");
    
    if ([overlay isKindOfClass:FISCircle.class]) {
        
        FISCircle *circle = (FISCircle *)overlay;
        UIColor *colorOfCircle = circle.color;
        
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleView.fillColor = colorOfCircle;
        
        return circleView;
    }
    
    return nil;
}








@end


