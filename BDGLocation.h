//
//  LocationGetter.h
//
//  Created by Bob de Graaf on 01-02-14.
//  Copyright (c) 2014 GraafICT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol BDGLocationDelegate <NSObject>
-(void)locationFail;
-(void)locationGPSOff;
-(void)locationNotAllowed;
-(void)locationUpdated:(CLLocation *)location;
@optional
-(void)locationDidChangeAuthorizationStatus:(CLAuthorizationStatus)status;
@end

@interface BDGLocation : NSObject
{
}

-(void)updateLocation;

@property(nonatomic) float minHorizontalAccuracy;
@property(nonatomic) bool stopUpdatingImmediately;
@property(nonatomic,assign) id<BDGLocationDelegate> delegate;

@property(nonatomic,retain) CLLocation *gpsLoc;
@property(nonatomic,retain) CLLocationManager *locationManager;

+(BDGLocation *)sharedBDGLocation;

@end