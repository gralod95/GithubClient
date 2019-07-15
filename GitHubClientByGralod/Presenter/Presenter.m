//
//  Presenter.m
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "Presenter.h"

#import "Wireframe.h"
#import "Interactor.h"
#import "AppDelegate.h"

#import "UIKit/UIViewController.h"

#import "CustomTableViewCell.h"
#import "CommitTableViewCell.h"
#import "ErrorInfoTableViewCell.h"
#import "States.h"


#define AUTHORIZATION_VIEW_CONTROLLER_IDENTIFIER @"AuthorizationViewController"
#define AUTHORIZATION_ERROR_VIEW_CONTROLLER_IDENTIFIER @"AuthorizationErrorViewController"
#define ENTER_AUTHORIZATION_DATA_VIEW_CONTROLLER_IDENTIFIER @"EnterAuthorizationDataViewController"
#define USERS_REPOSITORIES_VIEW_CONTROLLER_IDENTIFIER @"UsersRepositoriesViewController"
#define REPOSITORY_INFO_VIEW_CONTROLLER_IDENTIFIER @"RepositoryInfoViewController"


#define DESCRIPION_LABEL_RESTORATION_IDENTIFIER @"descriptionLabel"
#define DESCRIPION_IMAGE_RESTORATION_IDENTIFIER @"descriptionImage"
#define USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER @"UsersRepositoriesViewControllerGeneralTableView"
#define REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER @"RepositoryInfoViewControllerGeneralTableView"
#define RELOAD_DATA_BUTTON_RESTORATION_IDENTIFIER @"reloadDataButton"
#define BACK_BUTTON_RESTORATION_IDENTIFIER @"backButton"
#define NEXT_BUTTON_RESTORATION_IDENTIFIER @"nextButton"

@implementation Presenter
{
    NSDate *viewControllerPresentedDate; //дата открытия окна
    BOOL rootViewControllerDidAppear;
    BOOL inPresentingProgress;
    NSInteger presentingLineLeight;
    
    GHCPresenterState state;
    UIViewController *rootViewController;
    NSString *presentedViewControllerRestorationIdentifier;
    Wireframe *wireframe;
    Interactor *interactor;
}

- (instancetype)initWithWireframe:(Wireframe *)aWireframe
{
    self = [super init];
    if (self)
    {
        state = GHCNothingPresentedState;
        wireframe = aWireframe;
        rootViewController = [wireframe getRootViewController];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rootVCDidAppear)
                                                     name:@"PresenterViewController_viewDidAppear"
                                                   object:nil];
        rootViewControllerDidAppear = false;
        inPresentingProgress = false;
        presentingLineLeight = 0;
    }
    return self;
}

- (void)setInteractor:(Interactor *)aInteractor
{
    interactor = aInteractor;
}

- (BOOL)canPresentViewController
{
    if(rootViewControllerDidAppear && !inPresentingProgress)
    {
        NSTimeInterval timeInterval = [viewControllerPresentedDate timeIntervalSinceNow];
        if (timeInterval > -1.1f)
            return false;
        else
            return true;
    }
    else
        return false;
}
- (void)rootVCDidAppear
{
    rootViewControllerDidAppear = true;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"PresenterViewController_viewDidAppear"
                                                  object:nil];
    viewControllerPresentedDate = [NSDate date];
}

- (void)setStateWithInt:(NSInteger) aStateInt
{
    [self setState:(GHCPresenterState)aStateInt];
}

- (void)setState:(GHCPresenterState) aState
{
    if(rootViewController != [UIViewController new])
        dispatch_async(dispatch_get_main_queue(), ^{
            self->rootViewController = [[(AppDelegate*)
                                         [[UIApplication sharedApplication]delegate] window] rootViewController];
        });
    state = aState;
    [self updatePresentingViewController];
    
}

- (void)updatePresentingViewController
{
    UIViewController *presentingVC = [wireframe getViewControllerForState:state];
    
    if (presentingVC != [UIViewController new])
    {
        if ([self canPresentViewController])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:presentingVC];
            });
        }
        else
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self->presentingLineLeight ++;
                NSInteger viewControllerPresentingLineNumber = self->presentingLineLeight;
                while (viewControllerPresentingLineNumber > 1)
                {
                    while (![self canPresentViewController]){}
                    viewControllerPresentingLineNumber --;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"after wait canPresent");
                    [self presentViewController:presentingVC];
                });
            });
    }
    else
        NSLog(@"wireframe didn't return view for presen!!!");
}

