//
//  Wireframe.h
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Wireframe : NSObject

- (id)getViewControllerForState:(NSInteger)aState;
- (id)getRootViewController;

@end

NS_ASSUME_NONNULL_END
