//
//  DSGTrendsTableViewCell.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 12/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"


@interface DSGTrendsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

-(void)setCellText:(NSString *)text;

-(void)setCellImage:(NSURL *)imageUrl;

@end
