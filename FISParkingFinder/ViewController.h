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
@class FISSign;
@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray<FISSign*> *signObjects;
@property (nonatomic, strong) CAShapeLayer *layer;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)mapTapped:(UITapGestureRecognizer *)recognizer;

@end

