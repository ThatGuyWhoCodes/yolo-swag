//
//  DSGConfig.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 07/07/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSGConfig : NSObject

/**
 * The User ID to pull the pictures from
 *
 * @return The User ID
 */
+(NSString *) userID;

/**
 * The API key
 *
 * @return API Key
 */
+(NSString *) APIKey;

/**
 * The Shared Secret
 *
 * @return Shared Secret
 */
+(NSString *) sharedSecret;

@end
