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


@interface FISSign : NSObject  <MKOverlay, MKAnnotation, MKMapViewDelegate>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CGFloat latitude;
@property (nonatomic, readonly) CGFloat longitude;
@property (nonatomic, readonly) NSUInteger hourStarts;
@property (nonatomic, readonly) NSUInteger hourEnds;
@property (nonatomic, readonly) NSArray *signDays;
@property (nonatomic, readonly) NSString *regulation;
@property (nonatomic, strong) MKCircle *circle;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *circleButton;

- (instancetype)init;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                          latitude:(CGFloat)latitude
                         longitude:(CGFloat)longitude
                        hourStarts:(NSUInteger)hourStarts
                          hourEnds:(NSUInteger)hourEnds
                          signDays:(NSArray *)signDays
                        regulation:(NSString *)regulation
                       withMapView:(MKMapView *)mapView
                    withDatePicker:(UIDatePicker *)datePicker;

+ (instancetype)signFromDictionary:(NSDictionary *)dictionary withMapView:(MKMapView*)mapView datePicker:(UIDatePicker*)datePicker;

- (void)addCircle:(MKMapView *)mapView withCoordinates:(CLLocationCoordinate2D)coordinate;

- (MKCircleRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay;



@end


