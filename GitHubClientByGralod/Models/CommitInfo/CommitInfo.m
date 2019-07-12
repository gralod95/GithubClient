//
//  CommitInfo.m
//  GitHubClientByGralod
//
//  Created by 1 on 12/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "CommitInfo.h"
@interface CommitInfo ()

@property (atomic, strong, nonnull,readwrite) NSString *commitMessageString;
@property (atomic, strong, nonnull,readwrite) NSString *commitAuthorAvatarURLString;
@property (atomic, strong, nonnull,readwrite) NSString *commitAuthorNameString;
@property (atomic, strong, nonnull,readwrite) NSString *commitDateString;
@property (atomic, strong, nonnull,readwrite) NSString *commitHashString;

@end

@implementation CommitInfo

- (instancetype)initWithCommitMessageString:(NSString *)aCommitMessageString
             andCommitAuthorAvatarURLString:(NSString *)aCommitAuthorAvatarURLString
                  andCommitAuthorNameString:(NSString *)aCommitAuthorNameString
                        andCommitDateString:(NSString *)aCommitDateString
                        andCommitHashString:(NSString *)aCommitHashString
{
    self = [super init];
    if (self)
    {
        self.commitMessageString = aCommitMessageString;
        self.commitAuthorAvatarURLString = aCommitAuthorAvatarURLString;
        self.commitAuthorNameString = aCommitAuthorNameString;
        self.commitDateString = aCommitDateString;
        self.commitHashString = aCommitHashString;
    }
    return self;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"commitInfo \n commitMessageString: %@ \n commitAuthorAvatarURLString: %@, \n commitAuthorNameString: %@, \n commitDateString: %@, \n commitHashString: %@",
            self.commitMessageString,
            self.commitAuthorAvatarURLString,
            self.commitAuthorNameString,
            self.commitDateString,
            self.commitHashString];
}
@end
