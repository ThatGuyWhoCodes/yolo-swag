//
//  DSGNestedCollection.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/10/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSGNestedCollection : NSObject

@property (strong, nonatomic, getter = identifier) NSString *collection_identifier;

@property (strong, nonatomic, getter = title) NSString *collection_title;

@property (strong, nonatomic, getter = collectionDescription) NSString *collection_description;

@property (strong, nonatomic, getter = collectionCollection) NSMutableArray *collection_collection;

@property (strong, nonatomic, getter = collectionCoverURL) NSURL *collection_cover_image;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(void)parseCoverWithDitction:(NSDictionary *)dict andCompletetion:(void (^)(BOOL))completion;

- (void) pareseData:(NSDictionary *)dictionary;

- (NSURL *)getRandomImageFromAnyCollection;


@end
