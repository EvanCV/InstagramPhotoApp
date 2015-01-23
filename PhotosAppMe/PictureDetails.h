//
//  PictureDetails.h
//  PhotosAppMe
//
//  Created by Shannon Beck on 1/22/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PictureDetails : NSObject

@property NSString *photoUrl;
//@property MKMapItem *mapItem;
@property BOOL hasBeenFavorited;
@property float latitude;
@property float longitude;

@end
