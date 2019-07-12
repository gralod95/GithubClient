//
//  UserInfo.m
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "UserInfo.h"

@interface UserInfo ()

@property (atomic, strong, nonnull,readwrite) NSString *login;
@property (atomic, strong, nonnull,readwrite) NSString *password;

@end

@implementation UserInfo

- (instancetype)initWithLogin:(NSString *)aLogin
                  andPassword:(NSString *)aPassword
{
    self = [super init];
    if (self)
    {
        self.login = aLogin;
        self.password = aPassword;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"login: %@ \n password: %@ \n userName: %@ \n avatarURL: %@ \n repositoryCount: %@ \n repositoriesURL: %@ \n ",
            self.login,
            self.password,
            self.userName,
            self.avatarURL,
            self.repositoryCount,
            self.repositoriesURL
            ];
}
@end
