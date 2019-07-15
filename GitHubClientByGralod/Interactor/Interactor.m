//
//  Interactor.m
//  GitHubClientByGralod
//
//  Created by 1 on 06/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "Interactor.h"
#import "UIKit/UIImage.h"

#import "Presenter.h"
#import "UAGithubEngine.h"
#import "SaveManager.h"

#import "UserInfo.h"
#import "RepositoryInfo.h"
#import "CommitInfo.h"

#import "States.h"


#define INPUT_USER_INFO_DICTIONARY_AVATAR_URL_KEY @"avatar_url"
#define INPUT_USER_INFO_DICTIONARY_USER_NAME_KEY @"name"
#define INPUT_USER_INFO_DICTIONARY_USER_REPOSITORIES_URL_KEY @"repos_url"
#define INPUT_USER_INFO_DICTIONARY_USER_REPOSITORY_COUNT_KEY @"public_repos"
#define DEFAULT_AVATAR_IMAGE_URL_STRING @"https://camo.githubusercontent.com/b7e0f990da68ed79a907d143ab32efb79f4b88cf/68747470733a2f2f312e67726176617461722e636f6d2f6176617461722f62633236303935316433313836626530396438316335386565333536303963333f643d68747470732533412532462532466769746875622e6769746875626173736574732e636f6d253246696d6167657325324667726176617461727325324667726176617461722d757365722d3432302e706e6726723d6726733d3430"

typedef enum GHCGithubEngineRequestType
{
    GHCNoRequest,
    GHCAuthorizationRequest,//1.запрос авторизации
    GHCUserRepositoriesDataRequest,//2.запрос репозиториев пользователя
    GHCRepositoryCommitsDataRequest,//3.запрос коммитов репозитория
} GHCGithubEngineRequestType;
typedef enum GHCRequestErrorType
{
    GHCNoError,
    GHCNoInternetConectionError,//1.нет подключения к интернету
    GHCOperationCanceledError,//2.операция была остановленна пользователем
    GHCWrongInputDataError,//3.данные введены некорректно
    GHCUnknownError,//4.неизвесная ошибка
} GHCRequestErrorType;

@implementation Interactor
{
    UserInfo *userInfo;
    NSArray<RepositoryInfo *> *repositoriesArray;
    Presenter *presenter;
    GHCGithubEngineRequestType requestType;
    NSString *requestErrorDescription;
    GHCRequestErrorType requestErrorType;
    NSInteger selectedRepo;
    NSThread *requestThread;
    
    NSDictionary *repoCommitsListsDictionary;
    NSInteger presentingRepoCommitsListNumber;
    NSInteger lastLoadedRepoCommitsListNumber;
    BOOL lastRepoCommitListDidLoad;
}
- (id)initWithPresenter:(Presenter *)aPresenter
{
    self = [super init];
    if (self)
    {
        NSLog(@"Interactor init");
        presenter = aPresenter;
        selectedRepo = -1;
        [self loadUserInfo];
    }
    return self;
    
}

- (void)loadUserInfo
{
    NSLog(@"Interactor_loadUserInfo");
    SaveManager *loader = [[SaveManager alloc] init];
    NSDictionary *loadedData = [loader loadAuthorizationInfo];
    if([[loadedData valueForKey:@"loadingError"]  isEqual:@"no_saving_data"])
        [presenter setStateWithInt:GHCEnterAuthorizationDataPresentingState];
    else
    {
        NSString *aLogin = [loadedData valueForKey:@"login"];
        NSString *aPassword = [loadedData valueForKey:@"password"];
        [self authorizationWithLogin:aLogin andPassword:aPassword];
    }
}

