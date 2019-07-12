//
//  RepositoryInfo.h
//  GitHubClientByGralod
//
//  Created by 1 on 09/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RepositoryInfo : NSObject

@property (atomic, strong, nonnull,readonly) NSString *repoFullNameString;
@property (atomic, strong, nonnull,readonly) NSString *repoNameString;
@property (atomic, strong, nonnull,readonly) NSString *repoDescriptionString;
@property (atomic, strong, nonnull,readonly) NSString *repoOwnerLoginString;
@property (atomic, strong, nonnull,readonly) NSString *repoOwnerAvatarURLString;
@property (atomic, strong, nonnull,readonly) NSString *repoForksCountString;
@property (atomic, strong, nonnull,readonly) NSString *repoWatchersCountString;
@property (atomic, strong, nonnull,readonly) NSString *repoCommitsURL;

- (instancetype)initWithRepoFullNameString:(NSString *)aRepoFullNameString
                         andRepoNameString:(NSString *)aRepoNameString
                  andRepoDescriptionString:(NSString *)aRepoDescriptionString
                   andRepoOwnerLoginString:(NSString *)aRepoOwnerLoginString
               andRepoOwnerAvatarURLString:(NSString *)aRepoOwnerAvatarURLString
                   andRepoForksCountString:(NSString *)aRepoForksCountString
                andRepoWatchersCountString:(NSString *)aRepoWatchersCountString
                         andRepoCommitsURL:(NSString *)aRepoCommitsURL;
@end

NS_ASSUME_NONNULL_END
