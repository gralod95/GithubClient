//
//  PresenterViewController.m
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "PresenterViewController.h"

@interface PresenterViewController ()

@end

@implementation PresenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PresenterViewController_viewDidAppear"
                                                        object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
