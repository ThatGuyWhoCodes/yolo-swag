//
//  DSGStackedLayout.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 10/10/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSGStackedLayout : UICollectionViewLayout

@property (nonatomic, readwrite) NSInteger stackCount;
@property (nonatomic, readwrite) CGSize itemSize;
@property (nonatomic,assign) CGPoint targetCenter;

@end
