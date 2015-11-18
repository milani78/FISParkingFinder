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
#define METERS_PER_MILE 1609.344



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _mapView.delegate = self;
    
    // zooms in on lower manhattan
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.707721, -74.012952), .8*METERS_PER_MILE,.8*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    [self.mapView regionThatFits:viewRegion];
    
    [self.mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)]];
    
    
    /*****************************
     *    OLD DATABASE OBJECT    *
     *****************************/
    
    // get database path
    
    NSString *sqlitePath = [[NSBundle mainBundle]
                      pathForResource:@"manhattan-sign-locations" ofType:@"sqlite"];
    NSLog(@"DATABASE IS:%@", sqlitePath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:sqlitePath]) {
        NSLog(@"DID NOT FIND FILE AT %@", sqlitePath);
    }

    
    // open the database
    
    sqlite3 *theDatabase;
    if (!(sqlite3_open([sqlitePath UTF8String], &theDatabase) == SQLITE_OK)) {
        NSLog(@"ERROR. COULD NOT OPEN AT %@", sqlitePath);
    }
    
    
    // create NSString and C string for SQL statement
    
    NSMutableString *sqlStatementNSString = [[NSMutableString alloc] initWithString:@"SELECT * FROM locations;"];
    
    NSLog(@"sqlStatementNSString is %@", sqlStatementNSString);
    
    const char *sql = [sqlStatementNSString UTF8String];

    
    // initialize and prepare a SQL statement
    
    sqlite3_stmt *sqlStatement;
    int status = sqlite3_prepare(theDatabase, sql, -1, &sqlStatement, NULL);
    if (status != SQLITE_OK) {
        NSLog(@"PROBLEM WITH PREPARE STATEMENT: %d %s", status, sqlite3_errmsg(theDatabase));
    }
    
    
    // step through the SQL statement
    
    self.signObjects = [[NSMutableArray alloc] init];

    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
        NSInteger signSequence = (NSInteger)sqlite3_column_int(sqlStatement, 2);
        NSInteger signFeetFromStreet = (NSInteger)sqlite3_column_int(sqlStatement, 3);
        char *signRegulation = (char *)sqlite3_column_text(sqlStatement, 5) ?: "";  //  ?: ""   is for when the entry is null, to feed an empty string
        char *signMainStreet = (char *)sqlite3_column_text(sqlStatement, 7) ?: "";
        char *signFromStreet = (char *)sqlite3_column_text(sqlStatement, 8) ?: "";
        char *signToStreet = (char *)sqlite3_column_text(sqlStatement, 9) ?: "";
        char *signStreetSide = (char *)sqlite3_column_text(sqlStatement, 10) ?: "";

    // assign to objects and put into array
    
        NSString *regulation = [NSString stringWithUTF8String:signRegulation];
        NSString *mainStreet = [NSString stringWithUTF8String:signMainStreet];
        NSString *fromStreet = [NSString stringWithUTF8String:signFromStreet];
        NSString *toStreet = [NSString stringWithUTF8String:signToStreet];
        NSString *streetSide = [NSString stringWithUTF8String:signStreetSide];
        
        NSDictionary *aSign = [[NSDictionary alloc] initWithObjects:@[@(signSequence), @(signFeetFromStreet), regulation, mainStreet, fromStreet, toStreet, streetSide] forKeys:@[@"sequence", @"feetFromStreet", @"regulation", @"mainStreet", @"fromStreet", @"toStreet", @"streetSide"]];
        
        [self.signObjects addObject:aSign];
        
        
        
    }
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(theDatabase);

    
    NSLog(@"%@", self.signObjects);

 
    
    
    
    /*****************************
     *       TRYING FISSign      *
     *****************************/
    
    // from Date Picker
    
//     NSDate *currentDate = self.datePicker.date;
//     NSCalendar *currentCalendar = [NSCalendar currentCalendar];
//     NSDateComponents *dateComponents = [currentCalendar components:(NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currentDate];
//     NSUInteger dayOfWeek = [dateComponents weekday];
//     NSUInteger hour = [dateComponents hour];
//    NSLog(@"%lu", hour);
//    // placeholder days array
//    
//     NSArray *daysOfTheWeek = @[@"nil", @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
    

    //putting sign objects on the map
    
//commented out for time being to test IF STATEMENT
    //    FISSign *aSign = [[FISSign alloc] initWithCoordinates:CLLocationCoordinate2DMake(40.707721, -74.012952) hourStarts:12 hourEnds:13 signDays:daysOfTheWeek regulation:@"FREE PARKING ALL THE TIME! :)"withMapView:self.mapView withDatePicker:self.datePicker];
//    
//
//    FISSign *anotherSign = [[FISSign alloc] initWithCoordinates:CLLocationCoordinate2DMake(40.707019, -74.013433) hourStarts:13 hourEnds:15 signDays:daysOfTheWeek regulation:@"FREE PARKING ALL THE TIME! :)"withMapView:self.mapView withDatePicker:self.datePicker];


    
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
    
