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

@interface FileController ()

@end

@implementation FileController{
    NSMutableArray *fileArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.fileCollectionView registerNib:[UINib nibWithNibName:@"FolderCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"folderCellID"];
    fileArray = [NSMutableArray arrayWithObjects:@"New Folder", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return fileArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"folderCellID";
    FolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.folderBtn addTarget:self action:@selector(onFolderClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.folderBtn setTitle:[fileArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
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
    [indexPaths addObject:[NSIndexPath indexPathForRow:fileArray.count inSection:0]];
    [fileArray addObject:[NSString stringWithFormat:@"New Folder %lu",(unsigned long)fileArray.count]];
    [self.fileCollectionView insertItemsAtIndexPaths:indexPaths];
    [self saveFolderPathInSqlite:@"New Folder"];
    
}


#pragma mark Model Layer Stuffs
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
//Saves the path in sqlite
-(void)saveFolderPathInSqlite:(NSString *) fileName{

    NSManagedObjectContext *context = [self managedObjectContext];
    
    //Create new managed Object
    NSManagedObject *newfolderPath = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:context];
    [newfolderPath setValue:fileName  forKey:@"folderName"];
    
    NSError *error = nil;
    
    if([context save:&error]){
        NSLog(@"Cant save the error is %@",[error localizedDescription]);
    }
    
    
   
}
@end
