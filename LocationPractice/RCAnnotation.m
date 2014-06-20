//
//  RCAnnotation.m
//  LocationPractice
//
//  Created by xuzepei on 6/20/14.
//  Copyright (c) 2014 TapGuilt Inc. All rights reserved.
//

#import "RCAnnotation.h"

@implementation RCAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if(self = [super init])
    {
        _coordinate = coordinate;
    }
    
    return self;
}

@end
