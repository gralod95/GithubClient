//
//  AuthorizationViewController.h
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AuthorizationViewControllerDelegate <NSObject>

- (void) cancelActionInViewController:(UIViewController *_Nullable)aViewController;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AuthorizationViewController : UIViewController

@property (nonatomic, weak, nullable) id <AuthorizationViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
