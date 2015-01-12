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
    UIImage *displayImage;
}

@end

@implementation DSGPhotoInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //grab the Core Data MOC
    self.managedObjectContext = ((DSGAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    lastScale = 1.0;
    
    //Load the selected photo from the model
    [self loadSelectedPhotoFromModel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set the favourites button is selected or not
    [self.favouriteButton setSelected:[self checkIfFavourite]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadSelectedPhotoFromModel
{
    //Add progress wheel to view
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak DSGPhotoInfoViewController* weakSelf = self;
    
    //Set the image along with a placeholder
    [self.imageView setImageWithURL:[[self.imageAlbum getSelectedPhoto] imageURL] placeholderImage:[DSGUtilities placeholderImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        //Set up GetPhotoInfo Object
        FKFlickrPhotosGetInfo *getPhotoInfo = [[FKFlickrPhotosGetInfo alloc] init];
        [getPhotoInfo setPhoto_id:[[weakSelf.imageAlbum getSelectedPhoto] identification]];
        
        //Get full info about the current photo
        [[FlickrKit sharedFlickrKit] call:getPhotoInfo completion:^(NSDictionary *response, NSError *error) {
            if ([[response objectForKey:@"stat"] isEqualToString:@"ok"])
            {
                //Set the full photo
                weakSelf.fullPhoto = [[DSGFullDetailPhoto alloc] initWithDictionary:response];
                
                //Get the original image
                [weakSelf getOriginalImage];
                
                //Insert any notes found
                [weakSelf insertNotes];
            }
            else
            {
                //Remove progress whell
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                });
            }
        }];
    }];
}

- (BOOL)checkIfFavourite
{
    //Generate a fecthRequest on CD for the selected photo
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DSGPhoto" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *identificationSort = [[NSSortDescriptor alloc] initWithKey:@"identification" ascending:YES];
    
    //Set the sortDescriptor and entity
    [fetchRequest setSortDescriptors:@[identificationSort]];
    [fetchRequest setEntity:entity];
    
    //Execute the fecthRequest
    NSError *requestError = nil;
    NSArray *favouritePhotos = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    BOOL isFavourite = NO;
    
    //Loop through all photos returned
    for (DSGPhoto *photo in favouritePhotos)
    {
        //Set flag if photo IDs match
        if ([photo.identification isEqualToString:[[self.imageAlbum getSelectedPhoto] identification]])
        {
            NSLog(@"Found You");
            isFavourite = YES;
        }
    }
    
    //Return flag
    return isFavourite;
}

- (void)getOriginalImage
{
    __weak DSGPhotoInfoViewController* weakSelf = self;
    [self.fullPhoto fetchOriginalImageWithCompletetionBlock:^(BOOL complete) {
        if (complete)
        {
            [weakSelf.imageView setImageWithURL:weakSelf.fullPhoto.orginalImage placeholderImage:weakSelf.imageView.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                //Setup the interactions
                [weakSelf setUpInterations];
            }];
        }
    }];
}

- (void)insertNotes
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.fullPhoto hasNotes])
        {
            self.clickableNotes = [NSMutableArray array];
            
            for (NSString *note in [self.fullPhoto getNotes])
            {
                NSArray *segmentedNotes = [note componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";,"]];
                
                NSMutableString *mutNoteInfo = [NSMutableString string];
                
                for (NSString *stringChunk in segmentedNotes)
                {
                    if (![stringChunk isEqualToString:[segmentedNotes lastObject]])
                    {
                        [mutNoteInfo appendString:[stringChunk uppercaseString]];
                    }
                }
                
                UIButton *linkButton = [DSGUtilities linkButtonWithTitle:mutNoteInfo];
                
                if ([self.clickableNotes count] > 0)
                {
                    UIButton *lastButton = [self.clickableNotes lastObject];
                    CGFloat alignX = CGRectGetWidth(self.view.frame) - (CGRectGetWidth(linkButton.frame) + 20);
                    [linkButton setFrame:CGRectMake(alignX, CGRectGetMidY(lastButton.frame) + 5.0f, CGRectGetWidth(linkButton.frame), CGRectGetHeight(linkButton.frame))];
                }
                else
                {
                    CGFloat alignX = CGRectGetWidth(self.view.frame) - (CGRectGetWidth(linkButton.frame) + 20);
                    [linkButton setFrame:CGRectMake(alignX, 120, CGRectGetWidth(linkButton.frame), CGRectGetHeight(linkButton.frame))];
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
        [((DSGFullScreenViewController*)segue.destinationViewController) setParentVC:self];
    }
}

