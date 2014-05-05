//
//  DSGBasicPhoto.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 02/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSGBasicPhoto : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *identification;
@property (strong, nonatomic) NSURL *imageURL;

-(instancetype)initWithDictionary:(NSDictionary *)photoDictionary;

@end
