//
//  DSGHomeInfoViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGPhotoInfoViewController.h"
#import "DSGFullScreenViewController.h"
#import "DSGAppDelegate.h"
#import "DSGPhoto.h"

@interface DSGPhotoInfoViewController ()
{
    CGFloat lastScale;
}

@end

@implementation DSGPhotoInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.managedObjectContext = ((DSGAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
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
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            });
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.favouriteButton setSelected:[self checkIfFavourite]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkIfFavourite
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DSGPhoto" inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor *identificationSort = [[NSSortDescriptor alloc] initWithKey:@"identification" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[identificationSort]];
    
    [fetchRequest setEntity:entity];
    
    NSError *requestError = nil;
    
    NSArray *photoIdentification = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    BOOL isFavourite = NO;
    
    for (DSGPhoto *photo in photoIdentification)
    {
        if ([photo.identification isEqualToString:self.basicPhoto.identification])
        {
            NSLog(@"Found You");
            isFavourite = YES;
        }
    }
    
    return isFavourite;
}

- (void)getOriginalImage
{
    [self.fullPhoto fetchOriginalImageWithCompletetionBlock:^(BOOL complete) {
        if (complete)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageView setImageWithURL:self.fullPhoto.orginalImage placeholderImage:self.imageView.image];
            });
        }
    }];
}

- (void)insertNotes
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.fullPhoto hasNotes])
        {
            static CGFloat spacing = 5.0f;
            
            self.clickableNotes = [NSMutableArray array];
            
            for (NSString *note in [self.fullPhoto getNotes])
            {
                NSArray *segmentedNotes = [note componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";,"]];
                
                NSMutableString *mutNoteInfo = [NSMutableString string];
                
                for (NSString *stringChunck in segmentedNotes)
                {
                    if (![stringChunck isEqualToString:[segmentedNotes lastObject]])
                    {
                        [mutNoteInfo appendString:[stringChunck uppercaseString]];
                    }
                }
                
                UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [linkButton setTitle:mutNoteInfo forState:UIControlStateNormal];
                [linkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                //[linkButton.titleLabel setFont:[UIFont fontWithName:@"Typola" size:16.0]];
                
                linkButton.titleLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
                linkButton.titleLabel.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
                linkButton.titleLabel.layer.shadowOpacity = 1.0f;
                linkButton.titleLabel.layer.shadowRadius = 1.0f;
                [linkButton sizeToFit];
                
                if ([self.clickableNotes count] > 0)
                {
                    UIButton *lastButton = [self.clickableNotes lastObject];
                    [linkButton setFrame:CGRectMake(CGRectGetMinX(lastButton.frame), CGRectGetMaxY(lastButton.frame) + spacing, CGRectGetWidth(linkButton.frame), CGRectGetHeight(linkButton.frame))];
                }
                else
                {
                    [linkButton setFrame:CGRectMake(20, 80, CGRectGetWidth(linkButton.frame), CGRectGetHeight(linkButton.frame))];
                }
                
                [linkButton addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:linkButton];
                [self.clickableNotes addObject:linkButton];
            }

        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (IBAction)displayLinks:(id)sender
{
    if ([self.clickableNotes count] > 0)
    {
        if ([self.view.subviews containsObject:[self.clickableNotes firstObject]])
        {
            for (UIButton *clickableNote in self.clickableNotes)
            {
                [clickableNote removeFromSuperview];
            }
        }
        else
        {
            for (UIButton *clickableNote in self.clickableNotes)
            {
                [self.view addSubview:clickableNote];
            }
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"No items" message:@"There are no items in this photo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toFullScreen"])
    {
        [((DSGFullScreenViewController*)segue.destinationViewController) setCurrentModel:self.imageAlbum];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Gesture Recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleTap:(id)sender
{
    //Get the Index of th clicked button
    NSUInteger index = [self.clickableNotes indexOfObject:sender];
    
    //Get the array of notes
    NSArray *arry = [[[self.fullPhoto getNotes] objectAtIndex:index] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";,"]];
    
    //Create the URL string
    NSString *urlString = [NSString stringWithFormat:@"http://www.%@", [[arry lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    //Go baby go!
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString]];
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)pinchRecongizer
{
    static CGFloat zoomLevel = 4.0f;
    
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
        static float animationTime = 0.2f;
        
        if (!CGRectContainsRect(pinchRecongizer.view.frame, self.view.bounds))
        {
            [UIView animateWithDuration:animationTime animations:^{
                pinchRecongizer.view.frame = self.view.frame;
            }];
        }
        if ((CGRectGetHeight(pinchRecongizer.view.frame) > (CGRectGetHeight(self.view.frame) * zoomLevel)))
        {
            [UIView animateWithDuration:animationTime animations:^{
                pinchRecongizer.view.frame = CGRectMake(0, 0, (CGRectGetWidth(self.view.frame) * zoomLevel), (CGRectGetHeight(self.view.frame) * zoomLevel));
            }];
            pinchRecongizer.view.center = center;
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

#pragma mark - Core Data
- (IBAction)favouriteButtonPressed:(id)sender
{
    BOOL favouriteButtonIsSelected = ((UIButton *)sender).isSelected;
    
    if (favouriteButtonIsSelected)
    {
        [self removePhotoFromFavourites:self.basicPhoto];
    }
    else
    {
        [self createNewPhotoWithBasicPhoto:self.basicPhoto];
    }
    
    [sender setSelected:!favouriteButtonIsSelected];
}

- (BOOL)createNewPhotoWithBasicPhoto:(DSGBasicPhoto *)basicPhoto
{
    BOOL result = NO;
    
    DSGPhoto* photo = [NSEntityDescription insertNewObjectForEntityForName:@"DSGPhoto" inManagedObjectContext:self.managedObjectContext];
    
    if (!photo)
    {
        NSLog(@"Failed to create new photo");
        return NO;
    }
    
    [photo setTitle:basicPhoto.title];
    [photo setIdentification:basicPhoto.identification];
    [photo setImageURLString:basicPhoto.imageURL.absoluteString];
    
    NSError *savingError = nil;
    
    if ([self.managedObjectContext save:&savingError])
    {
        NSLog(@"Saved to favourites");
        return YES;
    }
    else
    {
        NSLog(@"Failed to save the photo. Error: %@", savingError);
    }
    return result;
}

- (void)removePhotoFromFavourites:(DSGBasicPhoto *)basicPhoto
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DSGPhoto" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *requestError = nil;
    
    NSArray *photos = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    if ([photos count] > 0)
    {
        for (DSGPhoto *currentPhoto in photos)
        {
            if ([currentPhoto.identification isEqualToString:basicPhoto.identification])
            {
                [self.managedObjectContext deleteObject:currentPhoto];
                
                NSError *savingError = nil;
                if ([self.managedObjectContext save:&savingError])
                {
                    NSLog(@"Successfully deleted photo");
                }
                else
                {
                    NSLog(@"Failed to save the context");
                }
            }
        }
        
    }
    else
    {
        NSLog(@"Could not find the photo in the context");
    }
}

#pragma mark - Navigation
-(void)handleDoubleTap:(id)sender
{
    if ([self.imageAlbum indexOfSlectedPhoto] <= [self.imageAlbum numberOfPhotos])
    {
        [self performSegueWithIdentifier:@"toFullScreen" sender:self];
    }
}
@end
