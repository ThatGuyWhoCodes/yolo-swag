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
        // Initialization code
        [[self titleLabel] setFont:[UIFont fontWithName:@"Typola" size:4.0f]];
        [[self titleLabel] setBackgroundColor:[UIColor redColor]];
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

@end
