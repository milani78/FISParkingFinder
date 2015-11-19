//
//  FISSign.h
//  FISParkingFinder
//
//  Created by Flatiron on 11/15/15.
//  Copyright © 2015 Flatiron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "FISAnnotation.h"





@interface FISSign : NSObject  <MKOverlay, MKAnnotation, MKMapViewDelegate>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinates;
@property (nonatomic, readonly) NSUInteger hourStarts;
@property (nonatomic, readonly) NSUInteger hourEnds;
@property (nonatomic, readonly) NSUInteger currentHour;
@property (nonatomic, readonly) NSUInteger currentMinute;
@property (nonatomic, readonly) NSUInteger currentDay;
@property (nonatomic, readonly) NSArray *signDays;
@property (nonatomic, readonly) NSString *regulation;
@property (nonatomic, strong) MKCircle *circle;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *circleButton;
@property (nonatomic, strong) MKAnnotationView *signAnnotation;

- (instancetype)init;

-(id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate;

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)coordinates
                         hourStarts:(NSUInteger)hourStarts
                           hourEnds:(NSUInteger)hourEnds
                           signDays:(NSArray *)signDays
                         regulation:(NSString *)regulation
                        withMapView:(MKMapView *)mapView
                     withDatePicker:(UIDatePicker *)datePicker;


- (void)addCircle:(MKMapView *)mapView withCoordinates:(CLLocationCoordinate2D)coordinates;

- (MKCircleRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay;

- (BOOL)displayCircle;




@end


