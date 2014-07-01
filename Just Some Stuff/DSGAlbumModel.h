//
//  DSGAlbumModel.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGImageCollectionProtocol.h"
#import "DSGPhotoSet.h"

@interface DSGAlbumModel : NSObject <DSGImageCollectionProtocol>

@property (nonatomic, strong, readonly) DSGPhotoSet *allPhotos;
@property (nonatomic, strong) NSArray *filteredPhotos;

-(instancetype)initWithPhotoSet:(DSGPhotoSet *)photoSet;

-(void)reset;

-(void)searchAblumUsingText:(NSString *)searchText completionBlock:(void (^)(BOOL))completion;
@end
