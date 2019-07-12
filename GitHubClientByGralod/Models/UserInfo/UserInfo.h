//
//  UserInfo.h
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject
@property (atomic, strong, nonnull,readonly) NSString *login;
@property (atomic, strong, nonnull,readonly) NSString *password;
@property (atomic, strong, nullable,readwrite) NSString *userName;
@property (atomic, strong, nullable,readwrite) NSString *avatarURL;
@property (atomic, strong, nullable,readwrite) NSNumber *repositoryCount;
@property (atomic, strong, nullable,readwrite) NSString *repositoriesURL;

- (instancetype)initWithLogin:(NSString *)aLogin
                  andPassword:(NSString *)aPassword;

@end

NS_ASSUME_NONNULL_END
