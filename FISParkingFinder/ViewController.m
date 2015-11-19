//
//  ViewController.m
//  FISParkingFinder
//
//  Created by Flatiron on 11/9/15.
//  Copyright © 2015 Flatiron. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
#import "FMDB.h"
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CLAvailability.h>
#import <CoreLocation/CLLocation.h>
#import <MapKit/MapKit.h>
#import "FISSign.h"
#import "FISCircle.h"



@interface ViewController () <MKOverlay, MKAnnotation, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ViewController
//Change this to NSString *const
#define METERS_PER_MILE 1609.344



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    
    
    //1 main Array of Sign Objects
    //1 AT FIRST empty arrary which will then contain the sign objects that are cool witht the current time.
    
    // Go into a for loop over some array of ALL of the signs
    // Apply an if statement over each object in the array and see if it is COOL with the curren time, if it is add it to ANOTHER array.
    
    
    
    
    // zooms in on lower manhattan
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.707721, -74.012952), .8*METERS_PER_MILE,.8*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    [self.mapView regionThatFits:viewRegion];
    
    
    
    /*****************************
     *    OLD DATABASE OBJECT    *
     *****************************/
//    
//    // get database path
//    
//    NSString *sqlitePath = [[NSBundle mainBundle]
//                      pathForResource:@"manhattan-sign-locations" ofType:@"sqlite"];
//    NSLog(@"DATABASE IS:%@", sqlitePath);
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:sqlitePath]) {
//        NSLog(@"DID NOT FIND FILE AT %@", sqlitePath);
//    }
//
//    
//    // open the database
//    
//    sqlite3 *theDatabase;
//    if (!(sqlite3_open([sqlitePath UTF8String], &theDatabase) == SQLITE_OK)) {
//        NSLog(@"ERROR. COULD NOT OPEN AT %@", sqlitePath);
//    }
//    
//    
//    // create NSString and C string for SQL statement
//    
//    NSMutableString *sqlStatementNSString = [[NSMutableString alloc] initWithString:@"SELECT * FROM locations;"];
//    
//    NSLog(@"sqlStatementNSString is %@", sqlStatementNSString);
//    
//    const char *sql = [sqlStatementNSString UTF8String];
//
//    
//    // initialize and prepare a SQL statement
//    
//    sqlite3_stmt *sqlStatement;
//    int status = sqlite3_prepare(theDatabase, sql, -1, &sqlStatement, NULL);
//    if (status != SQLITE_OK) {
//        NSLog(@"PROBLEM WITH PREPARE STATEMENT: %d %s", status, sqlite3_errmsg(theDatabase));
//    }
//    
//    
//    // step through the SQL statement
//    
//    self.signObjects = [[NSMutableArray alloc] init];
//
//    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
//        NSInteger signSequence = (NSInteger)sqlite3_column_int(sqlStatement, 2);
//        NSInteger signFeetFromStreet = (NSInteger)sqlite3_column_int(sqlStatement, 3);
//        char *signRegulation = (char *)sqlite3_column_text(sqlStatement, 5) ?: "";  //  ?: ""   is for when the entry is null, to feed an empty string
//        char *signMainStreet = (char *)sqlite3_column_text(sqlStatement, 7) ?: "";
//        char *signFromStreet = (char *)sqlite3_column_text(sqlStatement, 8) ?: "";
//        char *signToStreet = (char *)sqlite3_column_text(sqlStatement, 9) ?: "";
//        char *signStreetSide = (char *)sqlite3_column_text(sqlStatement, 10) ?: "";
//
//    // assign to objects and put into array
//    
//        NSString *regulation = [NSString stringWithUTF8String:signRegulation];
//        NSString *mainStreet = [NSString stringWithUTF8String:signMainStreet];
//        NSString *fromStreet = [NSString stringWithUTF8String:signFromStreet];
//        NSString *toStreet = [NSString stringWithUTF8String:signToStreet];
//        NSString *streetSide = [NSString stringWithUTF8String:signStreetSide];
//        
//        NSDictionary *aSign = [[NSDictionary alloc] initWithObjects:@[@(signSequence), @(signFeetFromStreet), regulation, mainStreet, fromStreet, toStreet, streetSide] forKeys:@[@"sequence", @"feetFromStreet", @"regulation", @"mainStreet", @"fromStreet", @"toStreet", @"streetSide"]];
//        
//        [self.signObjects addObject:aSign];
//        
//        
//        
//    }
//    
//    sqlite3_finalize(sqlStatement);
//    sqlite3_close(theDatabase);

    
//    NSLog(@"%@", self.signObjects);

 
    
    
    
    /*****************************
     *    NEW DATABASE OBJECT    *
     *****************************/
    
    // get database path
    
    NSString *sqlitePath = [[NSBundle mainBundle]
                            pathForResource:@"test3" ofType:@"sqlite"];
    NSLog(@"DATABASE IS:%@", sqlitePath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:sqlitePath]) {
        NSLog(@"DID NOT FIND FILE AT %@", sqlitePath);
    }
    
    
    // open the database
    
    sqlite3 *signDatabase;
    if (!(sqlite3_open([sqlitePath UTF8String], &signDatabase) == SQLITE_OK)) {
        NSLog(@"ERROR. COULD NOT OPEN AT %@", sqlitePath);
    }
    
    
    // create NSString and C string for SQL statement
    
    NSMutableString *sqlStatementNSString = [[NSMutableString alloc] initWithString:@"SELECT * FROM test3;"];
    
    NSLog(@"sqlStatementNSString is %@", sqlStatementNSString);
    
    const char *sql = [sqlStatementNSString UTF8String];
    
    
    // initialize and prepare a SQL statement
    
    sqlite3_stmt *sqlStatement;
    int status = sqlite3_prepare(signDatabase, sql, -1, &sqlStatement, NULL);
    if (status != SQLITE_OK) {
        NSLog(@"PROBLEM WITH PREPARE STATEMENT: %d %s", status, sqlite3_errmsg(signDatabase));
    }
    
    
    // step through the SQL statement
    
    self.signObjects = [[NSMutableArray alloc] init];
    
