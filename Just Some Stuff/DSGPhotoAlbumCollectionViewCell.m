//
//  DSGPhotoAlbumCollectionViewCell.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGPhotoAlbumCollectionViewCell.h"

@interface DSGPhotoAlbumCollectionViewCell ()

@property (strong, nonatomic) UIImageView *bgImage;

@end

@implementation DSGPhotoAlbumCollectionViewCell

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.imageView.clipsToBounds = TRUE;
//        self.imageView.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
//        [[self contentView] addSubview:self.imageView];
//    }
//    return self;
//}

- (void)makeStacked
{
    float MAAX_ANGLE = arc4random() % 2 ? 5.0f : -5.0f;
    
    if (self.bgImage) {
        [self.bgImage removeFromSuperview];
    }
    
    self.bgImage = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    [self.bgImage setImage:[DSGUtilities placeholderImage]];
    self.bgImage.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    self.bgImage.transform = CGAffineTransformMakeRotation(M_PI_2 * (MAAX_ANGLE / 90.0f));
    [self.contentView insertSubview:self.bgImage belowSubview:self.imageView];
}

@end
