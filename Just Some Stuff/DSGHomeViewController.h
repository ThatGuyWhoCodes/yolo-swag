//
//  TGOViewController.h
//  Just Some Stuff
//
//  Created by MacBrian Pro on 30/03/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGHomeModel.h"

@interface DSGHomeViewController : UICollectionViewController

///The model for the view controller
@property (strong, nonatomic) DSGHomeModel *homeModel;

@end
