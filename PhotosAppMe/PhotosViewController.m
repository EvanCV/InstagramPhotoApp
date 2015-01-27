//
//  FirstViewController.m
//  PhotosAppMe
//
//  Created by Shannon Beck on 1/22/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import "PhotosViewController.h"
#import "PictureDetails.h"
#import "ImageCollectionViewCell.h"
#import "FavoritesViewController.h"

@interface PhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *photosArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSIndexPath *path;
@property NSURL *urlToPList;

@end

@implementation PhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosArray = [[NSMutableArray alloc]init];
    [self setPlistPath];
    self.favoritesArray = [[NSMutableArray alloc]init];

    //if there is content in pList we will pass the entire dictionary object opposed to
    //just the url to a photo
    if ([NSData dataWithContentsOfURL:self.urlToPList])
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithContentsOfURL:self.urlToPList];
        for (NSDictionary *dictionaryObject in tempArray)
        {
            PictureDetails *newPhoto = [[PictureDetails alloc]initWithDictionary:dictionaryObject];
            [self.favoritesArray addObject:newPhoto];
        }
    }
}

- (void)setPlistPath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    self.urlToPList = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    self.urlToPList = [self.urlToPList URLByAppendingPathComponent:@"favorites.plist"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureDetails *picture = [self.photosArray objectAtIndex:indexPath.row];
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];

    NSURL *imageURL = [NSURL URLWithString:picture.photoUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    cell.cellImageView.image = [UIImage imageWithData:imageData];

    cell.accessoryImageView.image = picture.heartImage;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.path = indexPath;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
}


//on tap gesture user can favorite and store the phots
- (IBAction)gestureRecognizer:(id)sender
{
    PictureDetails *picture = [self.photosArray objectAtIndex:self.path.row];

    picture.hasBeenFavorited = YES;

    [self pictureHasBeenFavorited:self.photosArray];
    [self.favoritesArray addObject:picture];
    [self storeFavoritedPics];


    [self.collectionView reloadData];
}



//----------------------------------------API Search--------------------------------------

-(void)parser:(NSString *)searchCriteria
{
    [self.photosArray removeAllObjects];

    NSString *currentURL = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=11102558.1fb234f.23a625c7878644a4aa531db7eed42c5a", searchCriteria];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:currentURL]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

         int i = 0;

         NSArray *array = dataArray[@"data"];

         for (NSDictionary *currentDictionary in array)
         {
             if (i < 10)
             {
                 [self unpackDictionary:currentDictionary];
                 i++;
             }
         }
         [self pictureHasBeenFavorited:self.photosArray];
         [self.collectionView reloadData];
     }];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self parser:searchBar.text];
    [searchBar resignFirstResponder];
}


-(void)unpackDictionary:(NSDictionary *)dict
{
    PictureDetails *picture = [PictureDetails new];

    NSDictionary *dd = dict[@"location"];

    if (![dict[@"location"] isKindOfClass:[NSNull class]])
    {
        picture.latitude = dd[@"latitude"];
        picture.longitude = dd[@"longitude"];
    }

    NSDictionary *dd2 = dict[@"images"];
    NSDictionary *dd3 = dd2[@"standard_resolution"];
    picture.photoUrl = dd3[@"url"];
    picture.heartImage = nil;

    [self.photosArray addObject:picture];
}



//------------------------------------Handle Storing Favorited Pics--------------------------

-(void)pictureHasBeenFavorited :(NSMutableArray *)thisArray
{
    for (PictureDetails *picture in thisArray)
    {
        if (picture.hasBeenFavorited)
        {
            picture.heartImage = [UIImage imageNamed:@"heart.png"];

        }
    }
}


//Store favorited pictures to plist
-(void)storeFavoritedPics
{
    NSMutableArray *temp = [NSMutableArray new];

    for (PictureDetails *details in self.favoritesArray)
    {
        NSMutableDictionary *newPhotoDictionary = [NSMutableDictionary new];
        [newPhotoDictionary setValue:details.photoUrl forKey:@"PhotoURL"];
        [newPhotoDictionary setValue:details.longitude forKey:@"Longitude"];
        [newPhotoDictionary setValue:details.latitude forKey:@"Latitude"];
        [temp addObject:newPhotoDictionary];
    }

    //Serialize data in binary for improved performance
    NSData *serializedData = [NSPropertyListSerialization dataWithPropertyList:temp format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];

    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL *documents = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    documents = [documents URLByAppendingPathComponent:@"favorites.plist"];
    [serializedData writeToURL:documents atomically:YES];
}


@end
