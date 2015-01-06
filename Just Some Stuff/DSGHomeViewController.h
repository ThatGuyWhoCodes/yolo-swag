//
//  TGOViewController.h
//  Just Some Stuff
//
//  Created by MacBrian Pro on 30/03/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "DSGHomeModel.h"

@interface DSGHomeViewController : UIViewController <ADInterstitialAdDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

///The model for the view controller
@property (strong, nonatomic) DSGHomeModel *homeModel;

//@property (strong, nonatomic) IBOutlet ADBannerView *iAd;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
