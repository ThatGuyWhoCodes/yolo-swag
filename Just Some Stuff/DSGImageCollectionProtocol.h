//
//  DSGImageCollectionProtocol.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 20/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGBasicPhoto.h"

@protocol DSGImageCollectionProtocol <NSObject>

@required
- (NSUInteger)numberOfPhotos;

- (NSURL *)photoURLAtIndex:(NSUInteger)index;

- (BOOL)setSelectedPhotoAtIndex:(NSUInteger)index;

- (DSGBasicPhoto *)getSelectedPhoto;

- (NSInteger)indexOfSlectedPhoto;

@end
