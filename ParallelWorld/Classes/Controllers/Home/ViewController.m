//
//  ViewController.m
//  ParallelWorld
//
//  Created by Joe.Pen on 6/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "ViewController.h"
#import "LineView.h"
#import "SnowView.h"
#import "IMYWebView.h"
#import "VPImageCropperViewController.h"
#import "PWBaseDataManager.h"

@interface ViewController ()
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
VPImageCropperDelegate
>
@property(strong,nonatomic)IMYWebView* webView;
@property (weak, nonatomic) IBOutlet LineView *circleView;
- (IBAction)valueChange:(id)sender;

- (IBAction)uploadAction:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.


//    self.webView = [[IMYWebView alloc] initWithFrame:self.view.bounds];
//    self.webView.backgroundColor = GRAYCOLOR;
//    [self.view addSubview:_webView];
//    
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    
//    CGSize size = CGSizeMake(PJ_SCREEN_WIDTH, 35);
//    UIGraphicsBeginImageContext(size);
//    
//    CGContextRef ctx  = UIGraphicsGetCurrentContext();
//    CGFloat height = 35;
//    CGContextAddRect(ctx, CGRectMake(0, 0, PJ_SCREEN_WIDTH, height));
//    [WHITECOLOR set];
//    CGContextFillPath(ctx);
//    
//    CGFloat lineWidth = 2;
//    CGFloat lineY = height - lineWidth;
//    CGFloat lineX = 0;
//    CGContextMoveToPoint(ctx, lineX, lineY);
//    CGContextAddLineToPoint(ctx, 320, lineY);
//    [[UIColor blackColor] set];
//    CGContextStrokePath(ctx);
    
//    UIImage *image=[UIImage imageNamed:@"share_icon"];
//    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
//    UIColor *color=[UIColor colorWithPatternImage:image];
//    self.view.backgroundColor=color;
//    SnowView* snowView = [(NSArray*)[[NSBundle mainBundle]loadNibNamed:@"SnowView" owner:self options:nil] objectAtIndex:0];
//    snowView.frame = self.view.bounds;
//    snowView.backgroundColor = WHITECOLOR;
//    [self.view addSubview:snowView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)valueChange:(UISlider*)sender
{
    //当值改变的时候，把值传递给view,改变圆的半径
    NSLog(@"%f",sender.value);
    //把sender的值传递给自定义view，设置圆的半径
    self.circleView.radius=sender.value;
}

- (IBAction)uploadAction:(id)sender
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([PUtils isCameraAvailable] && [PUtils doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([PUtils isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([PUtils isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [PUtils imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
//    headview.image = editedImage;
//    isFromServer = NO;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        NSString *path;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = paths[0];
        BOOL isDir;
        if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
            if(!isDir) {
                NSError *error;
                [[NSFileManager defaultManager] createDirectoryAtPath:[path stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error];
                NSLog(@"%@",error);
            }
        }
        
//        path = [path stringByAppendingPathComponent:@"head.jpg"];
//        NSData *imageData = UIImageJPEGRepresentation(editedImage,0.5);
        
        [PWBaseDataInstance uploadImages:@[editedImage] param:nil progress:nil success:^(id json) {
            NSLog(@"%@",[json description]);
        } failure:^{
            
        }];

    
        
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
