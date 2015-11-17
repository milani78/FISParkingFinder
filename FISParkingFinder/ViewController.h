//
//  ViewController.h
//  FISParkingFinder
//
//  Created by Flatiron on 11/9/15.
//  Copyright © 2015 Flatiron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *signObjects;
@property (nonatomic, strong) CAShapeLayer *layer;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

