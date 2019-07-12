//
//  CommitTableViewCell.h
//  GitHubClientByGralod
//
//  Created by 1 on 11/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commitMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commitAuthorAvatar;
@property (weak, nonatomic) IBOutlet UILabel *commitAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *commitDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitHashButton;

@end

NS_ASSUME_NONNULL_END
