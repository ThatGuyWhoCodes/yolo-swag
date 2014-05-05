//
//  DSGBasicPhoto.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 02/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGBasicPhoto.h"

@implementation DSGBasicPhoto

-(instancetype)initWithTitle:(NSString *)title imageURL:(NSURL *)imageURL
{
    self = [super init];
    if (self)
    {
        [self setTitle:title];
        [self setImageURL:imageURL];
    }
    return self;
}

@end
