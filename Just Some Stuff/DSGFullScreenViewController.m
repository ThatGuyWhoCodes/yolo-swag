//
//  DSGFullScreenViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 20/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGFullScreenViewController.h"

@interface DSGFullScreenViewController ()
{
    NSUInteger pageCount;
}
@end

@implementation DSGFullScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageCount = [self.currentModel numberOfPhotos];
    
    [self.pageControl setNumberOfPages:pageCount];
    //NSLog(@"Images: %d", pageCount);
    
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i)
    {
        [self.pageViews addObject:[NSNull null]];
    }
    
    [self.scrollView setFrame:[UIScreen mainScreen].bounds];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 4
    CGSize pagesScrollViewSize = self.scrollView.bounds.size;
    
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * pageCount, pagesScrollViewSize.height);
    
    [self.scrollView setContentOffset:CGPointMake([self.currentModel indexOfSlectedPhoto] * self.view.bounds.size.width, 0)];
    // 5
    [self loadVisiblePages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView
- (void)loadPage:(NSInteger)page
{
    if (page < 0 || page >= pageCount)
    {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // 1
    UIView *pageView = [self.pageViews objectAtIndex:page];
    
    if ((NSNull*)pageView == [NSNull null])
    {
        // 2
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        //DLog(@"%@", NSStringFromCGRect(frame));
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[DSGUtilities placeholderImage]];
        [newPageView setImageWithURL:[self.currentModel photoURLAtIndex:page] placeholderImage:[DSGUtilities placeholderImage]];
        [newPageView setBackgroundColor:[UIColor clearColor]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
    
    [self.pageControl setCurrentPage:page];
}

- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= pageCount)
    {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null])
    {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadVisiblePages
{
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++)
    {
        [self purgePage:i];
    }
    
	// Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++)
    {
        [self loadPage:i];
    }
    
	// Purge anything after the last page
    for (NSInteger i=lastPage+1; i<pageCount; i++)
    {
        [self purgePage:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

#pragma mark - Navigation
- (IBAction)handleDoubleTap:(id)sender
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    [self.currentModel setSelectedPhotoAtIndex:(NSInteger)page];
    [self.parentVC didDismissFullScreenView];
    
    [self dismissViewControllerAnimated:YES completion:^{
        DLog(@"Something");
    }];
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

@end
