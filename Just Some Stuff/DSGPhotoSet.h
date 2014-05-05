//
//  DSGPhotoSet.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGBasicPhoto.h"

@interface DSGPhotoSet : NSObject

@property (strong, nonatomic, getter = identifier) NSString *set_identifer;

@property (strong, nonatomic, getter = title) NSString *set_title;

@property (strong, nonatomic, getter = setDescription) NSString *set_description;

@property (strong, nonatomic) NSURL *coverUrl;

@property (strong, nonatomic) NSArray *photoUrls;

@property (strong, nonatomic, readonly) NSArray *photos;

-(instancetype)initWithDitctionary:(NSDictionary *)dictionary;

-(NSUInteger)numberOfPhotos;

-(NSSet *) photoIDSet;

@end
