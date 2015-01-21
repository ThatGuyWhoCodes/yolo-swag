//
//  DSGCollectionTableViewCell.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 19/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGCollectionTableViewCell.h"

@implementation DSGCollectionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