-(void) authorizationWithLogin:(NSString *)aLogin
                   andPassword:(NSString *)aPassword
{
    NSLog(@"Interactor_authorizationWithLoginAndPassword, \n aLogin: %@, \n aPassword: %@ \n userInfo: %@", aLogin, aPassword,userInfo);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->presenter setStateWithInt:GHCAuthorizationPresentingState];
    });
    
    requestType = GHCAuthorizationRequest;

    if(![aLogin  isEqual: @""]&&aLogin!=nil)
        userInfo = [[UserInfo alloc] initWithLogin:aLogin andPassword:aPassword];
    
    requestThread = [[NSThread alloc] initWithBlock:^
    {
        UAGithubEngine *githubEngine;
        githubEngine = [[UAGithubEngine alloc] initWithUsername:self->userInfo.login
                                                       password:self->userInfo.password
                                               withReachability:true];
        [githubEngine user:self->userInfo.login
                   success:^(id item)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (self->requestType == GHCAuthorizationRequest)
                     [self authorizationSuccess:item];
             });
         }
                   failure:^(NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (self->requestType == GHCAuthorizationRequest)
                     [self requestFailure:error];
             });
         }];
    }];
    [requestThread start];
}

- (void)loadUserRepositories
{
    NSLog(@"loadUserRepositories");
    
    requestType = GHCUserRepositoriesDataRequest;
    NSLog(@"[requestThread isFinished] %i, requestType: %u",[requestThread isFinished],requestType);
    [requestThread isFinished];
    requestThread = [[NSThread alloc] initWithBlock:^
                     {
//                         [NSThread sleepForTimeInterval:2.0f];
                         UAGithubEngine *githubEngine;
                         githubEngine = [[UAGithubEngine alloc] initWithUsername:self->userInfo.login
                                                                        password:self->userInfo.password
                                                                withReachability:true];
//                         NSString *currentUser = @"jesseduffield";
//                         [githubEngine repositoriesForUser:currentUser includeWatched:true success:^(id item)
//                         {
                         [githubEngine repositoriesWithSuccess:^(id item)
                          {
                              NSLog(@"self->requestType: %u", self->requestType);
                              if(self->requestType == GHCUserRepositoriesDataRequest)
                              {
                                  NSArray *repos = (NSArray *)item;
                                  
                                  self->repositoriesArray = [NSArray new];
                                  for(id repo in repos)
                                  {
                                      NSDictionary *repoInfo = (NSDictionary *)repo;
                                      
                                      NSString *repoFullNameString = [repoInfo valueForKey:@"full_name"];
                                      NSString *repoNameString = [repoInfo valueForKey:@"name"];
                                      NSString *repoDescriptionString = [repoInfo valueForKey:@"description"];
                                      if((NSNull *)repoDescriptionString == [NSNull null])
                                          repoDescriptionString = @"описание отсутствует";
                                      NSDictionary *repoOwnerInfo = [repoInfo valueForKey:@"owner"];
                                      NSString *repoOwnerLoginString = [repoOwnerInfo valueForKey:@"login"];
                                      NSString *repoOwnerAvatarURLString = [repoOwnerInfo valueForKey:@"avatar_url"];
                                      if ((NSNull *)repoOwnerAvatarURLString == [NSNull null]) {
                                          repoOwnerAvatarURLString = DEFAULT_AVATAR_IMAGE_URL_STRING;
                                      }
                                      NSString *repoForksCountString =
                                      [((NSNumber *)[repoInfo valueForKey:@"forks_count"]) stringValue];
                                      NSString *repoWatchersCountString =
                                      [((NSNumber *)[repoInfo valueForKey:@"watchers_count"]) stringValue];
                                      NSString *repoCommitsURL = [repoInfo valueForKey:@"commits_url"];
                                      
                                      RepositoryInfo *repositoryInfo = [[RepositoryInfo alloc]
                                                                        initWithRepoFullNameString:repoFullNameString
                                                                        andRepoNameString:repoNameString
                                                                        andRepoDescriptionString:repoDescriptionString
                                                                        andRepoOwnerLoginString:repoOwnerLoginString andRepoOwnerAvatarURLString:repoOwnerAvatarURLString andRepoForksCountString:repoForksCountString andRepoWatchersCountString:repoWatchersCountString andRepoCommitsURL:repoCommitsURL];
                                      NSMutableArray *repositoriesMutableArray = [[NSMutableArray alloc]
                                                                                  initWithArray:self->repositoriesArray];
                                      [repositoriesMutableArray addObject:repositoryInfo];
                                      self->repositoriesArray = repositoriesMutableArray;
                                  }
                                  NSLog(@"go to GHCUserRepositoriesPresentingState");
                                  [self->presenter setStateWithInt:GHCUserRepositoriesPresentingState];
                              }
                          } failure:^(NSError *error) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (self->requestType == GHCUserRepositoriesDataRequest)
                                      [self requestFailure:error];
                              });
                          }];
                     }];
    [requestThread setThreadPriority:0.5];
    [requestThread start];
}

