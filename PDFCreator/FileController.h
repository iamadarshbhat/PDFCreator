//
//  FileController.h
//  PDFCreator
//
//  Created by Adarsha on 23/12/16.
//  Copyright © 2016 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FolderCell.h"

@interface FileController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *fileCollectionView;

- (IBAction)addNewFolder:(id)sender;



@end
