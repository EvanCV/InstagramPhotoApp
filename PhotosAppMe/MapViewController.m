//
//  MapViewController.m
//  PhotosAppMe
//
//  Created by Shannon Beck on 1/22/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <MKMapViewDelegate>

@property NSMutableArray *favoritePicsArray;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadFavoritedPics];
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;

    NSMutableArray *annotationsArray = [NSMutableArray new];
    for (PictureDetails *details in self.favoritePicsArray)
    {
        if (details.longitude != 0  && details.latitude != 0)
        {
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            //Remember long&Lat need double type values
            CLLocationCoordinate2D  ctrpoint;
            ctrpoint.latitude = [details.latitude floatValue];
            ctrpoint.longitude = [details.longitude floatValue];
            annotation.coordinate = CLLocationCoordinate2DMake(ctrpoint.latitude, ctrpoint.longitude);
            [annotationsArray addObject:annotation];
        }
    }
    [self.mapView addAnnotations:annotationsArray];
}


//Same function used to extract data from the plist in Favorites VC
-(void)loadFavoritedPics
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL *documents = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    documents = [documents URLByAppendingPathComponent:@"favorites.plist"];

    // Read plist from bundle and get Root Dictionary out of it
    NSArray *rootArray = [NSArray arrayWithContentsOfURL:documents];
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary * details in rootArray)
    {
        PictureDetails * picProperties = [[PictureDetails alloc] init];
        picProperties.photoUrl = details[@"PhotoURL"];
        picProperties.longitude = details[@"Longitude"];
        picProperties.latitude = details[@"Latitude"];
        [tempArray addObject:picProperties];
    }
    self.favoritePicsArray = tempArray;
}


//Place a pin at each stops coordinates
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    return pin;
}


@end
