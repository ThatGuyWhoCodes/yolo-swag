//
//  DSGHomeInfoViewController.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSGHomeInfoViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)pinchRecongizer;
- (IBAction)handlePan:(UIPanGestureRecognizer *)panRecognizer;
@end
