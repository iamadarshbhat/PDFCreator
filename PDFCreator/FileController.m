//
//  FileController.m
//  PDFCreator
//
//  Created by Adarsha on 23/12/16.
//  Copyright © 2016 NousInfosystems. All rights reserved.
//

#import "FileController.h"
#import "ShowFileViewController.h"
#import <CoreData/CoreData.h>
#import "MyDataController.h"
#import "FolderPaths+CoreDataClass.h"


@interface FileController ()

@end

@implementation FileController{
   
    NSManagedObjectContext *managedObjectContext;
    NSMutableArray *folderNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.fileCollectionView registerNib:[UINib nibWithNibName:@"FolderCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"folderCellID"];
   
    
    MyDataController *datacontroller =  [[MyDataController alloc] init];
    [datacontroller initializeCoreData];
    managedObjectContext = [datacontroller managedObjectContext];
    folderNames = [NSMutableArray array];
    
    [self fetchPathsFromDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return folderNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"folderCellID";
    FolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.folderBtn addTarget:self action:@selector(onFolderClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.folderBtn setTitle:[folderNames objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( (self.view.bounds.size.width / 2)-26, 100);
}

-(void)onFolderClick:(id)sender{
    ShowFileViewController *showFileController =  [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"showFileControllerId"];
    [self.navigationController pushViewController:showFileController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)addNewFolder:(id)sender {
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexPaths addObject:[NSIndexPath indexPathForRow:folderNames.count inSection:0]];
    NSString *folderName = [NSString stringWithFormat:@"New Folder %lu",(unsigned long)folderNames.count];
    [folderNames addObject:folderName];
    [self.fileCollectionView insertItemsAtIndexPaths:indexPaths];
    [self saveFolderPathInSqlite:folderName];
    
}


#pragma mark Model Layer Stuffs


//Save folder Path in sqlite
-(void)saveFolderPathInSqlite:(NSString *) fileName{
    
   
    //Create new managed Object
    NSManagedObject *newfolderPath = [NSEntityDescription insertNewObjectForEntityForName:@"FolderPaths" inManagedObjectContext:managedObjectContext];
    [newfolderPath setValue:fileName  forKey:@"folderName"];
   
    
    
    NSError *error = nil;
    if ([managedObjectContext save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

-(void)fetchPathsFromDatabase{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FolderPaths"];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (FolderPaths *folderPaths in results) {
        [folderNames addObject:folderPaths.folderName];

    }
        if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
}
@end