- (void)cancelOperation
{
    NSLog(@"Interactor_cancelOperation, requestType: %u, requestThread: %@", requestType, requestThread);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->requestThread cancel];
    });
    if (requestType == GHCAuthorizationRequest)
        [presenter setStateWithInt:GHCAuthorizationErrorPresentingState];
    else if (requestType == GHCUserRepositoriesDataRequest)
        [presenter setStateWithInt:GHCUserRepositoriesLoadingErrorPresentingState];
    else if (requestType == GHCRepositoryCommitsDataRequest)
        [presenter setStateWithInt:GHCRepositoryInfoLoadingErrorPresentingState];

    requestType = GHCNoRequest;
    requestErrorType = GHCOperationCanceledError;
}

-(void) authorizationSuccess:(id)item
{
    NSLog(@"success");
    NSLog(@"%@", [item class]);
    NSDictionary *inputUserInfoDictionary = item;
    
    NSString *userName = ((NSArray *)[inputUserInfoDictionary
                                      valueForKey:INPUT_USER_INFO_DICTIONARY_USER_NAME_KEY])[0];
    [userInfo setUserName:userName];
    
    NSString *userAvatarURL = ((NSArray *)[inputUserInfoDictionary
                                      valueForKey:INPUT_USER_INFO_DICTIONARY_AVATAR_URL_KEY])[0];
    
    if ((NSNull *)userAvatarURL == [NSNull null]) {
        userAvatarURL = DEFAULT_AVATAR_IMAGE_URL_STRING;
    }
    [userInfo setAvatarURL:userAvatarURL];
    
    NSString *userRepositoriesURL = ((NSArray *)[inputUserInfoDictionary
                                           valueForKey:INPUT_USER_INFO_DICTIONARY_USER_REPOSITORIES_URL_KEY])[0];
    [userInfo setRepositoriesURL:userRepositoriesURL];
    
    NSNumber *userRepositoryCount = ((NSArray *)[inputUserInfoDictionary
                                                 valueForKey:INPUT_USER_INFO_DICTIONARY_USER_REPOSITORY_COUNT_KEY])[0];
    [userInfo setRepositoryCount:userRepositoryCount];
    
    NSLog(@"userInfo: \n %@", userInfo);
    
    SaveManager *saver = [[SaveManager alloc] init];
    [saver saveAuthorizationInfo:userInfo];
    
    [presenter setStateWithInt:GHCUserRepositoriesLoadingPresentingState];
}
-(void) requestFailure:(NSError *)error
{
    NSLog(@"failure");
    switch (error.code) {
        case -1009:
        case -1001:
            NSLog(@"no internet");
            requestErrorType = GHCNoInternetConectionError;
            break;
        case -1012:
            NSLog(@"wrong login or password");
            requestErrorType = GHCWrongInputDataError;
            break;
        default:
            NSLog(@"unknown error code");
            requestErrorType = GHCUnknownError;
            break;
    }
    switch (requestType) {
        case GHCAuthorizationRequest:
            [presenter setStateWithInt:GHCAuthorizationErrorPresentingState];
            break;
        case GHCUserRepositoriesDataRequest:
            [presenter setStateWithInt:GHCUserRepositoriesLoadingErrorPresentingState];
            break;
        default:
            break;
    }
//    [presenter setStateWithInt:GHCAuthorizationErrorPresentingState];
}


