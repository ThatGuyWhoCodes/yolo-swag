//
//  DSGPhotoCollection.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGPhotoSet.h"

@interface DSGPhotoCollection : NSObject

@property (strong, nonatomic, getter = identifier) NSString *collection_identifier;

@property (strong, nonatomic, getter = title) NSString *collection_title;

@property (strong, nonatomic, getter = collectionDescription) NSString *collection_description;

@property (strong, nonatomic, getter = collectionImageSet) NSMutableArray *collection_imagesSet;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(void)parseCoverWithDitction:(NSDictionary *)dict andCompletetion:(void (^)(BOOL))completion;

-(void)parseCoverWithDitction:(NSDictionary *)dict group:(dispatch_group_t)disPatchGroup andCompletetion:(void (^)(BOOL))completion;

- (void) pareseData:(NSDictionary *)dictionary;

-(NSURL *)getRandomCoverImageURL;

@end
