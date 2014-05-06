//
//  DSGFullDetailPhoto.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSGFullDetailPhoto : NSObject

@property (nonatomic, strong, readonly) NSString *title;

@property (nonatomic, strong, readonly) NSString *identification;

@property (nonatomic, strong, readonly) NSDictionary *photoData;

@property (nonatomic, strong, readonly) NSArray *notes;

@property (nonatomic, strong, readonly) NSURL *orginalImage;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(void) fetchOriginalImageWithCompletetionBlock:(void (^)(BOOL))completion;
@end
