//
//  DSGAlbumModel.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGPhotoSet.h"

@interface DSGAlbumModel : NSObject

@property (nonatomic, strong, readonly) DSGPhotoSet *allPhotos;
@property (nonatomic, strong) NSArray *filteredPhotos;

-(instancetype)initWithPhotoSet:(DSGPhotoSet *)photoSet;

-(NSUInteger)numberOfPhotos;

-(NSURL *)imageURLAtIndex:(NSUInteger)index;

-(void)searchAblumUsingText:(NSString *)searchText completionBlock:(void (^)(BOOL))complection;
@end