-(void) presentViewController:(UIViewController *)aViewController
{
//    NSLog(@"Presenter_presentViewController");
//    NSLog(@"method info: \n presentedViewControllerRestorationIdentifier: %@, \n aViewController.restorationIdentifier: %@", presentedViewControllerRestorationIdentifier, aViewController.restorationIdentifier);
    
    inPresentingProgress = true;
    if([presentedViewControllerRestorationIdentifier isEqual:aViewController.restorationIdentifier])
    {
        NSLog(@"update view controller");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setNeedsUpdateViewControllersData" object:nil];
        self->presentedViewControllerRestorationIdentifier = aViewController.restorationIdentifier;
        self->inPresentingProgress = false;
        self->presentingLineLeight --;
    }
    else if (![rootViewController presentedViewController])
    {
        NSLog(@"load new view controller");
        [self presentViewControllerInRootViewController:aViewController];
    }
    else
    {
        NSLog(@"close old viewcontroller and load new view controller");
        [[self->rootViewController presentedViewController]
         dismissViewControllerAnimated:false
         completion:^{
             [self presentViewControllerInRootViewController:aViewController];
         }];
    }
    viewControllerPresentedDate = [NSDate date];
}
- (void)presentViewControllerInRootViewController:(UIViewController *)aViewController
{
    self->presentedViewControllerRestorationIdentifier = aViewController.restorationIdentifier;
    [self->rootViewController presentViewController:aViewController
                                           animated:true
                                         completion:^
     {
         self->inPresentingProgress = false;
         self->presentingLineLeight --;
         
     }];
}

#pragma mark
#pragma mark AuthorizationViewControllerDelegate
#pragma mark

- (void) cancelActionInViewController:(id)aViewController
{
    NSLog(@"Presenter_cancelButtonTouchUpInsideInAuthorizationViewController, state: %u", state);
    if(state == GHCAuthorizationPresentingState)
       [interactor cancelOperation];
}

#pragma mark
#pragma mark AuthorizationErrorViewControllerDelegate
#pragma mark

- (void)reauthorizationActionInViewController:(id)aViewController
{
    NSLog(@"Presenter_reauthorizationActionInViewController, state: %u", state);
    [interactor authorizationDataDidEnter:@{}];
}
- (void)reenterAuthorizationDataActionInViewController:(id)aViewController
{
    NSLog(@"Presenter_reenterAuthorizationDataActionInViewController, state: %u", state);
    [self setState:GHCEnterAuthorizationDataPresentingState];
}

#pragma mark
#pragma mark EnterAuthorizationDataViewControllerDelegate
#pragma mark

- (void) data:(NSDictionary *)aDataDictionary
didEnterActionInViewController:(UIViewController *)aViewController
{
    if([aViewController.restorationIdentifier isEqual:ENTER_AUTHORIZATION_DATA_VIEW_CONTROLLER_IDENTIFIER])
        [interactor authorizationDataDidEnter:aDataDictionary];
    else
        NSLog(@"unknown view controller or unknown request from view controller: %@", aViewController);
}

#pragma mark
#pragma mark AuthorizationErrorViewControllerDelegate && UsersRepositoriesViewControllerDelegate && RepositoryInfoViewControllerDelegate
#pragma mark

- (NSString *)getContentTextForLabel:(UILabel *)aLabel
                    inViewController:(UIViewController *)aViewController
{
    NSLog(@"Presenter_getContentTextForLabel inViewController, state: %u", state);
    NSLog(@"aLabel textInputContextIdentifier: %@, \n aViewController restorationIdentifier: %@",
          [aLabel restorationIdentifier],
          [aViewController restorationIdentifier]);
    
    if([[aLabel restorationIdentifier]  isEqual:DESCRIPION_LABEL_RESTORATION_IDENTIFIER])
    {
        if([[aViewController restorationIdentifier] isEqual:AUTHORIZATION_ERROR_VIEW_CONTROLLER_IDENTIFIER])
            return  [interactor getErrorDescription];
        else if([[aViewController restorationIdentifier] isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_IDENTIFIER])
            return [interactor getUsersDescription];
        else if([[aViewController restorationIdentifier] isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_IDENTIFIER])
        {
            return [interactor getRepositoryDescription];
        }
    }
    else
        NSLog(@"unknown view controller or unknown request from view controller: %@", aViewController);
    return @"";
}

#pragma mark
#pragma mark UsersRepositoriesViewControllerDelegate
#pragma mark

