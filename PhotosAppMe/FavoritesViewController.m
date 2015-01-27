//
//  SecondViewController.m
//  PhotosAppMe
//
//  Created by Shannon Beck on 1/22/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

@property NSMutableArray *favoritePicsArray;

@end

@implementation FavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.favoritePicsArray = [NSMutableArray new];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadFavoritedPics];
    [self.CollectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.favoritePicsArray.count;
}


- (ImageCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    PictureDetails *picture = [self.favoritePicsArray objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:picture.photoUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    cell.favoritesImageView.image = [UIImage imageWithData:imageData];

    return cell;
}


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
    [self.CollectionView reloadData];
}



@end
