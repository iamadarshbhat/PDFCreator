//
//  MyDataController.h
//  PDFCreator
//
//  Created by Adarsha on 28/12/16.
//  Copyright © 2016 NousInfosystems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MyDataController : NSObject

@property (strong) NSManagedObjectContext *managedObjectContext;

- (void)initializeCoreData;
@end
