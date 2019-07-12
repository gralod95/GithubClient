//
//  RepositoryInfo.m
//  GitHubClientByGralod
//
//  Created by 1 on 09/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "RepositoryInfo.h"

@interface RepositoryInfo ()
@property (atomic, strong, nonnull,readwrite) NSString *repoFullNameString;
@property (atomic, strong, nonnull,readwrite) NSString *repoNameString;
@property (atomic, strong, nonnull,readwrite) NSString *repoDescriptionString;
@property (atomic, strong, nonnull,readwrite) NSString *repoOwnerLoginString;
@property (atomic, strong, nonnull,readwrite) NSString *repoOwnerAvatarURLString;
@property (atomic, strong, nonnull,readwrite) NSString *repoForksCountString;
@property (atomic, strong, nonnull,readwrite) NSString *repoWatchersCountString;
@property (atomic, strong, nonnull,readwrite) NSString *repoCommitsURL;
@end

@implementation RepositoryInfo
- (instancetype)initWithRepoFullNameString:(NSString *)aRepoFullNameString
                         andRepoNameString:(NSString *)aRepoNameString
                  andRepoDescriptionString:(NSString *)aRepoDescriptionString
                   andRepoOwnerLoginString:(NSString *)aRepoOwnerLoginString
               andRepoOwnerAvatarURLString:(NSString *)aRepoOwnerAvatarURLString
                   andRepoForksCountString:(NSString *)aRepoForksCountString
                andRepoWatchersCountString:(NSString *)aRepoWatchersCountString
                         andRepoCommitsURL:(NSString *)aRepoCommitsURL;
{
    self = [super init];
    if (self)
    {
        self.repoFullNameString = aRepoFullNameString;
        self.repoNameString = aRepoNameString;
        self.repoDescriptionString = aRepoDescriptionString;
        self.repoOwnerLoginString = aRepoOwnerLoginString;
        self.repoOwnerAvatarURLString = aRepoOwnerAvatarURLString;
        self.repoForksCountString = aRepoForksCountString;
        self.repoWatchersCountString = aRepoWatchersCountString;
        self.repoCommitsURL = aRepoCommitsURL;
    }
    return self;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"repoInfo \n repoFullNameString: %@ \n repoDiscriptionString: %@, \n repoOwnerLogin: %@, \n repoOwnerAvatarURLString: %@, \n repoForksCountString: %@, \n repoWatchersCountString: %@, \n repoCommitsURL: %@",
            self.repoFullNameString,
            self.repoDescriptionString,
            self.repoOwnerLoginString,
            self.repoOwnerAvatarURLString,
            self.repoForksCountString,
            self.repoWatchersCountString,
            self.repoCommitsURL];
}
@end
