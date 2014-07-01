//
//  DSGHomeModel.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 17/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGImageCollectionProtocol.h"
#import "DSGBasicPhoto.h"

@interface DSGHomeModel : NSObject <DSGImageCollectionProtocol>

@property (nonatomic, strong) NSMutableArray *photoData;

@property (strong, nonatomic) DSGBasicPhoto *selectedPhoto;

/**
 * Remove all data in the model
 */
-(void)clean;


/**
 * A fresh pull of the photo data
 */
-(void)freshPullWithCompletionBlock:(void (^)(BOOL))completion;

+(DSGHomeModel *)sharedInstance;

@end
