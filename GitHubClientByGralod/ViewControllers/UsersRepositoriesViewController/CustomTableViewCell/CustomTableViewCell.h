//
//  CustomTableViewCell.h
//  GitHubClientByGralod
//
//  Created by 1 on 10/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *repoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoOwnerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoForksLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoWatchersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *repoOwnerAvatarImageView;

@end

NS_ASSUME_NONNULL_END
