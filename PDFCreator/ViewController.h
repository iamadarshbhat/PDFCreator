//
//  ViewController.h
//  PDFCreator
//
//  Created by Adarsha on 22/12/16.
//  Copyright © 2016 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnGeneratePDF;
//@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;

- (IBAction)actionCamera:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *fristNateTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;


- (IBAction)generatePDFAction:(id)sender;
- (IBAction)openPDFAction:(id)sender;

- (IBAction)closePDFAction:(id)sender;

@end

