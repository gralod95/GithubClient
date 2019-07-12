//
//  RepositoryInfoViewController.h
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol RepositoryInfoViewControllerDelegate <NSObject>

- (NSString *)getContentTextForLabel:(UILabel *)aLabel
                    inViewController:(UIViewController *_Nullable)aViewController;
- (UIImage *)getBackgroundImageForButton:(UIButton *)aImageView
                        inViewController:(UIViewController *_Nullable)aViewController;
- (BOOL)getEnableStateForButton:(UIButton *)aButton
               inViewController:(UIViewController *_Nullable)aViewController;
- (BOOL)getHiddenStateForButton:(UIButton *)aButton
               inViewController:(UIViewController *_Nullable)aViewController;

- (void)reloadDataActionInViewController:(UIViewController *)aViewController;
- (void)backActionInViewController:(UIViewController *)aViewController;
- (void)nextActionInViewController:(UIViewController *)aViewController;

- (void)exitActionInViewController:(UIViewController *)aViewController;
@end
@interface RepositoryInfoViewController : UIViewController

@property (nonatomic, weak, nullable) id <RepositoryInfoViewControllerDelegate, UITableViewDataSource, UITableViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
