//
//  AuthorizationViewController.m
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "AuthorizationViewController.h"

@interface AuthorizationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonTouchUpInside:(id)sender;

@end

@implementation AuthorizationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewControllersData)
                                                 name:@"setNeedsUpdateViewControllersData"
                                               object:nil];
}
- (void) updateViewControllersData
{
    
}
- (IBAction)cancelButtonTouchUpInside:(id)sender
{
    if([self.delegate respondsToSelector:@selector(cancelActionInViewController:)])
        [self.delegate cancelActionInViewController:self];
    else
        NSLog(@"AuthorizationViewController delegate is wrong!!");
}
@end
