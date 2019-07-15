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
//действие введены данные для авторизации
- (void)authorizationDataDidEnter:(NSDictionary *)aData;
//действие выхода из системы
- (void)logoutAction;
//действие отмены запросов
- (void)cancelOperation;
//запрос описания ошибки
- (NSString *)getErrorDescription;
//запрос информации пользователя
- (id)getUsersDescriptionImage;
- (NSString *)getUsersDescription;

//запрос загрузки репозиториев пользователя
- (void)loadUserRepositories;
//запрос количества репозиториев пользователя
- (NSInteger)getNumberOfCellsForRepositoriesTableView;
//запрос короткой информации репозитория
- (NSDictionary *)getDataForRepoTableViewCellAtIndex:(NSInteger)aCellIndex;

- (void)repoTableViewDidSelectRowAtIndexPath:(NSInteger)aRepositoryId;
- (NSString *)getRepositoryDescription;
- (void)repoInfoCloseAction;
- (BOOL)presentingFirstRepoCommitsList;
- (BOOL)presentingLastRepoCommitsList;
- (BOOL)getEnableToPresentNextRepoCommitList;
- (NSInteger)numberOfRowsInCommitsTableView;
- (NSDictionary *)getSetupDataForCommitCellAtRow:(NSInteger)aRow;
- (void)reloadActionInCommitTableView;
- (void)presentNextListActionInCommintTableView;
- (void)presentPreviousListActionInCommintTableView;
@end

NS_ASSUME_NONNULL_END
