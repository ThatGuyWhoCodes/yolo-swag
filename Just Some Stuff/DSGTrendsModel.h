//
//  DSGFeaturedModel.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 12/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGPhotoCollection.h"

@interface DSGTrendsModel : NSObject

@property (nonatomic, strong) NSMutableArray *featuredTrends;

+(DSGTrendsModel *)sharedInstance;

-(void)fetchDataWithCompletionBlock:(void (^)(BOOL))completion;

-(NSUInteger)numberOfTrends;

@end
