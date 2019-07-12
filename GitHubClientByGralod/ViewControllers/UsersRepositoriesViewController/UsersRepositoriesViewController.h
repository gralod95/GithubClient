//
//  UsersRepositoriesViewController.h
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol UsersRepositoriesViewControllerDelegate <NSObject>

- (NSString *)getContentTextForLabel:(UILabel *)aLabel
                    inViewController:(UIViewController *_Nullable)aViewController;
- (UIImage *)getImageForImageView:(UIImageView *)aImageView
                 inViewController:(UIViewController *_Nullable)aViewController;
- (UIImage *)getBackgroundImageForButton:(UIButton *)aImageView
                 inViewController:(UIViewController *_Nullable)aViewController;

- (void)reloadDataActionInViewController:(UIViewController *)aViewController;
- (void)exitActionInViewController:(UIViewController *)aViewController;

@end
@interface UsersRepositoriesViewController : UIViewController

@property (nonatomic, weak, nullable) id <UsersRepositoriesViewControllerDelegate, UITableViewDataSource, UITableViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
