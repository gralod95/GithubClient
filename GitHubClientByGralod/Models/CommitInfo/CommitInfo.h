//
//  CommitInfo.h
//  GitHubClientByGralod
//
//  Created by 1 on 12/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommitInfo : NSObject

@property (atomic, strong, nonnull,readonly) NSString *commitMessageString;
@property (atomic, strong, nonnull,readonly) NSString *commitAuthorAvatarURLString;
@property (atomic, strong, nonnull,readonly) NSString *commitAuthorNameString;
@property (atomic, strong, nonnull,readonly) NSString *commitDateString;
@property (atomic, strong, nonnull,readonly) NSString *commitHashString;

- (instancetype)initWithCommitMessageString:(NSString *)aCommitMessageString
             andCommitAuthorAvatarURLString:(NSString *)aCommitAuthorAvatarURLString
                  andCommitAuthorNameString:(NSString *)aCommitAuthorNameString
                        andCommitDateString:(NSString *)aCommitDateString
                        andCommitHashString:(NSString *)aCommitHashString;
@end

NS_ASSUME_NONNULL_END
