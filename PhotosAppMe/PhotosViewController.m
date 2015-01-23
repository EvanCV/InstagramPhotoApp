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

@interface PhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *photosArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;



@end

@implementation PhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosArray = [[NSMutableArray alloc]init];

}

-(void)parser:(NSString *)searchCriteria
{
    [self.photosArray removeAllObjects];

    NSString *currentURL = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=11102558.1fb234f.23a625c7878644a4aa531db7eed42c5a", searchCriteria];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:currentURL]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
       //  NSLog(@"%@", self.photosArray);

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

        // [self reloadInputViews];
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
        picture.latitude = [dd[@"latitude"]floatValue];
        picture.longitude = [dd[@"longitude"]doubleValue];
    }

    NSDictionary *dd2 = dict[@"images"];
    NSDictionary *dd3 = dd2[@"standard_resolution"];
    picture.photoUrl = dd3[@"url"];

    [self.photosArray addObject:picture];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    PictureDetails *picture = [self.photosArray objectAtIndex:indexPath.row];

    NSURL *imageURL = [NSURL URLWithString:picture.photoUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    cell.cellImageView.image = [UIImage imageWithData:imageData];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
}


@end
