//
//  AppDelegate.h
//  断点续传_01
//
//  Created by 吴锡坤 on 5/12/18.
//  Copyright © 2018 吴锡坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

