//
//  DSGHomeModel.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 17/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGHomeModel.h"

@implementation DSGHomeModel

+(DSGHomeModel *)sharedInstance
{
    static dispatch_once_t pred;
    static DSGHomeModel *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[DSGHomeModel alloc] init];
    });
    return sharedInstance;
}

-(void)clean
{
    [self.photoData removeAllObjects];
}

-(void)freshPull
{
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    [fk call:interesting completion:^(NSDictionary *response, NSError *error) {
        // Note this is not the main thread!
        if (response)
        {
            NSMutableArray *photoURLs = [NSMutableArray array];
            for (NSDictionary *pData in [response valueForKeyPath:@"photos.photo"])
            {
                NSURL *url = [fk photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:pData];
                [photoURLs addObject:url];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // Any GUI related operations here
            });
        }
    }];
}

@end
