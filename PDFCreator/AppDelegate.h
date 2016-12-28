//
//  AppDelegate.h
//  PDFCreator
//
//  Created by Adarsha on 22/12/16.
//  Copyright © 2016 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property NSString *folderPath;

- (void)saveContext;


@end