- (NSString *)getErrorDescription
{
    switch (requestErrorType) {
        case GHCNoError:
            return @"Нет ошибки";
            break;
        case GHCNoInternetConectionError:
            return @"Нет подключения к интернету";
            break;
        case GHCOperationCanceledError:
            return @"Операция была приостановленна";
            break;
        case GHCWrongInputDataError:
            return @"Данные введены некорректно";
            break;
        case GHCUnknownError:
            return @"Неизвесная ошибка";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)getUsersDescription
{
    NSString *login = userInfo.login;
    NSString *userName = userInfo.userName;
    NSString *returnedContentString = @"";
    if((NSNull *)userName == [NSNull null] || [userName isEqual:@""])
        returnedContentString = login;
    else
        returnedContentString = userName;
    
    NSLog(@"returnedContentString: %@", returnedContentString);
    return returnedContentString;
}
- (void)authorizationDataDidEnter:(NSDictionary *)aDataDictionary
{
    NSString *aLogin = [aDataDictionary valueForKey:@"login"];
    NSString *aPassword = [aDataDictionary valueForKey:@"password"];
    
    NSLog(@"Interactor_authorizationDataDidEnter, \n login: %@, \n password: %@", aLogin, aPassword);
    
    [self authorizationWithLogin:aLogin andPassword:aPassword];
}


- (UIImage *)getUsersDescriptionImage
{
    NSString *userDescriptionImageURLString = userInfo.avatarURL;
    NSURL *userDescriptionImageURL = [NSURL URLWithString:userDescriptionImageURLString];
    NSData *imageDataFromURL = [NSData dataWithContentsOfURL:userDescriptionImageURL];
    UIImage *outputImage = [UIImage imageWithData:imageDataFromURL];
    return outputImage;
}

- (NSInteger)getNumberOfCellsForRepositoriesTableView
{
    return repositoriesArray.count;
}

- (NSDictionary *)getDataForRepoTableViewCellAtIndex:(NSInteger)aCellIndex
{
    RepositoryInfo *repoInfo = repositoriesArray[aCellIndex];
    NSDictionary *outputDictionary = @{
                                       @"repoNameLabelText": repoInfo.repoNameString,
                                       @"repoDescriptionLabelText": repoInfo.repoDescriptionString,
                                           @"repoOwnerNameLabelText": repoInfo.repoOwnerLoginString,
                                           @"repoForksLabelText": repoInfo.repoForksCountString,
                                           @"repoWatchersLabelText": repoInfo.repoWatchersCountString,
                                           @"repoOwnerAvatarURLString": repoInfo.repoOwnerAvatarURLString,
                                       };
    return outputDictionary;
}

- (void)logoutAction
{
    [self cancelOperation];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SaveManager *deleter = [[SaveManager alloc] init];
        [deleter deleteAuthorizationInfo];
    });
    
    [presenter setStateWithInt:GHCEnterAuthorizationDataPresentingState];
}
- (void)repoTableViewDidSelectRowAtIndexPath:(NSInteger)aIndexPath
{
    selectedRepo = aIndexPath;
    presentingRepoCommitsListNumber = 1;
    lastLoadedRepoCommitsListNumber = 0;
    lastRepoCommitListDidLoad = false;
    [self loadNextRepoCommitsList];
    [presenter setStateWithInt:GHCRepositoryInfoLoadingPresentingState];
}
- (void)loadNextRepoCommitsList
{
    NSLog(@"Interactor_loadNextRepoCommitsList");
    requestType = GHCRepositoryCommitsDataRequest;
    
    RepositoryInfo *repoInfo = repositoriesArray [selectedRepo];
    
    
    requestThread = [[NSThread alloc] initWithBlock:^
                     {
                         UAGithubEngine *githubEngine = [[UAGithubEngine alloc]
                                                         initWithUsername:self->userInfo.login
                                                         password:self->userInfo.password
                                                         withReachability:true];
//                         githubEngine commit
                         NSInteger loadingListNumber = self->lastLoadedRepoCommitsListNumber+1;
                         [githubEngine commitsForRepository:repoInfo.repoFullNameString
                                               atListNumber:loadingListNumber
                                                    success:^(id item)
                          {
                              dispatch_async(dispatch_get_main_queue(), ^
                              {
                                  if (self->requestType == GHCRepositoryCommitsDataRequest)
                                      [self successLoadingRepositoryCommitsPageWithArray:item
                                                                           andListNumber:loadingListNumber];
                              });
                          }
                                                    failure:^(NSError *error)
                          {
                              //TODO: realiseThisLine
                              [self requestFailure:error];
                              [self->presenter setStateWithInt:GHCRepositoryInfoLoadingErrorPresentingState];
                              self->requestType = GHCNoRequest;
                              NSLog(@"error: %@", error);
                          }];
                     }];
    [requestThread start];
}
- (NSString *)getRepositoryDescription
{
    if(selectedRepo == -1)
        return @"";
    else
        return ((RepositoryInfo *)repositoriesArray [selectedRepo]).repoFullNameString;
}
- (void)successLoadingRepositoryCommitsPageWithArray:(NSArray *)aArray
                                       andListNumber:(NSInteger)listNumber
{
    NSArray *repoCommitsListArray = [NSArray new];
    for(NSDictionary *arrayItem in aArray)
    {
        NSLog(@"arrayItem: %@", arrayItem);
        NSDictionary *commitData = [arrayItem valueForKey:@"commit"];
        NSDictionary *commitAuthorData = [arrayItem valueForKey:@"author"];
        
        NSString *commitMessageString = [commitData valueForKey:@"message"];
        NSString *commitAuthorAvatarURLString = [commitAuthorData valueForKey:@"avatar_url"];
        NSString *commitAuthorLoginString = [commitAuthorData valueForKey:@"login"];
        if((NSNull *)commitAuthorLoginString == [NSNull null])
        {
            commitAuthorLoginString = [(NSDictionary *)[commitData valueForKey:@"committer"] valueForKey:@"name"];
        }
        if ((NSNull *)commitAuthorAvatarURLString == [NSNull null]) {
            commitAuthorAvatarURLString = DEFAULT_AVATAR_IMAGE_URL_STRING;
        }
        NSString *commitDateString = [(NSDictionary *)[commitData valueForKey:@"author"] valueForKey:@"date"];
        NSString *commitHashString = [(NSDictionary *)[commitData valueForKey:@"tree"] valueForKey:@"sha"];
        
        CommitInfo *commitInfo = [[CommitInfo alloc] initWithCommitMessageString:commitMessageString
                                              andCommitAuthorAvatarURLString:commitAuthorAvatarURLString
                                                   andCommitAuthorNameString:commitAuthorLoginString
                                                         andCommitDateString:commitDateString
                                                         andCommitHashString:commitHashString];
        NSMutableArray *repoCommitsListMutableArray = [[NSMutableArray alloc] initWithArray:repoCommitsListArray];
        [repoCommitsListMutableArray addObject:commitInfo];
        repoCommitsListArray = repoCommitsListMutableArray;
    }
    if(repoCommitsListArray.count > 0)
    {
        lastLoadedRepoCommitsListNumber ++;
        if(!repoCommitsListsDictionary)
            repoCommitsListsDictionary = [NSDictionary new];
        NSMutableDictionary *repoCommitsListsMutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:repoCommitsListsDictionary];
        [repoCommitsListsMutableDictionary setValue:repoCommitsListArray
                                             forKey:[NSString stringWithFormat:@"%li",listNumber]];
        repoCommitsListsDictionary = repoCommitsListsMutableDictionary;
        if(listNumber == presentingRepoCommitsListNumber)
            [presenter setStateWithInt:GHCRepositoryInfoPresentingState];
        if (repoCommitsListArray.count < 30)
            lastRepoCommitListDidLoad = true;
        [self loadNextRepoCommitsListIfNeed];
    }
    else
        lastRepoCommitListDidLoad = true;
    
    NSLog(@"repoCommitsListArray@@ %li",repoCommitsListArray.count);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"setNeedsUpdateViewControllersData"
     object:nil];
    //*****
}
- (void)repoInfoCloseAction
{
    [self cancelOperation];
    [presenter setStateWithInt:GHCUserRepositoriesLoadingPresentingState];
//    [self loadUserRepositories];
}

