//
//  DSGPhoto.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 14/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSGPhoto : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * identification;
@property (nonatomic, retain) NSString * imageURLString;

@end
