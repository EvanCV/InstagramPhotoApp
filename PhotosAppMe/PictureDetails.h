//
//  PictureDetails.h
//  PhotosAppMe
//
//  Created by Shannon Beck on 1/22/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ImageCollectionViewCell.h"

@interface PictureDetails : NSObject

@property NSString *photoUrl;
@property BOOL hasBeenFavorited;
@property float latitude;
@property float longitude;
@property UIImage *heartImage;

@end
