//
//  Presenter.h
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UITableView.h"

NS_ASSUME_NONNULL_BEGIN
@interface Presenter : NSObject <UITableViewDataSource, UITableViewDelegate>
- (instancetype)initWithWireframe:(id)aWireframe;
- (void)setStateWithInt:(NSInteger)aStateInt;
- (void)setInteractor:(id)interactor;
//AuthorizationViewControllerDelegate
- (void) cancelActionInViewController:(id)aViewController;
//EnterAuthorizationDataViewControllerDelegate
- (void) data:(id)aDataDictionary
didEnterActionInViewController:(id)aViewController;
//AuthorizationErrorViewControllerDelegate
- (void)reauthorizationActionInViewController:(id)aViewController;
- (void)reenterAuthorizationDataActionInViewController:(id)aViewController;
//AuthorizationErrorViewControllerDelegate && UsersRepositoriesViewControllerDelegate && RepositoryInfoViewControllerDelegate
- (NSString *)getContentTextForLabel:(id)aLabel
                    inViewController:(id)aViewController;

//UsersRepositoriesViewControllerDelegate
- (NSString *)getImageForImageView:(id)aImageView
                 inViewController:(id)aViewController;
- (void)exitActionInViewController:(id)aViewController;

//UsersRepositoriesViewControllerDelegate && RepositoryInfoViewControllerDelegate
- (void)reloadDataActionInViewController:(id)aViewController;
//UsersRepositoriesViewControllerDelegate && RepositoryInfoViewControllerDelegate
- (UIImage *)getBackgroundImageForButton:(id)aImageView
                        inViewController:(id)aViewController;
//RepositoryInfoViewControllerDelegate
- (BOOL)getEnableStateForButton:(id)aButton
               inViewController:(id)aViewController;
//RepositoryInfoViewControllerDelegate
- (void)backActionInViewController:(UIViewController *)aViewController;
- (void)nextActionInViewController:(UIViewController *)aViewController;
//UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

//UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
