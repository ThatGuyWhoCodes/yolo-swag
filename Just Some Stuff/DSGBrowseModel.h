//
//  DSGBrowseModel.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 02/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGPhotoCollection.h"

@interface DSGBrowseModel : NSObject

@property (strong, nonatomic) NSMutableArray *collectionsData;

+(DSGBrowseModel *)sharedInstance; 

-(void)fetchDataWithCompletionBlock:(void (^)(BOOL))complection;

@end
