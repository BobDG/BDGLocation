//
//  BDGLocation.m
//
//  Created by Bob de Graaf on 01-02-14.
//  Copyright (c) 2014 GraafICT. All rights reserved.
//

#import "BDGLocation.h"

@interface BDGLocation () <CLLocationManagerDelegate>

@end

@implementation BDGLocation

#pragma mark Init

-(id)init
{
    self = [super init];
    if(!self) {
        return nil;
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    //Request authorization in iOS8
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.distanceFilter = 1;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    self.minHorizontalAccuracy = 1000.0f;
    
    #if TARGET_IPHONE_SIMULATOR
    _gpsLoc = [[CLLocation alloc] initWithLatitude:51.0405 longitude:3.77699];
    #endif
    
    return self;
}

#pragma mark Update Location

-(void)updateLocation
{
    if(![CLLocationManager locationServicesEnabled]) {
        if([self.delegate respondsToSelector:@selector(locationGPSOff)]) {
            [self.delegate locationGPSOff];
        }
    }
    else {
        [self.locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if([self.delegate respondsToSelector:@selector(locationDidChangeAuthorizationStatus:)]) {
        [self.delegate locationDidChangeAuthorizationStatus:status];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"BGDLocation: Error updating location: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            if([self.delegate respondsToSelector:@selector(locationNotAllowed)]) {
                [self.delegate locationNotAllowed];
            }
            break;
        case kCLErrorLocationUnknown:
            //Hopefully temporary...
            if([self.delegate respondsToSelector:@selector(locationFail)]) {
                [self.delegate locationFail];
            }
            break;
        default:
            //Unknown error
            if([self.delegate respondsToSelector:@selector(locationFail)]) {
                [self.delegate locationFail];
            }
            break;
    }
    
    if(self.stopUpdatingImmediately) {
        [self.locationManager stopUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(!locations.count) {
        return;
    }
    
    CLLocation *newLocation = locations.lastObject;
    NSDate* newLocationeventDate = newLocation.timestamp;
    NSTimeInterval howRecentNewLocation = [newLocationeventDate timeIntervalSinceNow];
    if((howRecentNewLocation < -0.0 && howRecentNewLocation > -10.0) && (newLocation.horizontalAccuracy >= 0 && newLocation.horizontalAccuracy <= self.minHorizontalAccuracy)) {
        [self setGpsLoc:newLocation];
        if([self.delegate respondsToSelector:@selector(locationUpdated:)]) {
            [self.delegate locationUpdated:self.gpsLoc];
        }
        if(self.stopUpdatingImmediately) {
            [self.locationManager stopUpdatingLocation];
        }
    }
}

#pragma mark Singleton

+(id)sharedBDGLocation
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark Dealloc

-(void)dealloc
{
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    self.gpsLoc = nil;
}

@end



























