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
#import "FISAnnotation.h"



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
    
    _mapView.delegate = self;
    
    
    
    //1 main Array of Sign Objects
    //1 AT FIRST empty arrary which will then contain the sign objects that are cool witht the current time.
    
    // Go into a for loop over some array of ALL of the signs
    // Apply an if statement over each object in the array and see if it is COOL with the curren time, if it is add it to ANOTHER array.
    
    
    
    
    // zooms in on lower manhattan
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.707721, -74.012952), .8*METERS_PER_MILE,.8*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    [self.mapView regionThatFits:viewRegion];
    
    
    
    
    
    /*****************************
     *    TEST DATABASE OBJECT   *
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
        NSMutableArray *daysArray = [NSMutableArray new];

        for (NSString *day in [signDays componentsSeparatedByString:@","]){
            [daysArray addObject:[day stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }
        
        NSString *signRegulation = [NSString stringWithUTF8String:regulation];
        
        NSDictionary *aSignDictionary = [[NSDictionary alloc]
                                         initWithObjects:@[@(latitude), @(longitude), @(hourStarts), @(hourEnds), daysArray, signRegulation]
                                         forKeys:@[@"latitude", @"longitude", @"hourStarts", @"hourEnds", @"signDays", @"regulation"]];
        
        FISSign *aSign = [FISSign signFromDictionary:aSignDictionary withMapView:self.mapView datePicker:self.datePicker];
        
        [self.signObjects addObject:aSign];
        
        //        countOfWhileLoop ++;
        
        
    }
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(signDatabase);
    
    
    NSLog(@"THE SIGN OBJECT ARRAY'S DATA IS: %@", self.signObjects);
    
}




//Moved the picker to give viewController data from it for IF STATEMENT
- (IBAction)datePicker:(id)sender

{
    
    NSDate *currentDate = self.datePicker.date;
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [currentCalendar components:(NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currentDate];
    NSUInteger dayOfWeek = [dateComponents weekday];
    NSUInteger hour = [dateComponents hour];
    NSLog(@"%lu", hour);
    
    // placeholder days array
    NSArray *daysOfTheWeek = @[@"nil", @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
    NSLog(@"%@", daysOfTheWeek[dayOfWeek]);
    
    
    // this removes ALL overlays
    [self.mapView removeOverlays: self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (FISSign *sign in self.signObjects)
    {
        NSLog(@"sign #%ld - hourStarts:%ld hourEnds:%ld signDays:%@",[self.signObjects indexOfObject:sign], sign.hourStarts, sign.hourEnds, sign.signDays);
        
        for (NSUInteger i = 0; i < (sign.signDays.count); i++)
        {
            NSLog(@"in for loop in datePickerDidPickDate");
            BOOL hoursOfFreeParking = ((sign.hourStarts > hour) || (hour > sign.hourEnds));
            BOOL daysOfNoParking = ([sign.signDays containsObject:daysOfTheWeek[dayOfWeek]]);
            if ((hoursOfFreeParking && daysOfNoParking) || (!daysOfNoParking) )
                
            //if (((sign.hourStarts >= hour) || (hour > sign.hourEnds)) && ([sign.signDays containsObject:daysOfTheWeek[dayOfWeek]]))
            {
                NSLog(@"MATCHED CRITERIA IN IF STATEMENT");
                //shows the circle; copied from FISSign.m
                FISCircle *aCircle = (FISCircle *)[FISCircle circleWithCenterCoordinate:sign.coordinate radius:9];
                aCircle.color = [UIColor colorWithRed:0 green:255 blue:213 alpha:0.8];
                [_mapView addOverlay:aCircle];
                
                FISAnnotation *anAnnotation = [[FISAnnotation alloc] initWithTitle:sign.regulation andCoordinate:sign.coordinate];
                [self.mapView addAnnotation:anAnnotation];
            }
        }
        
    }
    
}




//copied from FISSign.m
- (MKCircleRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    
    NSLog(@"GETTING CALLED MAP VIEW THING\n\n\n\n\n HI HI HI HI\n\n\n\n\n");
    
    if ([overlay isKindOfClass:FISCircle.class])
    {
        
        FISCircle *circle = (FISCircle *)overlay;
        UIColor *colorOfCircle = circle.color;
        
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleView.fillColor = colorOfCircle;
        
        return circleView;
    }
    
    return nil;
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.calloutOffset = CGPointMake(0, 5);
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"invisible-button.gif"];
    annotationView.annotation = annotation;
    
    return annotationView;
}













// next steps:

// CIRCLES ARE TAPABLE

// WHEN A CIRCLE IS TAPPED, A SMALL VIEW FADES IN THAT DISPLAYS THE SIGN'S REGULATION TEXT
// CLOSE THE SMALL VIEW BY TAPPING ANYWHERE
















@end




