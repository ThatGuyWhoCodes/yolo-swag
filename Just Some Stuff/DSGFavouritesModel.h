//
//  DSGFavouritesModel.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 27/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGImageCollectionProtocol.h"

@interface DSGFavouritesModel : NSObject <DSGImageCollectionProtocol>

//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSArray *fetechedResults;

-(instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetched;

@end