- (UIImage *)getImageForImageView:(UIImageView *)aImageView
                 inViewController:(UIViewController *)aViewController
{
    NSLog(@"Presenter_getImageForImageView inViewController, state: %u", state);
    NSLog(@"aImageView textInputContextIdentifier: %@, \n aViewController restorationIdentifier: %@",
          [aImageView restorationIdentifier],
          [aViewController restorationIdentifier]);
    
    if([[aImageView restorationIdentifier]  isEqual:DESCRIPION_IMAGE_RESTORATION_IDENTIFIER])
    {
        if([[aViewController restorationIdentifier] isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_IDENTIFIER])
        {
            NSLog(@"UsersRepositoriesViewControllerDelegate succes");
            return [interactor getUsersDescriptionImage];
        }
        else
            NSLog(@"unknown view controller or unknown request from view controller: %@", aViewController);
    }
    else
        NSLog(@"unknown view controller or unknown request from view controller: %@", aViewController);
    return [UIImage new];
}

- (void)exitActionInViewController:(UIViewController *)aViewController
{
    NSLog(@"Presenter_exitActionInViewController");
    if([[aViewController restorationIdentifier] isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_IDENTIFIER])
    {
        [interactor logoutAction];
    }
    if([[aViewController restorationIdentifier] isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_IDENTIFIER])
    {
        [interactor repoInfoCloseAction];
    }
    else
        NSLog(@"unknown view controller or unknown request from view controller: %@", aViewController);
}

#pragma mark
#pragma mark UsersRepositoriesViewControllerDelegate && RepositoryInfoViewControllerDelegate
#pragma mark
- (void)reloadDataActionInViewController:(UIViewController *)aViewController
{
    if([[aViewController restorationIdentifier] isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_IDENTIFIER])
    {
        if ((state == GHCUserRepositoriesPresentingState)|| (state == GHCUserRepositoriesLoadingErrorPresentingState))
        {
            NSLog(@"reloadDataActionInViewController");
            [self setStateWithInt:GHCUserRepositoriesLoadingPresentingState];
            [interactor loadUserRepositories];
        }
        else if(state == GHCUserRepositoriesLoadingPresentingState)
        {
            NSLog(@"cancelReloadingDataActionInViewController");
            [interactor cancelOperation];
        }
    }
    else if([[aViewController restorationIdentifier] isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_IDENTIFIER])
    {
        if ((state == GHCRepositoryInfoPresentingState)|| (state == GHCRepositoryInfoLoadingErrorPresentingState))
        {
            NSLog(@"reloadDataActionInViewController");
            [interactor reloadActionInCommitTableView];
        }
        else if(state == GHCRepositoryInfoLoadingPresentingState)
        {
            NSLog(@"cancelReloadingDataActionInViewController");
            [interactor cancelOperation];
        }
    }
    else
        NSLog(@"unknown view controller or unknown request from view controller: %@", aViewController);
}

#pragma mark
#pragma mark UsersRepositoriesViewControllerDelegate && RepositoryInfoViewControllerDelegate
#pragma mark
- (UIImage *)getBackgroundImageForButton:(UIButton *)aButton
                        inViewController:(UIViewController *)aViewController
{
    if ([[aButton restorationIdentifier] isEqual:RELOAD_DATA_BUTTON_RESTORATION_IDENTIFIER]
        &&[[aViewController restorationIdentifier] isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_IDENTIFIER])
    {
        NSLog(@"getBackgroundImageForButton_reloadDataActionInViewController");
        switch (state)
        {
            case GHCUserRepositoriesLoadingPresentingState:
                [interactor loadUserRepositories];
                return [UIImage imageNamed:@"cancel_icon"];
                break;
            case GHCUserRepositoriesPresentingState:
            case GHCUserRepositoriesLoadingErrorPresentingState:
                return [UIImage imageNamed:@"reload_icon"];
                break;
            default:
                break;
        }
    }
    else if ([[aButton restorationIdentifier] isEqual:RELOAD_DATA_BUTTON_RESTORATION_IDENTIFIER]
        &&[[aViewController restorationIdentifier] isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_IDENTIFIER])
    {
        switch (state)
        {
            case GHCRepositoryInfoLoadingPresentingState:
                return [UIImage imageNamed:@"cancel_icon"];
                break;
            case GHCRepositoryInfoPresentingState:
            case GHCRepositoryInfoLoadingErrorPresentingState:
                return [UIImage imageNamed:@"reload_icon"];
                break;
            default:
                break;
        }
    }
    else
        NSLog(@"unknown view controller or unknown request from view controller: %@", aViewController);
    return [UIImage new];
}

