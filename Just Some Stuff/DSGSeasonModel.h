//
//  DSGBrowseModel.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 02/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DSGPhotoCollection.h"
#import "DSGNestedCollection.h"

@interface DSGSeasonModel : NSObject

@property (strong, nonatomic) NSMutableArray *collectionsData;

+(DSGSeasonModel *)sharedInstance; 

-(void)fetchDataWithCompletionBlock:(void (^)(BOOL))completion;

-(NSUInteger) count;

@end
