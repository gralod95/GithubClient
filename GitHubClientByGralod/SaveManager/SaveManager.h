//
//  SaveManager.h
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveManager : NSObject
-(void)saveAuthorizationInfo: (id) authorizationInfo;
-(NSDictionary *)loadAuthorizationInfo;
- (void)deleteAuthorizationInfo;
@end

NS_ASSUME_NONNULL_END
