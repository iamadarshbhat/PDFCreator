//
//  ShowFileViewController.m
//  PDFCreator
//
//  Created by Adarsha on 26/12/16.
//  Copyright © 2016 NousInfosystems. All rights reserved.
//

#import "ShowFileViewController.h"
#import "FileCell.h"
#import "Folder+CoreDataClass.swift"


@interface ShowFileViewController ()
{
    NSMutableArray *fileArray;
}


@end

@implementation ShowFileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    fileArray  = [NSMutableArray array];
    [self.fileCollectionView registerNib:[UINib nibWithNibName:@"FileCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"fileCellId"];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//This method is called to fectch photo from library
- (IBAction)addFileAction:(id)sender {
    UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
    imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imageController.delegate = self;
    [self presentViewController:imageController animated:YES completion:nil];
}

//Called after image is picked
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
   UIImage *image =  [info valueForKey:UIImagePickerControllerOriginalImage];
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self addFile:image];
    

}

#pragma mark Collection View delegate methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return fileArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"fileCellId";
    FileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
   
    [cell.imgFile setImage: [fileArray objectAtIndex:indexPath.row]];
    
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( (self.view.bounds.size.width / 2)-26, 100);
}

//Adds the file
-(void)addFile:(UIImage *)image{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexPaths addObject:[NSIndexPath indexPathForRow:fileArray.count inSection:0]];
       FileCell *cell =(FileCell *) [self.fileCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
    [cell.imgFile  setImage:image];
    [fileArray addObject:image];

    [self.fileCollectionView insertItemsAtIndexPaths:indexPaths];
}

@end
