//
//  FISAnnotation.m
//  FISParkingFinder
//
//  Created by Matthew Chang on 11/19/15.
//  Copyright © 2015 Flatiron. All rights reserved.
//

#import "FISAnnotation.h"


@implementation FISAnnotation

@synthesize coordinate = _coordinate;

@synthesize title = _title;

-(id) initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    _title = title;
    _coordinate = coordinate;
    return self;
    
}

@end