//    NSUInteger countOfWhileLoop = 1;
    
    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
        
//        NSLog(@"While loop getting called for the %ld time", countOfWhileLoop);
        
        CGFloat latitude = (CGFloat)sqlite3_column_double(sqlStatement, 0);
        CGFloat longitude = (CGFloat)sqlite3_column_double(sqlStatement, 1);
        NSUInteger hourStarts = (NSUInteger)sqlite3_column_int(sqlStatement, 2);
        NSUInteger hourEnds = (NSUInteger)sqlite3_column_int(sqlStatement, 3);
        char *days = (char *)sqlite3_column_text(sqlStatement, 4) ?: "";
        char *regulation = (char *)sqlite3_column_text(sqlStatement, 5) ?: "";
        
        
        // assign to objects and put into array
        
        NSString *signDays = [NSString stringWithUTF8String:days];
 //       [signDays stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSArray *daysArray = [signDays componentsSeparatedByString:@","];
        NSString *signRegulation = [NSString stringWithUTF8String:regulation];
        
        NSDictionary *aSign = [[NSDictionary alloc]
                               initWithObjects:@[@(latitude), @(longitude), @(hourStarts), @(hourEnds), daysArray, signRegulation]
                                        forKeys:@[@"latitude", @"longitude", @"hourStarts", @"hourEnds", @"signDays", @"regulation"]];
        
        [self.signObjects addObject:aSign];
        
//        countOfWhileLoop ++;
        
        
    }
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(signDatabase);
    
    
    NSLog(@"THE SIGN OBJECT ARRAY'S DATA IS: %@", self.signObjects);
    
    

    
    
    
    
    
    
    
    
    /*****************************
     *       TRYING FISSign      *
     *****************************/
    
    // from Date Picker
    
     NSDate *currentDate = self.datePicker.date;
     NSCalendar *currentCalendar = [NSCalendar currentCalendar];
     NSDateComponents *dateComponents = [currentCalendar components:(NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currentDate];
     NSUInteger dayOfWeek = [dateComponents weekday];
     NSUInteger hour = [dateComponents hour];
    
    // placeholder days array
    
     NSArray *daysOfTheWeek = @[@"nil", @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
     

    //putting sign objects on the map
    
    FISSign *aSign = [[FISSign alloc] initWithCoordinates:CLLocationCoordinate2DMake(40.707721, -74.012952)
                                               hourStarts:12
                                                 hourEnds:13
                                                 signDays:daysOfTheWeek
                                               regulation:@"FREE PARKING ALL THE TIME! :)"
                                              withMapView:self.mapView
                                           withDatePicker:self.datePicker];
    

    FISSign *anotherSign = [[FISSign alloc] initWithCoordinates:CLLocationCoordinate2DMake(40.707019, -74.013433)
                                                     hourStarts:13
                                                       hourEnds:15
                                                       signDays:daysOfTheWeek
                                                     regulation:@"FREE PARKING ALL THE TIME! :)"
                                                    withMapView:self.mapView
                                                 withDatePicker:self.datePicker];


    
    }



// next steps:

// CIRCLES ARE TAPABLE

// WHEN A CIRCLE IS TAPPED, A SMALL VIEW FADES IN THAT DISPLAYS THE SIGN'S REGULATION TEXT
// CLOSE THE SMALL VIEW BY TAPPING ANYWHERE

























/*****************************
 *      ADDING A CIRCLE      *
 *****************************/


//- (void)addSignLocation
//{
//    FISCircle *aCircle = (FISCircle *)[FISCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(40.707721, -74.012952) radius:9];
//    aCircle.color = [UIColor colorWithRed:0 green:255 blue:213 alpha:0.8];
//    [self.mapView addOverlay:aCircle]; // adding sign to the map as overlay
//}
//
//
//
//- (MKCircleRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
//{
//    if ([overlay isKindOfClass:FISCircle.class]) {
//        
//        FISCircle *circle = (FISCircle *)overlay;
//        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
//        circleView.fillColor = circle.color;
//        
//        return circleView;
//    }
//    
//    return nil;
//}










@end




