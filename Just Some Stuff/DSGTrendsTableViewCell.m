//
//  DSGTrendsTableViewCell.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 12/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGTrendsTableViewCell.h"

@implementation DSGTrendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellImage:(NSURL *)imageUrl
{
    [self.backgroundImage setImageWithURL:imageUrl placeholderImage:[DSGUtilities placeholderImage]];
}

-(void)setCellText:(NSString *)text
{
    [self.titleLabel setFont:[DSGUtilities fontTyploaWithSize:35]];
    
    self.titleLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.titleLabel.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.titleLabel.layer.shadowOpacity = 1.0f;
    self.titleLabel.layer.shadowRadius = 1.0f;
    
    [self.titleLabel setText:text];
}
@end
