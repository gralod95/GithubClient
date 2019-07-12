//
//  EnterAuthorizationDataViewController.h
//  GitHubClientByGralod
//
//  Created by 1 on 06/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnterAuthorizationDataViewControllerDelegate <NSObject>

- (void) data:(NSDictionary *_Nullable)dataDictionary
didEnterActionInViewController:(UIViewController *_Nonnull)aViewController;

@end

NS_ASSUME_NONNULL_BEGIN

@interface EnterAuthorizationDataViewController : UIViewController

@property (nonatomic, weak, nullable) id <EnterAuthorizationDataViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
