//
//  ShowFileViewController.m
//  PDFCreator
//
//  Created by Adarsha on 26/12/16.
//  Copyright © 2016 NousInfosystems. All rights reserved.
//

#import "ShowFileViewController.h"
#import "FileCell.h"



@interface ShowFileViewController ()
{
    
    NSArray * filesArray;
}


@end

@implementation ShowFileViewController
@synthesize selectedFolder;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.fileCollectionView registerNib:[UINib nibWithNibName:@"FileCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"fileCellId"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    filesArray = [self getFilesFrom:selectedFolder];
}

-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker{
    
}

//This method is called to fectch photo from library
- (IBAction)addFileAction:(id)sender {
        UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
        imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imageController.delegate = self;
        [self presentViewController:imageController animated:YES completion:nil];
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    //    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/ViveFolder"];
    //
    //    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    //        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    
    
//    
//    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"]
//                                                                                                            inMode:UIDocumentPickerModeImport];
//    documentPicker.delegate = self;
//    
//    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:documentPicker animated:YES completion:nil];
    
    
    //
    //    UIDocumentMenuViewController *importMenu =
    //    [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"public.data"]
    //                                                         inMode:UIDocumentPickerModeImport];
    //
    //    importMenu.delegate = self;
    //
    //    [importMenu addOptionWithTitle:@"Documents" image:nil order:UIDocumentMenuOrderFirst handler:^{
    //
    ////        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    ////
    ////        imagePickerController.delegate = self;
    ////        [self presentViewController:imagePickerController animated:YES completion:nil];
    //
    //        UIDocumentPickerViewController *documentPickerController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"] inMode:UIDocumentPickerModeImport];
    //        documentPickerController.delegate = self;
    //
    //        [self presentViewController:documentPickerController animated:YES completion:nil];
    //
    ////
    //    }];
    //
    
    //  [self presentViewController:importMenu animated:YES completion:nil];
    
    
    
    
}


//Called after image is picked
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image =  [info valueForKey:UIImagePickerControllerOriginalImage];
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSLog(@"Paths : %@",path);
    
    [self createAndSaveimage:image];
  
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
   // [self addFile:image];
    
}

-(void)createAndSaveimage:(UIImage*) image{
    NSData *pngData =    UIImagePNGRepresentation(image);
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES)[0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    }
  NSString *filePath = [dataPath stringByAppendingPathComponent:@"image.png"];
  [pngData writeToFile:filePath atomically:YES];
}

- (UIImage*)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      @"test.png" ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    return image;
    
    
    
}


- (NSArray *)getFilesFrom:(NSString *)folder{
    
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *appFolderPath = [path objectAtIndex:0];
    
    NSString *folderPath = [appFolderPath stringByAppendingString:folder];
    
    NSError *error1;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error1];
    NSLog(@"error: %@", error1.localizedDescription);
    
    
    int count;
    for (count = 0; count < (int)[contents count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [contents objectAtIndex:count]);
    }
    return contents;
}
#pragma mark Collection View delegate methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return filesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"fileCellId";
    FileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell setImgFile:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pdfImage"]]];
    [cell.lblFileName setText:[[filesArray objectAtIndex:indexPath.row] lastPathComponent]];
    
    
    
    if([selectedFolder  isEqual: @"/Inbox/"]){
        
        
    }else if ([selectedFolder isEqualToString:@"My Documents"]){
        
    }else if([selectedFolder isEqualToString:@"Images"]){
        
    }
    
    [cell.imgFile setImage: [filesArray objectAtIndex:indexPath.row]];
    
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( (self.view.bounds.size.width / 2)-26, 100);
}

//Adds the file
-(void)addFile:(UIImage *)image{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexPaths addObject:[NSIndexPath indexPathForRow:filesArray.count inSection:0]];
    FileCell *cell =(FileCell *) [self.fileCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
    [cell.imgFile  setImage:image];
    // [filesArray addObject:image];
    
    [self.fileCollectionView insertItemsAtIndexPaths:indexPaths];
}

#pragma mark Document Picker Delegate methods
-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url{
    NSLog(@"URL : %@",[url path]);
    
    
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        NSString *alertMessage = [NSString stringWithFormat:@"Successfully imported %@", [url lastPathComponent]];
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //
        //
        //
        //            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        //
        //            NSString*  path=[NSString stringWithFormat:@"%@/%@/",documentsDirectory,[url lastPathComponent]];
        //
        //            [url startAccessingSecurityScopedResource];
        //            NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        //
        //            __block NSData *data;
        //
        //            NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        //            NSError *error;
        //            [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
        //
        //                data = [NSData dataWithContentsOfURL:newURL];
        //
        //                [data writeToFile:path atomically:YES];
        //
        //            }];
        //            [url stopAccessingSecurityScopedResource];
        //
        //            NSLog(@"Path....%@",path);
        //
        //        });
        
        
        //**********************
        
        
        //        BOOL startAccessingWorked = [url startAccessingSecurityScopedResource];
        //        NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        //        NSLog(@"ubiquityURL %@",ubiquityURL);
        //        NSLog(@"start %d",startAccessingWorked);
        //
        //        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        //        NSError *error;
        //        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
        //            NSData *data = [NSData dataWithContentsOfURL:newURL];
        //            NSLog(@"error %@",error);
        //            NSLog(@"data %@",data);
        //        }];
        //        [url stopAccessingSecurityScopedResource];
        
        
        //**************
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/ViveFolder/"];
        
        
        //if ([fileManager fileExistsAtPath:documentsDirectory] == NO) {
        //NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"txtFile" ofType:@"txt"];
        [fileManager copyItemAtPath:[url path] toPath:dataPath error:&error];
        //}
        
        
        NSLog(@"Error dec - %@",[error localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Import"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}

@end
