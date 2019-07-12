//
//  States.h
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#ifndef States_h
#define States_h
typedef enum GHCPresenterState
{
    GHCNothingPresentedState,
    GHCAuthorizationPresentingState,//1.авторизация
    GHCEnterAuthorizationDataPresentingState,//2.ввод данных для авторизации
    GHCAuthorizationErrorPresentingState,//3.ошибка авторизации
    GHCUserRepositoriesLoadingPresentingState,//4.загрузка репозиториев пользователя
    GHCUserRepositoriesLoadingErrorPresentingState,//5.ошибка загрузки репозиториев пользователя
    GHCUserRepositoriesPresentingState,//6.показ репозиториев пользователя
    GHCRepositoryInfoLoadingPresentingState,//7.загрузка информации о репозитории
    GHCRepositoryInfoLoadingErrorPresentingState,//8.ошибка загрузки информации о репозитории
    GHCRepositoryInfoPresentingState,//9.показ информации о репозитории
} GHCPresenterState;


#endif /* States_h */
