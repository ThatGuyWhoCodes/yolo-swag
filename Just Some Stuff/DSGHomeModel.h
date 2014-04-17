//
//  DSGHomeModel.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 17/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSGHomeModel : NSObject

@property (nonatomic, strong) NSMutableDictionary *photoData;

/**
 * Remove all data in the model
 */
-(void)clean;


/**
 * A fresh pull of the photo data
 */
-(void)freshPull;


@end
