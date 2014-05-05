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
        sharedInstance.photoData = [NSMutableArray array];
    });
    return sharedInstance;
}

-(void)clean
{
    [self.photoData removeAllObjects];
}

-(BOOL)setSelectedPhotoUsingIndex:(NSUInteger)index
{
    
    if (!self.photoData)
    {
        return NO;
    }
    
    self.selectedPhoto = [self.photoData objectAtIndex:index];
    return YES;
}

-(void)freshPullWithCompletionBlock:(void (^)(BOOL))complection
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
               [photoURLs addObject:[[DSGBasicPhoto alloc] initWithDictionary:pData]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([photoURLs count] > 1)
                {
                    self.photoData = photoURLs;
                    complection(YES);
                }
                else
                {
                    complection(NO);
                }
            });
        }
    }];
}

@end
