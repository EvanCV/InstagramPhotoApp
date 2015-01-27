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

- (instancetype)initWithDictionary: (NSDictionary *) dictionary;

@property NSString *photoUrl;
@property BOOL hasBeenFavorited;
@property NSString *latitude;
@property NSString *longitude;
@property UIImage *heartImage;

@end
