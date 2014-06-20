//
//  RCAnnotation.h
//  LocationPractice
//
//  Created by xuzepei on 6/20/14.
//  Copyright (c) 2014 TapGuilt Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface RCAnnotation : NSObject<MKAnnotation>

@property(nonatomic,readonly)CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