#pragma mark - Gesture Recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleTap:(id)sender
{
    //Get the Index of the clicked button
    NSUInteger index = [self.clickableNotes indexOfObject:sender];
    
    //Get the array of notes
    NSArray *seperatedNoteInfoList = [[[self.fullPhoto getNotes] objectAtIndex:index] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";,"]];
    
    //Create the URL string and remove any whitespace
    NSString *urlString = [NSString stringWithFormat:@"http://%@", [[seperatedNoteInfoList lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
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

#pragma mark - Core Data Interaction
- (IBAction)favouriteButtonPressed:(id)sender
{
    BOOL actionIsSuccessful = NO;
    //Add or remove photo from favourotes depending if it is selected
    if ([sender isSelected])
    {
        //Show alert if unable to add photo to favourites
        actionIsSuccessful = [self removePhotoFromFavourites:[self.imageAlbum getSelectedPhoto]];
        if (!actionIsSuccessful)
        {
            [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Unable to remove photo to favourites" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }
    else
    {
        //Show alert if unable to add photo to favourites
        actionIsSuccessful = [self addPhotoToFavourites:[self.imageAlbum getSelectedPhoto]];
        if (!actionIsSuccessful)
        {
            [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Unable to add photo to favourites" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }
    
    //Reverse isSelected property
    if (actionIsSuccessful)
    {
        [sender setSelected:![sender isSelected]];
    }
}

- (BOOL)addPhotoToFavourites:(DSGBasicPhoto *)basicPhoto
{
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
    return NO;
}

- (BOOL)removePhotoFromFavourites:(DSGBasicPhoto *)basicPhoto
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DSGPhoto" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *requestError = nil;
    
    NSArray *photos = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    //Proceed if photos exist
    if ([photos count] > 0)
    {
        //Loop through allthe photos
        for (DSGPhoto *currentPhoto in photos)
        {
            //Check if the IDs match
            if ([currentPhoto.identification isEqualToString:basicPhoto.identification])
            {
                //Delete
                [self.managedObjectContext deleteObject:currentPhoto];
                
                //Atempt to save context
                NSError *savingError = nil;
                if ([self.managedObjectContext save:&savingError])
                {
                    NSLog(@"Successfully deleted photo");
                    return YES;
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
    
    return NO;
}

#pragma mark - Navigation
-(void)handleDoubleTap:(id)sender
{
    if ([self.imageAlbum indexOfSlectedPhoto] <= [self.imageAlbum numberOfPhotos])
    {
        //[self performSegueWithIdentifier:@"toFullScreen" sender:self];
    }
}

-(void)didDismissFullScreenView
{
    if ([self.view.subviews containsObject:[self.clickableNotes firstObject]])
    {
        for (UIButton *clickableNote in self.clickableNotes)
        {
            [clickableNote removeFromSuperview];
        }
    }
    
    [self.navigationItem setTitle:[[[self.imageAlbum getSelectedPhoto] title] uppercaseString]];

    [self loadSelectedPhotoFromModel];
}

-(void)centerScrollViewContents
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentFrame = self.imageView.frame;
    
    if (contentFrame.size.width < boundsSize.width)
    {
        contentFrame.origin.x = (boundsSize.width - contentFrame.size.width) / 2.0f;
    }
    else
    {
        contentFrame.origin.x = 0.0f;
    }
    
    if (contentFrame.size.height < boundsSize.height)
    {
        contentFrame.origin.y = (boundsSize.height - contentFrame.size.height) / 2.0f;
    }
    else
    {
        contentFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentFrame;
}

#pragma mark - New Interaction

-(void)setUpInterations
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scrollView.contentSize = self.imageView.image.size;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [self.scrollView addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
        twoFingerTap.numberOfTapsRequired = 1;
        twoFingerTap.numberOfTouchesRequired = 2;
        [self.scrollView addGestureRecognizer:twoFingerTap];
        
        CGRect scrolliewFrame = self.scrollView.frame;
        CGFloat scaleWidth = self.scrollView.contentSize.width / scrolliewFrame.size.width;
        CGFloat scaleHeight = self.scrollView.contentSize.height / scrolliewFrame.size.height;
        
        CGFloat maxScale = MIN(scaleWidth, scaleHeight);
        self.scrollView.minimumZoomScale = 1.0f;
        
        self.scrollView.maximumZoomScale = maxScale;
        self.scrollView.zoomScale = 1.0f;
        
        [self centerScrollViewContents];
    });
}

#pragma mark - Tap Guestures

-(void)scrollViewDoubleTap:(UITapGestureRecognizer *)recogniser
{
    CGPoint pointInView = [recogniser locationInView:self.imageView];
    
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoom = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoom animated:YES];
}

-(void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recogniser
{
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}
@end
