//
//  TGOViewController.m
//  Just Some Stuff
//
//  Created by MacBrian Pro on 30/03/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGHomeViewController.h"
#import "DSGHomeCollectionViewCell.h"
#import "DSGPhotoInfoViewController.h"

static NSString *title = @"CAMPAIGNS";

@implementation DSGHomeViewController
{
    //ADInterstitialAd *interstitial;
    BOOL requestingAd;
    UIView *holderView;
    NSTimer *adTimer;
    BOOL isDisplayingAd;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.homeModel = [DSGHomeModel sharedInstance];
    
    //Add the refresh control to the collectionView
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    requestingAd = NO;
    
    //Add progress wheel to view
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //Pull new data
    __weak DSGHomeViewController *weakSelf = self;
    [self refreshModelWithCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
    }];
}

# pragma mark - Navigation title managment
-(void)viewWillDisappear:(BOOL)animated
{
    //Set the title to an empty string to remove the title
    [self.navigationItem setTitle:[NSString string]];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Reset the Navigation title
    [self.navigationItem setTitle:title];
    
    //[holderView removeFromSuperview];
    
//    if (!adTimer)
//    {
//        adTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(showFullScreenAd:) userInfo:nil repeats:YES];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Model interaction
- (void)refreshModelWithCompletionBlock:(void (^)(void))complection
{
    __weak DSGHomeViewController *weakSelf = self;
    [self.homeModel freshPullWithCompletionBlock:^(BOOL complete) {
        
        if (complete)
        {
            //If pulled new data, reload collectionView
            [weakSelf.collectionView reloadData];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //Display alertView
                [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Unable to retirve photos, try again later" delegate:weakSelf cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                
                //Display 'no connection image' is model is empty
                if ([weakSelf.homeModel.photoData count] < 1)
                {
                    UIButton *refreshButton = [DSGUtilities noConnectionButtonWithTarget:weakSelf selector:@selector(retryConnection:)];
                    [weakSelf.view addSubview:refreshButton];
                }
            });
        }
        complection();
    }];
}

#pragma mark - Retry Connection
-(void)retryConnection:(id)sender
{
    //Remove the button from view
    [sender removeFromSuperview];
    
    //Add a progress wheel
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //Attempt to pull new data
    __weak DSGHomeViewController *weakSelf = self;
    [self refreshModelWithCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
    }];
}


#pragma mark - Refresh Control
-(void)refresh:(id)sender
{
    //Attempt to puul new and remove refresh control when complete
    [self refreshModelWithCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender endRefreshing];
        });
    }];
}

#pragma mark - Collection View Data Source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.homeModel.photoData count];
}

-(DSGHomeCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSGHomeCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[DSGHomeCollectionViewCell alloc] init];
    }
    
    //Get image data at index
    DSGBasicPhoto *currentPhoto = [self.homeModel.photoData objectAtIndex:indexPath.row];
    
    //Set the photo
    [cell.image setContentMode:UIViewContentModeScaleAspectFill];
    [cell.image setImageWithURL:[currentPhoto imageURL] placeholderImage:[DSGUtilities placeholderImage]];
    
    //Set the text label
    [cell.label setFont:[DSGUtilities fontAvenirNextWithSize:13]];
    [cell.label setTextColor:[DSGUtilities colourTheme]];
    [cell.label setText:[currentPhoto title]];
    
    return cell;
}

#pragma mark - Navigation
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    [self.homeModel setSelectedPhotoAtIndex:indexPath.row];
    
    [[segue.destinationViewController navigationItem] setTitle:self.homeModel.selectedPhoto.title];
    [((DSGPhotoInfoViewController*)segue.destinationViewController) setImageAlbum:self.homeModel];
}

#pragma mark - ADBannerViewDelegate

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Ad Error: %@", [error localizedDescription]);
    [self hideAd];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"Ad Banner did load ad.");
    
    if (!isDisplayingAd)
    {
        [self displayAd];
    }
    else
    {
        NSLog(@"Cannot Display New Ad");
    }
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Ad Banner action is about to begin.");
    
    return YES;
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"Ad Banner action did finish");
    [self hideAd];
}

#pragma mark - Display/Hide iAd
- (void) displayAd
{
    // Show the ad banner.
    [UIView animateWithDuration:1.0 animations:^{
        NSLog(@"Displaying Ad");
        self.iAd.alpha = 1.0;
    } completion:^(BOOL finished) {
        isDisplayingAd = YES;
    }];
}

- (void) hideAd
{
    // Hide the ad banner.
    [UIView animateWithDuration:1.0 animations:^{
        self.iAd.alpha = 0.0;
        NSLog(@"Hiding Ad");
    } completion:^(BOOL finished) {
        isDisplayingAd = NO;
    }];
}


#pragma mark - ADInterstitialAd
//-(void)showFullScreenAd:(NSTimer *)timer {
//    //Check if already requesting ad
//    if (requestingAd == NO)
//    {
//        interstitial = [[ADInterstitialAd alloc] init];
//        interstitial.delegate = self;
//        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
//        [self requestInterstitialAdPresentation];
//        NSLog(@"interstitialAdREQUEST");
//        requestingAd = YES;
//    }
//    else
//    {
//        NSLog(@"Already interstitialAdREQUEST");
//    }
//}
//
//-(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
//    interstitial = nil;
//    requestingAd = NO;
//    [holderView removeFromSuperview];
//    NSLog(@"interstitialAd didFailWithERROR");
//    NSLog(@"%@", error);
//}
//
//-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
//    NSLog(@"interstitialAdDidLOAD");
//    if (interstitialAd != nil && interstitial != nil && requestingAd == YES)
//    {
//        CGRect interstitialFrame = self.view.bounds;
//        interstitialFrame.origin = self.view.frame.origin;
//        holderView = [[UIView alloc] initWithFrame:interstitialFrame];
//        [self.view addSubview:holderView];
//        [interstitial presentInView:holderView];
//        NSLog(@"interstitialAdDidPRESENT");
//    }//end if
//}
//
//-(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
//    interstitial = nil;
//    requestingAd = NO;
//    [holderView removeFromSuperview];
//    NSLog(@"interstitialAdDidUNLOAD");
//}
//
//-(BOOL)interstitialAdActionShouldBegin:(ADInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave
//{
//    if (willLeave)
//    {
//        [adTimer invalidate];
//        adTimer = nil;
//    }
//    
//    NSLog(@"interstitialAdActionShouldBegin");
//    return willLeave;
//}
//
//-(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
//    interstitial = nil;
//    requestingAd = NO;
//    [holderView removeFromSuperview];
//    NSLog(@"interstitialAdDidFINISH");
//}

@end

