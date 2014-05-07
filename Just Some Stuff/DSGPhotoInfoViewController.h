//
//  DSGHomeInfoViewController.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGBasicPhoto.h"
#import "DSGFullDetailPhoto.h"

@interface DSGPhotoInfoViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) DSGFullDetailPhoto *fullPhoto;
@property (nonatomic, strong) DSGBasicPhoto *basicPhoto;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray *clickableNotes;

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)pinchRecongizer;
- (IBAction)handlePan:(UIPanGestureRecognizer *)panRecognizer;
- (IBAction)displayLinks:(id)sender;

@end
