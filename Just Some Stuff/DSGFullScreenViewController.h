//
//  DSGFullScreenViewController.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 20/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGImageCollectionProtocol.h"

@interface DSGFullScreenViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) id <DSGImageCollectionProtocol> currentModel;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *pageViews;

- (IBAction)handleDoubleTap:(id)sender;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end
