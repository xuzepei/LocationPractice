//
//  RCRGViewController.h
//  LocationPractice
//
//  Created by xuzepei on 6/19/14.
//  Copyright (c) 2014 TapGuilt Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RCRGViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property(nonatomic,weak)IBOutlet UITextView* textView;
@property(nonatomic,weak)IBOutlet UILabel* label;
@property(nonatomic,weak)IBOutlet MKMapView* mapView;
@property(nonatomic,strong)CLLocationManager* manager;
@property(nonatomic,strong)CLLocation* currentLocation;

@end
