//
//  AuthorizationErrorViewController.h
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AuthorizationErrorViewControllerDelegate <NSObject>

- (void)reauthorizationActionInViewController:(UIViewController *_Nullable)aViewController;
- (void)reenterAuthorizationDataActionInViewController:(UIViewController *_Nullable)aViewController;
- (NSString *)getContentTextForLabel:(UILabel *)aLabel
                    inViewController:(UIViewController *_Nullable)aViewController;

@end

@interface AuthorizationErrorViewController : UIViewController

@property (nonatomic, weak, nullable) id <AuthorizationErrorViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
