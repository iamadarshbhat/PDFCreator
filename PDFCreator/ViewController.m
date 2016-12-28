//
//  ViewController.m
//  PDFCreator
//
//  Created by Adarsha on 22/12/16.
//  Copyright © 2016 NousInfosystems. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>


@interface ViewController ()

@end

@implementation ViewController
{
    CGSize pagesize;
    NSString *pdfFilePath;
    UIWebView* webView;
    UIImage *selectedImage;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 70, 330, 300)];
    self.btnCamera.clipsToBounds = YES;
    
    //half of the width
    self.btnCamera.layer.cornerRadius = self.btnCamera.frame.size.height/2.0f;
    self.btnCamera.layer.borderColor=[UIColor redColor].CGColor;
    self.btnCamera.layer.borderWidth=2.0f;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionCamera:(id)sender {
    UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
    imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imageController.delegate = self;
    [self presentViewController:imageController animated:YES completion:nil];
    
}

#pragma mark Camera Delegate methods


//Called after image is picked
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    selectedImage =  [info valueForKey:UIImagePickerControllerOriginalImage];
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    [picker dismissViewControllerAnimated:YES completion:nil];  
    [_btnCamera setImage:selectedImage forState:UIControlStateNormal];
}

- (IBAction)generatePDFAction:(id)sender {
    pagesize = CGSizeMake(850, 1100);
    NSString *fileName = @"purmy.pdf";
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *pdfWithFilename = [documentDirectory stringByAppendingPathComponent:fileName];
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
   // [self drawText];
    [self drawText:@"First Name :" inFrame:CGRectMake(20, 30, 150, 30) fontName:@"PostScript" fontSize:20];
    
    [self drawText:self.fristNateTextField.text inFrame:CGRectMake(200, 30, 150, 30) fontName:@"PostScript" fontSize:20];
    
    [self drawText:@"Last Name :" inFrame:CGRectMake(20, 60, 150, 30) fontName:@"PostScript" fontSize:20];
    
    [self drawText:self.lastNameTextField.text inFrame:CGRectMake(200, 60, 150, 30) fontName:@"PostScript" fontSize:20];
    
    
    [self drawLineFromPoint:CGPointMake(0, 70) toPoint:CGPointMake(300, 70)];
    [self drawText:@"Profile Photo :" inFrame:CGRectMake(20, 100, 150, 30) fontName:@"PostScript" fontSize:20];
    
    [self drawImage:selectedImage inRect:CGRectMake(200, 100, 150, 150)];
    UIGraphicsEndPDFContext();
}

-(void)drawBackground{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect cgRect =  CGRectMake(0, 0, pagesize.width, pagesize.height);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, cgRect);
    
}

-(void)drawText{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:50];
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //CGRect textRect = CGRectMake(0, 0, [self myTextView].frame.size.width, [self myTextView].frame.size.height);
    //NSString *myString = self.myTextView.text;
   
   // [myString drawInRect:textRect withAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
}

-(void)drawImage:(UIImage*)image inRect:(CGRect)rect
{
    [image drawInRect:rect];
}


-(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frame fontName:(NSString *)fontName fontSize:(int) fontSize
{
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    
    // Prepare the text using a Core Text Framesetter.
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)fontName, fontSize, NULL);
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, attr);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGRect frameRect = (CGRect){frame.origin.x, -1 * frame.origin.y, frame.size};
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    // CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    // Revert coordinate
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(frameSetter);
}

-(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
}
@end