- (BOOL)presentingFirstRepoCommitsList
{
    return presentingRepoCommitsListNumber == 1;
}
- (BOOL)presentingLastRepoCommitsList
{
    return (lastRepoCommitListDidLoad&&(presentingRepoCommitsListNumber == lastLoadedRepoCommitsListNumber));
}

- (NSInteger)numberOfRowsInCommitsTableView
{
    return [(NSArray *)[repoCommitsListsDictionary valueForKey:[NSString stringWithFormat:@"%li",presentingRepoCommitsListNumber]] count];
}

- (NSDictionary *)getSetupDataForCommitCellAtRow:(NSInteger)aRow
{
//    NSLog(@"presentingRepoCommitsListNumber:%li, aRow: %li",presentingRepoCommitsListNumber,aRow);
    NSArray *repoCommitsListArray = [repoCommitsListsDictionary valueForKey:[NSString stringWithFormat:@"%li", presentingRepoCommitsListNumber]];
    CommitInfo *commitInfo = repoCommitsListArray [aRow];
//    NSLog(@"commitInfo: %@",commitInfo);
    NSDictionary *outDictionary = @{
                                    @"commitMessageContent": commitInfo.commitMessageString,
                                    @"commitAuthorNameContent": commitInfo.commitAuthorNameString,
                                    @"commitDateLabelContent": commitInfo.commitDateString,
                                    @"commitHashContent": commitInfo.commitHashString,
                                    @"commitAuthorAvatarURLString": commitInfo.commitAuthorAvatarURLString,
                                    };
    return outDictionary;
}
- (void)reloadActionInCommitTableView
{
    NSLog(@"Interactor_reloadActionInCommitTableView");
    [presenter setStateWithInt:GHCRepositoryInfoLoadingPresentingState];
    requestType = GHCRepositoryCommitsDataRequest;
}
- (void)presentNextListActionInCommintTableView
{
    NSLog(@"Interactor_presentNextListActionInCommintTableView");
    NSLog(@"presentingRepoCommitsListNumber: %li, lastLoadedRepoCommitsListNumber: %li,count of nex page %li", presentingRepoCommitsListNumber, lastLoadedRepoCommitsListNumber,
          [(NSArray *)[repoCommitsListsDictionary valueForKey:[NSString stringWithFormat:@"%li",presentingRepoCommitsListNumber+2]] count]
          );
    if(!(lastRepoCommitListDidLoad&&(presentingRepoCommitsListNumber == lastLoadedRepoCommitsListNumber)))
    {
        presentingRepoCommitsListNumber ++;
        [presenter setStateWithInt:GHCRepositoryInfoPresentingState];
        [self loadNextRepoCommitsListIfNeed];
    }
}
- (void)loadNextRepoCommitsListIfNeed
{
    if((presentingRepoCommitsListNumber > lastLoadedRepoCommitsListNumber - 1)
       &&!lastRepoCommitListDidLoad)
    {
        [self loadNextRepoCommitsList];
    }
}
- (void)presentPreviousListActionInCommintTableView
{
    if(presentingRepoCommitsListNumber > 1)
    {
        presentingRepoCommitsListNumber --;
        [presenter setStateWithInt:GHCRepositoryInfoPresentingState];
    }
}

- (BOOL)getEnableToPresentNextRepoCommitList
{
    if(presentingRepoCommitsListNumber < lastLoadedRepoCommitsListNumber)
        return true;
    else
        return false;
}
@end
