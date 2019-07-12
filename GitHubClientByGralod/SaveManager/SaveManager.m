//
//  SaveManager.m
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "SaveManager.h"

#define LOGIN_NAME_PREFIX @"GitHubClientByGralod"
#define LOGIN_NAME_BODY @"AuthorizationLogin"
#define PASSWORD_NAME_BODY @"AuthorizationPassword"

@protocol authorizationInfoObject <NSObject>

@property NSString *login;
@property NSString *password;

@end

@implementation SaveManager

-(void)saveAuthorizationInfo: (id<authorizationInfoObject>) authorizationInfo
{
    if ([authorizationInfo respondsToSelector:@selector(login)]
        &&[authorizationInfo respondsToSelector:@selector(password)])
    {
        NSString *loginName = [NSString stringWithFormat:@"%@_%@",LOGIN_NAME_PREFIX,LOGIN_NAME_BODY];
        [self saveStringData:[authorizationInfo login] withName:loginName];
        NSString *passwordName = [NSString stringWithFormat:@"%@_%@",LOGIN_NAME_PREFIX,PASSWORD_NAME_BODY];
        [self saveStringData:[authorizationInfo password] withName:passwordName];
    }
    else
    {
        NSLog(@"error in saving authorization info data, authorizationInfo: %@", authorizationInfo);
    }
}
-(NSDictionary *)loadAuthorizationInfo
{
    NSString *loginName = [NSString stringWithFormat:@"%@_%@",LOGIN_NAME_PREFIX,LOGIN_NAME_BODY];
    NSString *loginDate = [self loadDataWithName:loginName];
    NSString *passwordName = [NSString stringWithFormat:@"%@_%@",LOGIN_NAME_PREFIX,PASSWORD_NAME_BODY];
    NSString *passwordDate = [self loadDataWithName:passwordName];
    NSDictionary *returnDictionary;
    if(loginDate == nil || passwordDate == nil)
    {
        returnDictionary = @{ @"loadingError": @"no_saving_data"};
    }
    else
    {
        returnDictionary = @{
                             @"login": loginDate,
                             @"password": passwordDate
                             };
    }
    return returnDictionary;
}

- (void)deleteAuthorizationInfo
{
    NSString *loginName = [NSString stringWithFormat:@"%@_%@",LOGIN_NAME_PREFIX,LOGIN_NAME_BODY];
    NSString *passwordName = [NSString stringWithFormat:@"%@_%@",LOGIN_NAME_PREFIX,PASSWORD_NAME_BODY];
    
    [self deleteDataWithName:loginName];
    [self deleteDataWithName:passwordName];
}

-(id)loadDataWithName:(NSString *)aName
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    id returnObject = [standardUserDefaults objectForKey:aName];
    return returnObject;
}

-(void)saveStringData:(NSString *)aStringData
             withName:(NSString *)aName
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults  setObject:aStringData forKey:aName];
    [standardUserDefaults synchronize];
}

-(void)deleteDataWithName:(NSString *)aName
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults  removeObjectForKey:aName];
    [standardUserDefaults synchronize];
}
@end
