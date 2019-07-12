//
//  Interactor.h
//  GitHubClientByGralod
//
//  Created by 1 on 06/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Interactor : NSObject
- (id)initWithPresenter:(id)aPresenter;

- (void)cancelOperation;
- (NSString *)getErrorDescription;
- (NSString *)getUsersDescription;
- (id)getUsersDescriptionImage;
- (void)authorizationDataDidEnter:(NSDictionary *)aData;
- (NSInteger)getNumberOfCellsForRepositoriesTableView;
- (NSDictionary *)getDataForRepoTableViewCellAtIndex:(NSInteger)aCellIndex;
- (void)loadUserRepositories;
- (void)logoutAction;
- (void)repoTableViewDidSelectRowAtIndexPath:(NSInteger)aRepositoryId;
- (NSString *)getRepositoryDescription;
- (void)repoInfoCloseAction;
- (BOOL)presentingFirstRepoCommitsList;
- (BOOL)presentingLastRepoCommitsList;
- (NSInteger)numberOfRowsInCommitsTableView;
- (NSDictionary *)getSetupDataForCommitCellAtRow:(NSInteger)aRow;
- (void)reloadActionInCommitTableView;
- (void)presentNextListActionInCommintTableView;
- (void)presentPreviousListActionInCommintTableView;
@end

NS_ASSUME_NONNULL_END
