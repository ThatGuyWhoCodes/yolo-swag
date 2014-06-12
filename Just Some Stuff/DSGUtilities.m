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

+(UIColor *)colourTheme
{
    return [UIColor colorWithRed:6.0/255.0 green:94.0/255.0 blue:79.0/255.0 alpha:1.0f];
}

+(UIImage *)placeholderImage
{
    return [UIImage imageNamed:@"IMG_0038.JPG"];
}
@end
