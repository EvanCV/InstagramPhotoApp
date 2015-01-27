//
//  PictureDetails.m
//  PhotosAppMe
//
//  Created by Shannon Beck on 1/22/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import "PictureDetails.h"

@implementation PictureDetails

- (instancetype)initWithDictionary: (NSDictionary *) dictionary
{
    self = [super init];
    if (self)
    {
        self.photoUrl = dictionary[@"PhotoURL"];
        if (dictionary[@"Latitude"] && dictionary[@"Longitude"])
        {
            self.longitude = dictionary[@"Longitude"];
            self.latitude = dictionary[@"Latitude"];
        }

    }
    return self;
}


@end
