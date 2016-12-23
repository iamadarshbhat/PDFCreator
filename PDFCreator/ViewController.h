//
//  ViewController.h
//  PDFCreator
//
//  Created by Adarsha on 22/12/16.
//  Copyright © 2016 NousInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnGeneratePDF;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

- (IBAction)generatePDFAction:(id)sender;
- (IBAction)openPDFAction:(id)sender;

- (IBAction)closePDFAction:(id)sender;

@end

