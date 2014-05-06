//
//  DSGFullDetailPhoto.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGFullDetailPhoto.h"

@implementation DSGFullDetailPhoto

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        NSDictionary *photo = [dictionary objectForKey:@"photo"];
        if (photo)
        {
            _photoData = dictionary;
            _title = [[photo objectForKey:@"title"] objectForKey:@"_content"];
            _identification = [photo objectForKey:@"id"];
            _notes = [[photo objectForKey:@"notes"] objectForKey:@"note"];
        }
    }
    return self;
}

-(void) fetchOriginalImageWithCompletetionBlock:(void (^)(BOOL))completion
{
    FKFlickrPhotosGetSizes *getPhotoSizes = [[FKFlickrPhotosGetSizes alloc] init];
    [getPhotoSizes setPhoto_id:self.identification];
    
    [[FlickrKit sharedFlickrKit] call:getPhotoSizes completion:^(NSDictionary *response, NSError *error) {
        
        if ([[response objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            NSArray *imagesData = [[response objectForKey:@"sizes"] objectForKey:@"size"];
            NSString *urlString = [[imagesData lastObject] objectForKey:@"source"];
            _orginalImage = [NSURL URLWithString:urlString];
            completion(YES);
        }
        else
        {
            completion(NO);
        }
    }];
}

@end