#pragma mark
#pragma mark RepositoryInfoViewControllerDelegate
#pragma mark
- (BOOL)getHiddenStateForButton:(UIButton *)aButton
               inViewController:(UIViewController *)aViewController
{
    if([aViewController.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_IDENTIFIER])
    {
        //TODO: realise this line of method
        if([aButton.restorationIdentifier isEqual:BACK_BUTTON_RESTORATION_IDENTIFIER])
            switch (state)
        {
            case GHCRepositoryInfoPresentingState:
                //get list number from interator
                if([interactor presentingFirstRepoCommitsList])
                    return true;
                else
                    return false;
                break;
                
            case GHCRepositoryInfoLoadingPresentingState:
            case GHCRepositoryInfoLoadingErrorPresentingState:
                return true;
                break;
            default:
                NSLog(@"Presenter_getHiddenStateForButton: inViewController: unknown state!!!");
                break;
        }
        else if([aButton.restorationIdentifier isEqual:NEXT_BUTTON_RESTORATION_IDENTIFIER])
            switch (state)
        {
            case GHCRepositoryInfoPresentingState:
                if([interactor presentingLastRepoCommitsList])
                    return true;
                else
                    return false;
                break;
            case GHCRepositoryInfoLoadingErrorPresentingState:
            case GHCRepositoryInfoLoadingPresentingState:
                return true;
                break;
            default:
                NSLog(@"Presenter_getHiddenStateForButton: inViewController: unknown state!!!");
                break;
        }
        else
            NSLog(@"Presenter_getHiddenStateForButton: inViewController: unknown button!!!");
    }
    else
        NSLog(@"Presenter_getHiddenStateForButton: inViewController: unknown viewController!!!");
    return true;
}
- (BOOL)getEnableStateForButton:(UIButton *)aButton
               inViewController:(UIViewController *)aViewController
{
    if([aViewController.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_IDENTIFIER])
    {
        if([aButton.restorationIdentifier isEqual:NEXT_BUTTON_RESTORATION_IDENTIFIER])
            switch (state)
        {
            case GHCRepositoryInfoPresentingState:
                //get list number from interator
                return [interactor getEnableToPresentNextRepoCommitList];
                break;
            case GHCRepositoryInfoLoadingErrorPresentingState:
            case GHCRepositoryInfoLoadingPresentingState:
                return false;
                break;
            default:
                NSLog(@"unreachable state");
                break;
        }
        else
            NSLog(@"Presenter_getEnableStateForButton: inViewController: unknown button!!!");
    }
    else
        NSLog(@"Presenter_getEnableStateForButton: inViewController: unknown viewController!!!");
    return false;
}

- (void)backActionInViewController:(UIViewController *)aViewController
{
    if ([aViewController.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_IDENTIFIER])
    {
        [interactor presentPreviousListActionInCommintTableView];
    }
    else
        NSLog(@"unknown view controller or unknown request from view controller: %@", aViewController);
}

