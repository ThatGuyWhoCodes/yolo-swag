//
//  DSGHomeInfoViewController.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGImageCollectionProtocol.h"
#import "DSGSingleImageProtocol.h"
#import "DSGFullDetailPhoto.h"

@interface DSGPhotoInfoViewController : UIViewController <UIGestureRecognizerDelegate, DSGSingleImageProtocol, UIScrollViewDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) DSGFullDetailPhoto *fullPhoto;

@property (nonatomic, strong) id <DSGImageCollectionProtocol> imageAlbum;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *favouriteButton;

@property (nonatomic, strong) NSMutableArray *clickableNotes;

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)pinchRecongizer;
- (IBAction)handlePan:(UIPanGestureRecognizer *)panRecognizer;
- (IBAction)displayLinks:(id)sender;

- (IBAction)favouriteButtonPressed:(id)sender;

- (IBAction)handleDoubleTap:(id)sender;
@end
