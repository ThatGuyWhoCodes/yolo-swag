//
//  DSGHomeInfoViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGPhotoInfoViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "DSGHomeModel.h"

@interface DSGPhotoInfoViewController ()
{
    CGFloat lastScale;
}

@end

@implementation DSGPhotoInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lastScale = 1.0;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.imageView setImageWithURL:[self.basicPhoto imageURL] placeholderImage:[UIImage imageNamed:@"IMG_0038.JPG"]]; //TODO: Replace PlaceHolder
    
    FKFlickrPhotosGetInfo *getPhotoInfo = [[FKFlickrPhotosGetInfo alloc] init];
    [getPhotoInfo setPhoto_id:self.basicPhoto.identification];
    
    __weak DSGPhotoInfoViewController* weakSelf = self;
    
    [[FlickrKit sharedFlickrKit] call:getPhotoInfo completion:^(NSDictionary *response, NSError *error) {
        if ([[response objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            weakSelf.fullPhoto = [[DSGFullDetailPhoto alloc] initWithDictionary:response];
            [weakSelf getOriginalImage];
            [weakSelf insertNotes];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getOriginalImage
{
    __weak DSGPhotoInfoViewController *weakSelf = self;
    
    [weakSelf.fullPhoto fetchOriginalImageWithCompletetionBlock:^(BOOL complete) {
        if (complete)
        {
            [weakSelf.imageView setImageWithURL:weakSelf.fullPhoto.orginalImage placeholderImage:weakSelf.imageView.image];
        }
    }];
}

-(void)insertNotes
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        
        if ([self.fullPhoto hasNotes])
        {
            /*
            [self.infoLabel setText:[[self.fullPhoto getNotes] firstObject]];
            [self.infoLabel setTag:1];
            [self.infoLabel setUserInteractionEnabled:YES];
            [self.infoLabel addGestureRecognizer:tapGesture];
            */
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (IBAction)displayLinks:(id)sender
{
    if ([self.clickableNotes count] > 0)
    {
        NSLog(@"Has notes, display them");
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"No items" message:@"There are no items in this photo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Gesture Recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleTap:(id)sender
{
    NSLog(@"Sender: %@", sender);
}


- (IBAction)handlePinch:(UIPinchGestureRecognizer *)pinchRecongizer
{
    static CGPoint center;
    static CGSize initialSize;
    if (pinchRecongizer.state == UIGestureRecognizerStateBegan)
    {
        center = pinchRecongizer.view.center;
        initialSize = pinchRecongizer.view.frame.size;
    }
    
    CGFloat scale = pinchRecongizer.scale;
    //lastScale += (1 - scale);
    if (scale > 0.5f && scale < 2.5f)
    {
        pinchRecongizer.view.frame = CGRectMake(0, 0, initialSize.width * scale, initialSize.height * scale);
        pinchRecongizer.view.center = center;
    }

    
    if (pinchRecongizer.state == UIGestureRecognizerStateEnded)
    {
        if (!CGRectContainsRect(pinchRecongizer.view.frame, self.view.bounds) || (CGRectGetHeight(pinchRecongizer.view.frame) >= (CGRectGetHeight(self.view.frame) * 5.0f)))
        {
            [UIView animateWithDuration:0.6f animations:^{
                pinchRecongizer.view.frame = self.view.frame;
            }];
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)panRecognizer
{
    static CGPoint initialCenter;
    if (panRecognizer.state == UIGestureRecognizerStateBegan)
    {
        initialCenter = panRecognizer.view.center;
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panRecognizer translationInView:panRecognizer.view];
        UIView *newView = [[UIView alloc] initWithFrame:panRecognizer.view.frame];
        newView.center = CGPointMake(initialCenter.x + translation.x, initialCenter.y + translation.y);
        
        if (CGRectContainsRect(newView.frame, self.view.bounds))
        {
            panRecognizer.view.center = CGPointMake(initialCenter.x + translation.x, initialCenter.y + translation.y);
        }
        else
        {
            initialCenter = panRecognizer.view.center;
            [panRecognizer setTranslation:CGPointZero inView:panRecognizer.view];
        }
    }
}
@end
