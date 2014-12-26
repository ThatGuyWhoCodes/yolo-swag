//
//  DSGUtilities.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 12/06/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGUtilities.h"

@implementation DSGUtilities

+(UIFont *)fontTyploaWithSize:(NSUInteger)fontSize
{
  return [UIFont fontWithName:@"Typola" size:(float)fontSize];
}

+(UIFont *)fontAvenirNextWithSize:(NSUInteger)fontSize
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:(float)fontSize];
}

+(UIColor *)colourTheme
{
    return [UIColor colorWithRed:6.0/255.0 green:94.0/255.0 blue:79.0/255.0 alpha:1.0f];
}

+(UIImage *)placeholderImage
{
    //return [UIImage imageNamed:@"placement.png"];
    
    return [UIImage imageNamed:@"image_placeholder.jpg"];
}

+(UIButton *)noConnectionButtonWithTarget:(UIViewController *)target selector:(SEL)selector
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:target.view.frame];
    [refreshButton setImage:[UIImage imageNamed:@"No_Connection.png"] forState:UIControlStateNormal];
    [refreshButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return refreshButton;
}

+(UIButton *)linkButtonWithTitle:(NSString *)title
{
    UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [linkButton setTitle:title forState:UIControlStateNormal];
    [linkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [linkButton.titleLabel setFont:[DSGUtilities fontAvenirNextWithSize:13]];
    
    linkButton.titleLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    linkButton.titleLabel.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    linkButton.titleLabel.layer.shadowOpacity = 1.0f;
    linkButton.titleLabel.layer.shadowRadius = 1.0f;
    
    [linkButton sizeToFit];
    
    return linkButton;
}

+(UIImage *)imageForTitle:(NSString *)collectionTitle
{
    
    if ([[collectionTitle lowercaseString] rangeOfString:@"win"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"Winter.JPG"];
    }
    
    if ([[collectionTitle lowercaseString] rangeOfString:@"aut"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"Autunm.JPG"];
    }
    
    if ([[collectionTitle lowercaseString] rangeOfString:@"spr"].location != NSNotFound)
    {
        return [UIImage imageNamed:@"Spring.JPG"];
    }
    
    return [self placeholderImage];
}

+(CGRect) deviceSize
{
    return [[UIScreen mainScreen] bounds];
}
@end
