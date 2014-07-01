//
//  DSGUtilities.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 12/06/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSGUtilities : NSObject

+(UIFont *)fontTyploaWithSize:(NSUInteger)fontSize;

+(UIFont *)fontAvenirNextWithSize:(NSUInteger)fontSize;

+(UIColor *)colourTheme;

+(UIImage *)placeholderImage;

+(UIButton *)noConnectionButtonWithTarget:(UIViewController *)target selector:(SEL)selector;

+(UIButton *)linkButtonWithTitle:(NSString *)title;
@end
