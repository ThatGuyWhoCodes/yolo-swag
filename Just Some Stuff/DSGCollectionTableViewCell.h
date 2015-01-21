//
//  DSGCollectionTableViewCell.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 19/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSGCollectionTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *cellBackGroundImage;

-(void)setCellText:(NSString *)text;

@end
