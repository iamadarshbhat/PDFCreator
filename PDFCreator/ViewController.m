//
//  ViewController.m
//  PDFCreator
//
//  Created by Adarsha on 22/12/16.
//  Copyright © 2016 NousInfosystems. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    CGSize pagesize;
    NSString *pdfFilePath;
    UIWebView* webView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 70, 330, 300)];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)generatePDFAction:(id)sender {
    pagesize = CGSizeMake(850, 1100);
    NSString *fileName = @"purmy.pdf";
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *pdfWithFilename = [documentDirectory stringByAppendingPathComponent:fileName];
    NSLog(@"File Path -%@", pdfWithFilename);
    pdfFilePath = pdfWithFilename;
    [self generatePDF:pdfWithFilename];
}

- (IBAction)openPDFAction:(id)sender {
    
    if(pdfFilePath != nil){
       NSURL *url = [NSURL fileURLWithPath:pdfFilePath];
       NSURLRequest *request = [NSURLRequest requestWithURL:url];
       [webView setScalesPageToFit:YES];
       [webView loadRequest:request];
       [self.view addSubview:webView];
     }
}

- (IBAction)closePDFAction:(id)sender {
    [webView removeFromSuperview];
}

-(void) generatePDF:(NSString *) filePath{
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"owner", kCGPDFContextOwnerPassword, @"user", kCGPDFContextUserPassword, kCFBooleanFalse, kCGPDFContextAllowsCopying, kCFBooleanFalse, kCGPDFContextAllowsPrinting,  nil];
    
    
    
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, dictionary);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 850, 1100), nil);
    [self drawBackground];
    [self drawText];
    UIGraphicsEndPDFContext();
}

-(void)drawBackground{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect cgRect =  CGRectMake(0, 0, pagesize.width, pagesize.height);
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextFillRect(context, cgRect);
    
}

-(void)drawText{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:50];
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect textRect = CGRectMake(0, 0, [self myTextView].frame.size.width, [self myTextView].frame.size.height);
    NSString *myString = self.myTextView.text;
   
    [myString drawInRect:textRect withAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
}
@end
