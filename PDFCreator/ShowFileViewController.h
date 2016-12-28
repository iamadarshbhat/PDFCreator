//
//  ShowFileViewController.h
//  PDFCreator
//
//  Created by Adarsha on 26/12/16.
//  Copyright © 2016 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowFileViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *fileCollectionView;

- (IBAction)addFileAction:(id)sender;

@end
