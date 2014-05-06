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
    
    [self.image setImageWithURL:[self.photo imageURL] placeholderImage:[UIImage imageNamed:@"IMG_0038.JPG"]]; //TODO: Replace PlaceHolder
    [self.infoLabel setText:[self.photo title]];
    
    FKFlickrPhotosGetInfo *getPhotoInfo = [[FKFlickrPhotosGetInfo alloc] init];
    [getPhotoInfo setPhoto_id:self.photo.identification];
    
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
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    
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
            [weakSelf.image setImageWithURL:weakSelf.fullPhoto.orginalImage /*placeholderImage:weakSelf.image.image*/];
        }
    }];
}

-(void)insertNotes
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.fullPhoto hasNotes])
        {
            [self.infoLabel setText:[[self.fullPhoto getNotes] firstObject]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)pinchRecongizer
{
    /*
    if([pinchRecongizer state] == UIGestureRecognizerStateBegan)
    {
        // Reset the last scale, necessary if there are multiple objects with different scales
        lastScale = [pinchRecongizer scale];
    }
    
    if ([pinchRecongizer state] == UIGestureRecognizerStateBegan ||
        [pinchRecongizer state] == UIGestureRecognizerStateChanged)
    {
        
        CGFloat currentScale = [[[pinchRecongizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = 2.0;
        const CGFloat kMinScale = 1.0;
        
        CGFloat newScale = 1 -  (lastScale - [pinchRecongizer scale]); // new scale is in the range (0-1)
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[self image] transform], newScale, newScale);
        [self image].transform = transform;
        
        lastScale = [pinchRecongizer scale];  // Store the previous scale factor for the next pinch gesture call
    }
    //    NSLog(@"Pinch scale: %f", recognizer.scale);
    
    if (pinchRecongizer.scale >1.0f && pinchRecongizer.scale < 2.5f)
    {
        CGAffineTransform transform = CGAffineTransformMakeScale(pinchRecongizer.scale, pinchRecongizer.scale);
        self.image.transform = transform;
    }

    if (pinchRecongizer.state == UIGestureRecognizerStateEnded)
    {
        lastScale = pinchRecongizer.scale;
    }
    else if (pinchRecongizer.state == UIGestureRecognizerStateBegan && lastScale != 0.0f)
    {
        pinchRecongizer.scale = lastScale;
    }
    
    if (pinchRecongizer.scale != NAN && (pinchRecongizer.scale >= 1.0f && pinchRecongizer.scale <= 3.0f))
    {
        //self.image.transform = CGAffineTransformMakeScale(pinchRecongizer.scale, pinchRecongizer.scale);
        self.image.transform = CGAffineTransformScale(self.image.transform, pinchRecongizer.scale, pinchRecongizer.scale);
        pinchRecongizer.scale = 1.0;
    }

    CGFloat scale = pinchRecongizer.scale;
    
        self.image.transform = CGAffineTransformScale(self.image.transform, scale, scale);
    
        pinchRecongizer.scale = 1.0;
     */
    
    static CGPoint center;
    static CGSize initialSize;
    if (pinchRecongizer.state == UIGestureRecognizerStateBegan)
    {
        center = pinchRecongizer.view.center;
        initialSize = pinchRecongizer.view.frame.size;
        lastScale = pinchRecongizer.scale;
    }
    
    CGFloat scale = pinchRecongizer.scale;
    //lastScale += (1 - scale);
    if (scale > 0.75f && scale < 3.5f)
    {
        pinchRecongizer.view.frame = CGRectMake(0,
                                                0,
                                                initialSize.width * scale,
                                                initialSize.height * scale);
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
    /*
    CGRect xRectRef = panRecognizer.view.superview.frame;
    
    CGPoint translation = [panRecognizer translationInView:panRecognizer.view];
    
    CGPoint xyNew = CGPointMake(panRecognizer.view.frame.origin.x + translation.x, panRecognizer.view.frame.origin.y + translation.y);
    
    
    if (panRecognizer.state == UIGestureRecognizerStateChanged )
    {
        if ( (xyNew.y <= xRectRef.origin.y) &&
            
            (xyNew.y + panRecognizer.view.frame.size.height >= xRectRef.origin.y + xRectRef.size.height) &&
            
            (xyNew.x <= xRectRef.origin.x ) &&
            
            (xyNew.x + panRecognizer.view.frame.size.width >= xRectRef.size.width+xRectRef.origin.x)){
            
            panRecognizer.view.center = CGPointMake(panRecognizer.view.center.x + translation.x,
                                                 
                                                 panRecognizer.view.center.y + translation.y);
            
            [panRecognizer setTranslation:CGPointMake(0, 0) inView:panRecognizer.view];
            
        }
        
    }

    CGPoint translation = [panRecognizer translationInView:self.view];
    self.image.center = CGPointMake(panRecognizer.view.center.x + translation.x,
                                         panRecognizer.view.center.y + translation.y);
    [panRecognizer setTranslation:CGPointZero inView:self.view];

    CGPoint translation = [panRecognizer translationInView:self.view];
    CGPoint imageViewPosition = self.image.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    self.image.center = imageViewPosition;
    [panRecognizer setTranslation:CGPointZero inView:self.view];
    */
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
            //NSLog(@"YES");
        }
        else
        {
            initialCenter = panRecognizer.view.center;
            [panRecognizer setTranslation:CGPointZero inView:panRecognizer.view];
            //NSLog(@"NO");
        }
    }
}
@end