//    CLLocationCoordinate2D aSignLocation;
//    aSignLocation.latitude = 40.707721;
//    aSignLocation.longitude = -74.012952;

    FISSign *aSign = [[FISSign alloc] initWithCoordinates:CLLocationCoordinate2DMake(40.707721, -74.012952)
                                               hourStarts:12
                                                 hourEnds:16
                                                 signDays:@[@"Tuesday", @"Wednesday"]
                                               regulation:@"FREE PARKING ALL THE TIME! :)"
                                              withMapView:self.mapView
                                           withDatePicker:self.datePicker];
    
    
    FISSign *anotherSign = [[FISSign alloc] initWithCoordinates:CLLocationCoordinate2DMake(40.707019, -74.013433)
                                                     hourStarts:13
                                                       hourEnds:15
                                                       signDays:@[@"Tuesday"]
                                                     regulation:@"FREE PARKING ALL THE TIME! :)"
                                                    withMapView:self.mapView
                                                 withDatePicker:self.datePicker];
    NSArray *dots = @[aSign, anotherSign];

    // this removes ALL overlays
    [self.mapView removeOverlays: self.mapView.overlays];
    for (FISSign *sign in dots) {
        for (NSUInteger i = 0; i < (sign.signDays.count); i++)
        {
            NSLog(@"in for loop in datePickerDidPickDate");
            if ((sign.hourStarts <= hour) && (hour < sign.hourEnds) && ([sign.signDays containsObject:daysOfTheWeek[dayOfWeek]]))
            {
                NSLog(@"MATCHED CRITERIA IN IF STATEMENT");
                //shows the circle; copied from FISSign.m
                FISCircle *aCircle = (FISCircle *)[FISCircle circleWithCenterCoordinate:sign.coordinates radius:9];
                aCircle.color = [UIColor colorWithRed:0 green:255 blue:213 alpha:0.8];
                [_mapView addOverlay:aCircle];
            }
        }

    }
    
    
}
//copied from FISSign.m
- (MKCircleRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{

    NSLog(@"GETTING CALLED MAP VIEW THING\n\n\n\n\n HI HI HI HI\n\n\n\n\n");
    
    if ([overlay isKindOfClass:FISCircle.class]) {
        
        FISCircle *circle = (FISCircle *)overlay;
        UIColor *colorOfCircle = circle.color;
        
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleView.fillColor = colorOfCircle;
        
        return circleView;
    }
    
    return nil;
}
//making circles tappable

-(void)mapTapped:(UITapGestureRecognizer *)recognizer
{
    
    CGPoint point = [recognizer locationInView:self.mapView];
    
    NSArray *arrayOfStuff = self.mapView.overlays;

    
    id<MKOverlay> tappedOverlay = nil;
    for (FISCircle *circle in self.mapView.overlays)
    {
        
        MKOverlayRenderer * polygonRenderer = [self.mapView rendererForOverlay:circle];
        if ( [polygonRenderer isKindOfClass:[MKPolygonRenderer class]]) {
            
            //Convert the point
            CLLocationCoordinate2D  coordinate = [self.mapView convertPoint:point
                                                       toCoordinateFromView:self.mapView];
            MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
            CGPoint polygonViewPoint = [polygonRenderer pointForMapPoint:mapPoint];
            
            // with iOS 7 you need to invalidate the path, this is not required for iOS 8
            
            
            
            
//            tapInPolygon = CGPathContainsPoint(polygonRenderer.path, NULL, polygonViewPoint, NO);
        }
        
        
        
        
//        MKPolygonView *view = (MKPolygonView *)[self.mapView viewForOverlay:circle];
//        
//        if (view){
//            CGPoint touchPoint = [recognizer locationInView:self.mapView];
//            CLLocationCoordinate2D touchMapCoordinate =
//            [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
//            
//            MKMapPoint mapPoint = MKMapPointForCoordinate(touchMapCoordinate);
//            
//            CGPoint polygonViewPoint = [view pointForMapPoint:mapPoint];
//            if(CGPathContainsPoint(view.path, NULL, polygonViewPoint, NO)){
//                tappedOverlay = view;
//                tappedOverlay.tag = i;
//                break;
//            }


        
        
        CGRect rectOfCircle = CGRectMake(circle.boundingMapRect.origin.x, circle.boundingMapRect.origin.y, circle.boundingMapRect.size.width, circle.boundingMapRect.size.height);
        
        
        CGRect something = [self.view convertRect:rectOfCircle fromView:self.mapView];
        
        
        
//        CGPoint test = [self.view convertRect: fromView:<#(nullable UIView *)#>]
        
        MKOverlayRenderer *view = [self.mapView rendererForOverlay:circle];
        if (view)
        {
            
            CGPoint point = [recognizer locationInView:self.mapView];
            
            
//            CGRect viewFrameInMapView = [view.superview convertRect:view.frame toView:mapView];
//            // Get touch point in the mapView's coordinate system
//            CGPoint point = [recognizer locationInView:mapView];
//            // Check if the touch is within the view bounds
            
            
            
            
//            CGRect viewFrameInMapView = [view.superview convertRect:view.frame toView:mapView];
//            CGPoint point = [recognizer locationInView:self.mapView];
//            if (CGRectContainsPoint(viewFrameInMapView, point))
//            {
//                tappedOverlay = circle;
//                break;
//            }
        }
    }
//    NSLog(@"Tapped view: %@", [mapView viewForOverlay:tappedOverlay]);
}

// next steps:

// CIRCLES ARE TAPABLE

// WHEN A CIRCLE IS TAPPED, A SMALL VIEW FADES IN THAT DISPLAYS THE SIGN'S REGULATION TEXT
// CLOSE THE SMALL VIEW BY TAPPING ANYWHERE

//-(BOOL)displayCircle:(FISSign *)streetSign
//{
//    NSUInteger signHourStarts = streetSign.hourStarts;
//    NSUInteger signHourEnds = streetSign.hourEnds;
//    if (()) {
//        <#statements#>
//    }
//}























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




