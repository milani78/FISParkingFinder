//
//  FISCircle.h
//  FISParkingFinder
//
//  Created by Flatiron on 11/15/15.
//  Copyright © 2015 Flatiron. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CLAvailability.h>
#import <CoreLocation/CLLocation.h>

@interface FISCircle : MKCircle <MKOverlay>

@property (nonatomic, strong) UIColor *color;

@end
