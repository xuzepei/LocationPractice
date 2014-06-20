//
//  RCRGViewController.m
//  LocationPractice
//
//  Created by xuzepei on 6/19/14.
//  Copyright (c) 2014 TapGuilt Inc. All rights reserved.
//

#import "RCRGViewController.h"
#import "RCAnnotation.h"

@interface RCRGViewController ()

@end

@implementation RCRGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取当前的地理位置
    [self updateLocation];
    
    //监视区域
    //[self monitor];
}

- (void)dealloc
{
    [_manager stopUpdatingLocation];
    
    for (CLRegion* region in _manager.monitoredRegions) {
        [_manager stopMonitoringForRegion:region];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)updateLocation
{
    if(nil == _manager)
    {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    
    [_manager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations objectAtIndex:0];
    
    // Center the map the first time we get a real location change.
	static dispatch_once_t token;
	if ((location.coordinate.latitude != 0.0) && (location.coordinate.longitude != 0.0) && nil == self.currentLocation) {
		dispatch_once(&token, ^{
            
            self.currentLocation = location;
            //			[self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 1000, 1000);
            viewRegion = [self.mapView regionThatFits:viewRegion];
            [self.mapView setRegion:viewRegion animated:YES];
            
            [self reverse];
            
            //[self monitor];
		});
	}
}

- (void)locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"didStartMonitoringForRegion:%f,%f",region.center.latitude,region.center.longitude);
}

- (void)locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Enter Region 0" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alertView show];
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    NSLog(@"%s",__FUNCTION__);
}

/*将地理坐标转化为地址*/
- (void)reverse
{
    if(nil == self.currentLocation)
        return;
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error)
        {
            NSLog(@"error:%@",[error localizedDescription]);
            return;
        }
        
        CLPlacemark* placemark = [placemarks objectAtIndex:0];
        
        NSArray* addressLines = [placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
        NSString* address = [addressLines componentsJoinedByString:@"\n"];
        self.textView.text = address;
        
        [self geocode:address];
        
        self.label.text = [NSString stringWithFormat:@"lat:%lf,long:%lf",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude];
        
        [self updateMap];
    }];
}

/*将地址转化为地理坐标*/
- (void)geocode:(NSString*)address
{
    if(0 == [address length])
        return;
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error)
        {
            NSLog(@"error:%@",[error localizedDescription]);
            return;
        }
        
        CLPlacemark* placemark = [placemarks objectAtIndex:0];
        
        NSString* temp = [NSString stringWithFormat:@"geocoding result: lat:%lf,long:%lf",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude];
        NSLog(@"%@",temp);
    }];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
	// Center the map the first time we get a real location change.
	static dispatch_once_t token;
	if ((userLocation.coordinate.latitude != 0.0) && (userLocation.coordinate.longitude != 0.0)) {
		dispatch_once(&token, ^{
//			[self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
            viewRegion = [self.mapView regionThatFits:viewRegion];
            [self.mapView setRegion:viewRegion animated:YES];
		});
	}
}

/*在地图中显示地理坐标*/
- (void)updateMap
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 1000, 1000);
    viewRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:viewRegion animated:YES];
    
    //延迟添加注释点，以便显示动画
    [self performSelector:@selector(addAnnotation) withObject:nil afterDelay:1.0];
}

/*添加注释点*/
- (void)addAnnotation
{
    //添加注释点,mapView的addAnnotation方法，需要实现了<MKAnnotation>的对象
//方法1:
    MKPlacemark* marker = [[MKPlacemark alloc] initWithCoordinate:self.currentLocation.coordinate addressDictionary:nil];
    [self.mapView addAnnotation:marker];

//方法2:
//    [self.mapView addAnnotation:[[RCAnnotation alloc] initWithCoordinate:self.currentLocation.coordinate]];
}

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    
    if([annotation isKindOfClass:[MKPlacemark class]])
    {
        MKPinAnnotationView *pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"annotation_ID"];
        if (pin == nil) {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"annotation_ID"];
        } else {
            pin.annotation = annotation;
        }
        pin.pinColor = MKPinAnnotationColorRed;
        pin.animatesDrop = YES;
        return pin;
    }

    return nil;
}

#pragma mark - Monitor

- (void)monitor
{

//        CLRegion* region = [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(30.680171, 104.089070) radius:1000 identifier:@"monitor_region_0"];
    
    CLLocationDegrees radius = 1000;
    if(radius > self.manager.maximumRegionMonitoringDistance)
    {
        radius = self.manager.maximumRegionMonitoringDistance;
    }
    
    CLCircularRegion* region = [[CLCircularRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(30.680171, 104.089070) radius:radius identifier:@"monitor_region_0"];
    
    [self.manager startMonitoringForRegion:region];
  
}

@end