- (void)nextActionInViewController:(UIViewController *)aViewController
{
    if ([aViewController.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_IDENTIFIER])
    {
        [interactor presentNextListActionInCommintTableView];
    }
    else
        NSLog(@"unknown view controller or unknown request from view controller: %@", aViewController);
}
#pragma mark
#pragma mark UITableViewDataSource
#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"Presenter_numberOfRowsInSection");
    if([tableView.restorationIdentifier  isEqual: USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
        if(state == GHCUserRepositoriesLoadingPresentingState || state == GHCUserRepositoriesLoadingErrorPresentingState)
            return 0;
        else if(state == GHCUserRepositoriesPresentingState)
            return [interactor getNumberOfCellsForRepositoriesTableView];
    }
    else if([tableView.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
        switch (state)
    {
        case GHCRepositoryInfoLoadingPresentingState:
            return 0;
            break;
        case GHCRepositoryInfoPresentingState:
            return [interactor numberOfRowsInCommitsTableView];
            break;
        case GHCRepositoryInfoLoadingErrorPresentingState:
            return 1;
            break;
        default:
            break;
    }
    else
        NSLog(@"unknown table view: %@", tableView);
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Presenter_cellForRowAtIndexPath");
    if([tableView.restorationIdentifier  isEqual: USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
        return [self getCellFromTableView:tableView byIdentifier:@"CustomTableViewCell"];
    else if([tableView.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
        //TODO: realise this line of method
        switch (state)
    {
        case GHCRepositoryInfoPresentingState:
            return [self getCellFromTableView:tableView byIdentifier:@"CommitTableViewCell"];
            break;
        case GHCRepositoryInfoLoadingErrorPresentingState:
            return [self getCellFromTableView:tableView byIdentifier:@"ErrorInfoTableViewCell"];
            break;
        default:
            break;
    }
    else
        NSLog(@"unknown table view: %@", tableView);
    
    return [UITableViewCell new];
}
- (UITableViewCell *)getCellFromTableView:(UITableView *)aTableView byIdentifier:(NSString *)aIdentifier
{
//    NSLog(@"Presenter_getCellFromTableView");
    UITableViewCell *outputTableViewCell =
    [aTableView dequeueReusableCellWithIdentifier:aIdentifier];
    if (!outputTableViewCell)
    {
        [aTableView registerNib:[UINib nibWithNibName:aIdentifier bundle:nil]
        forCellReuseIdentifier:aIdentifier];
        outputTableViewCell =
        [aTableView dequeueReusableCellWithIdentifier:aIdentifier];
    }
    return outputTableViewCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"Presenter_numberOfSectionsInTableView");
    if([tableView.restorationIdentifier isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
        return 1;
    }
    else if([tableView.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
        return 1;
    }
    else
        NSLog(@"unknown table view: %@", tableView);
    
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    NSLog(@"Presenter_titleForHeaderInSection");
    if([tableView.restorationIdentifier isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
        if(state == GHCUserRepositoriesLoadingPresentingState)
            return @"Идет загрузка репозиториев...";
        if(state == GHCUserRepositoriesLoadingErrorPresentingState)
            return @"Ошибка загрузки репозиториев.";
        else
            return @"";
    }
    else if([tableView.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
        switch (state) {
            case GHCRepositoryInfoLoadingPresentingState:
                return @"Загрузка коммитов..";
                break;
            case GHCRepositoryInfoPresentingState:
                return @"";
                break;
            case GHCRepositoryInfoLoadingErrorPresentingState:
                return @"Ошибка загрузки";
                break;
            default:
                break;
        }
    else
        NSLog(@"unknown table view: %@", tableView);
    
    return @"";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Presenter_canEditRowAtIndexPath");
    if([tableView.restorationIdentifier isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER]
       ||[tableView.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
        return false;
    else
        NSLog(@"unknown table view: %@", tableView);
    
    return false;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Presenter_canMoveRowAtIndexPath");
    if([tableView.restorationIdentifier isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER]
       &&[tableView.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
        return false;
    else
        NSLog(@"unknown table view: %@", tableView);
    
    return false;
}

#pragma mark
#pragma mark UITableViewDelegate
#pragma mark

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Presenter_willDisplayCell");
    if([tableView.restorationIdentifier isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
        NSInteger cellIndex = indexPath.row;
        NSDictionary *repoTableViewCellDataDictionary = [interactor getDataForRepoTableViewCellAtIndex:cellIndex];
        CustomTableViewCell *customCell = (CustomTableViewCell *)cell;
        customCell.repoNameLabel.text =
        [repoTableViewCellDataDictionary valueForKey:@"repoNameLabelText"];
        customCell.repoDescriptionLabel.text =
        [repoTableViewCellDataDictionary valueForKey:@"repoDescriptionLabelText"];
        customCell.repoOwnerNameLabel.text =
        [repoTableViewCellDataDictionary valueForKey:@"repoOwnerNameLabelText"];
        customCell.repoForksLabel.text =
        [repoTableViewCellDataDictionary valueForKey:@"repoForksLabelText"];
        customCell.repoWatchersLabel.text =
        [repoTableViewCellDataDictionary valueForKey:@"repoWatchersLabelText"];
        [self loadImageWithURLString:[repoTableViewCellDataDictionary valueForKey:@"repoOwnerAvatarURLString"]                    andSetItTo:customCell.repoOwnerAvatarImageView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *repoOwnerAvatarURL =
            [repoTableViewCellDataDictionary valueForKey:@"repoOwnerAvatarURL"];
            NSData *repoOwnerAvatarData = [NSData dataWithContentsOfURL:repoOwnerAvatarURL];
            UIImage *repoOwnerAvatarImage = [UIImage imageWithData:repoOwnerAvatarData];
            dispatch_async(dispatch_get_main_queue(), ^{
                customCell.repoOwnerAvatarImageView.image =
                repoOwnerAvatarImage;
            });
        });
    }
    else if([tableView.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
        switch (state) {
            case GHCRepositoryInfoPresentingState:
                [self setupCommitTableViewCell:(CommitTableViewCell *)cell
                                         atRow:indexPath.row];
                break;
            case GHCRepositoryInfoLoadingErrorPresentingState:
                [((ErrorInfoTableViewCell *)cell).ErrorInfoLabel setText:[interactor getErrorDescription]];
                break;
            default:
                break;
        }
    }
    else
        NSLog(@"unknown table view: %@", tableView);
}
- (void)setupCommitTableViewCell:(CommitTableViewCell *)aCell
                           atRow:(NSInteger)aRow
{
    NSDictionary *setupData = [interactor getSetupDataForCommitCellAtRow:aRow];
    [aCell.commitMessageLabel setText:[setupData valueForKey:@"commitMessageContent"]];//
    [aCell.commitAuthorName setText:[setupData valueForKey:@"commitAuthorNameContent"]];//
    [aCell.commitDateLabel setText:[setupData valueForKey:@"commitDateLabelContent"]];//
    [aCell.commitHashButton setTitle:[setupData valueForKey:@"commitHashContent"]
                            forState:UIControlStateNormal];//
    [aCell setNeedsDisplay];
    [self loadImageWithURLString:[setupData valueForKey:@"commitAuthorAvatarURLString"]
                      andSetItTo:aCell.commitAuthorAvatar];
    
}
- (void)loadImageWithURLString:(NSString *)aURLString andSetItTo:(UIImageView *)aImageView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSURL *aURL = [NSURL URLWithString:aURLString];
        NSData *aData = [NSData dataWithContentsOfURL:aURL];
        UIImage *aImage = [UIImage imageWithData:aData];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [aImageView setImage:aImage];
        });
    });
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Presenter_heightForRowAtIndexPath");
    if([tableView.restorationIdentifier isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
        return 117.0f;
    else if([tableView.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
        if(state == GHCRepositoryInfoPresentingState)
        {
            //dinamic height for cell
            CGFloat heightForMessageLabel = 22.0f;
            NSDictionary *setupDataDictionary = [interactor getSetupDataForCommitCellAtRow:indexPath.row];
            NSString *commitMessageContent = [setupDataDictionary valueForKey:@"commitMessageContent"];
            UILabel *aLabel = [UILabel new];
            [aLabel setNumberOfLines:-1];
            [aLabel setFrame:CGRectMake(0, 0, tableView.frame.size.width - 16, FLT_MAX)];
            [aLabel setText:commitMessageContent];
            [aLabel sizeToFit];
            heightForMessageLabel = aLabel.frame.size.height;
            return 106.0f + heightForMessageLabel;
        }
        else
        {
            return 50.0f;
        }
    }
    else
        NSLog(@"unknown table view: %@", tableView);
    
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    NSLog(@"Presenter_heightForHeaderInSection");
    if([tableView.restorationIdentifier isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
        if(state == GHCUserRepositoriesLoadingPresentingState|| state == GHCUserRepositoriesLoadingErrorPresentingState)
            return tableView.frame.size.height*0.1;
        else
            return 0.0f;
    }
    else if([tableView.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
        if(state == GHCRepositoryInfoLoadingPresentingState|| state == GHCRepositoryInfoLoadingErrorPresentingState)
            return tableView.frame.size.height*0.1;
        else
            return 0.0f;
    }
    else
        NSLog(@"unknown table view: %@", tableView);
    
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    NSLog(@"Presenter_heightForFooterInSection");
    if([tableView.restorationIdentifier isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
        return 0.0f;
    else if([tableView.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
        //TODO: realise this line of method
    }
    else
        NSLog(@"unknown table view: %@", tableView);
    
    return 0.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView.restorationIdentifier isEqual:USERS_REPOSITORIES_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
        NSLog(@"didSelectRowAtIndexPath: %@", indexPath);
        
        [interactor repoTableViewDidSelectRowAtIndexPath:indexPath.row];
    }
    else if([tableView.restorationIdentifier isEqual:REPOSITORY_INFO_VIEW_CONTROLLER_GENERAL_TABLE_VIEW_IDENTIFIER])
    {
    }
    else
        NSLog(@"unknown table view: %@", tableView);
}


@end
