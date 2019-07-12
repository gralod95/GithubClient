//
//  Wireframe.m
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "Wireframe.h"

#import "AuthorizationViewController.h"
#import "AuthorizationErrorViewController.h"
#import "EnterAuthorizationDataViewController.h"
#import "UsersRepositoriesViewController.h"
#import "RepositoryInfoViewController.h"

#import "Presenter.h"
#import "Interactor.h"
#import "States.h"

@implementation Wireframe
{
    Presenter *presenter;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        presenter = [[Presenter alloc] initWithWireframe:self];
        Interactor *interactor = [[Interactor alloc] initWithPresenter:presenter];
        [presenter setInteractor: interactor];
    }
    return self;
}

- (UIViewController *)getRootViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"PresenterViewController"];
}

- (UIViewController *)getViewControllerForState:(NSInteger)aPresenterStateNumber
{
    GHCPresenterState aState = (GHCPresenterState)aPresenterStateNumber;
    UIStoryboard *storyboard =
    [UIStoryboard storyboardWithName:@"Main"
                              bundle:[NSBundle mainBundle]];
    UIViewController *returnVC = [UIViewController new];
    
    switch (aState) {
        case GHCAuthorizationPresentingState:
            returnVC =[storyboard instantiateViewControllerWithIdentifier:@"AuthorizationViewController"];
            [((AuthorizationViewController *) returnVC)
             setDelegate: (id <AuthorizationViewControllerDelegate>)presenter];
            break;
        case GHCEnterAuthorizationDataPresentingState:
            returnVC =[storyboard instantiateViewControllerWithIdentifier:@"EnterAuthorizationDataViewController"];
            [((EnterAuthorizationDataViewController *)returnVC) setDelegate:(id<EnterAuthorizationDataViewControllerDelegate>)presenter];
            break;
        case GHCAuthorizationErrorPresentingState:
            returnVC =[storyboard instantiateViewControllerWithIdentifier:@"AuthorizationErrorViewController"];
            
            [((AuthorizationErrorViewController *) returnVC)
             setDelegate: (id <AuthorizationErrorViewControllerDelegate>)presenter];
            break;
        case GHCUserRepositoriesLoadingPresentingState:
        case GHCUserRepositoriesLoadingErrorPresentingState:
        case GHCUserRepositoriesPresentingState:
            returnVC =[storyboard instantiateViewControllerWithIdentifier:@"UsersRepositoriesViewController"];
            [((UsersRepositoriesViewController *) returnVC)
             setDelegate: (id <UsersRepositoriesViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>)presenter];
            break;
        case GHCRepositoryInfoLoadingPresentingState:
        case GHCRepositoryInfoPresentingState:
        case GHCRepositoryInfoLoadingErrorPresentingState:
            returnVC =[storyboard instantiateViewControllerWithIdentifier:@"RepositoryInfoViewController"];
            [((RepositoryInfoViewController *) returnVC)
             setDelegate: (id <RepositoryInfoViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>)presenter];
            break;
        default:
            break;
    }
    return returnVC;
}

@end
