//
//  DSGBrowseTableViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGBrowseTableViewController.h"
#import "DSGPhotoAlbumTableViewController.h"
#import "DSGPhotoCollection.h"

@interface DSGBrowseTableViewController ()

@property (strong, nonatomic) NSMutableArray *collectionsData;

@end

@implementation DSGBrowseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionsData = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated
{
    FKFlickrCollectionsGetTree *collectionTree = [[FKFlickrCollectionsGetTree alloc] init];
    [collectionTree setUser_id:@"102927591@N02"];
    
    [[FlickrKit sharedFlickrKit] call:collectionTree completion:^(NSDictionary *response, NSError *error) {
        // Note this is not the main thread!
        
        if (response)
        {
            NSMutableArray *collectionTreeArray = [NSMutableArray array];
            for (NSDictionary *collectionData in [response valueForKeyPath:@"collections.collection"])
            {
                //NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall320 fromPhotoDictionary:photoData];
                [collectionTreeArray addObject:[[DSGPhotoCollection alloc] initWithDictionary:collectionData]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.collectionsData = collectionTreeArray;
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.collectionsData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellID = @"_BROWSE_CELL_ID_";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellID forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellID];
    }
    
    DSGPhotoCollection* collection = [self.collectionsData objectAtIndex:indexPath.row];
    [cell.textLabel setText:[collection title]];// Configure the cell...
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    
    DSGPhotoCollection *currentCollection = [self.collectionsData objectAtIndex:indexPath.row];
    
    [(DSGPhotoAlbumTableViewController *)segue.destinationViewController setPhotoSet:[currentCollection collectionImageSet]];
    
    [[(DSGPhotoAlbumTableViewController *)segue.destinationViewController navigationItem] setTitle:[currentCollection title]];
}


@end
