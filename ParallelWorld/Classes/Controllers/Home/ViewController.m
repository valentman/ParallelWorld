//
//  ViewController.m
//  ParallelWorld
//
//  Created by Joe.Pen on 6/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "ViewController.h"
#import "ZLPhotoActionSheet.h"
#import "PWBaseDataManager.h"
#import "PWNetworkManager.h"
#import "AWVoiceRecorder.h"

@interface ViewController ()
{
    __block UIProgressView* progressView;
    AWVoiceRecorder* recorder;
    
    NSString *voiceFilePath;
}
@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;
@property (nonatomic, strong) NSArray *arrDataSources;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UITextField *addrTextField;
@property (weak, nonatomic) IBOutlet UILabel *progresslabel;

- (IBAction)uploadImageAction:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.center = self.view.center;
    [self.view addSubview:progressView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setProgressView:) name:@"progress" object:nil];
    
    recorder = [[AWVoiceRecorder alloc]init];
    voiceFilePath = [DocumentsDirectory stringByAppendingPathComponent:@"testaudio.m4a"];
    
    [self.recordBtn addTarget:self action:@selector(startRecordvoice:) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn addTarget:self action:@selector(stopRecordvoice:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)startRecordvoice:(id)sender
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:voiceFilePath];
    if (!isExists) {
        [fileManager createFileAtPath:voiceFilePath contents:nil attributes:nil];
    }
    
    [recorder prepareRecordingWithPath:voiceFilePath prepareRecorderCompletion:^BOOL{
        [recorder startRecordingWithStartRecorderCompletion:^{
            DLog(@"开始录音了");
        }];
        return YES;
    }];
}

- (void)stopRecordvoice:(id)sender
{
    weakify(self);
    [recorder stopRecordingWithStopRecorderCompletion:^{
        DLog(@"录音结束,时长：%@",recorder.recordDuration);
        [weakSelf uploadVoiceToServer];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)uploadVoiceToServer
{
    [self.view endEditing:YES];
    NSData* voiceData = [NSData dataWithContentsOfFile:voiceFilePath];
    
    [PWBaseDataInstance uploadVoice:voiceData param:nil progress:^(NSProgress *progress) {
        DLog(@"上传进度：%f",progress.fractionCompleted);
        DLog(@"total:%lld,upload:%lld,%.f%%",progress.totalUnitCount,progress.completedUnitCount,progress.fractionCompleted*100);
    } success:^(id json) {
        DLog(@"上传成功：%@",[json description]);
    } failure:^{
        DLog(@"上传失败");
    }];
}


- (IBAction)uploadImageAction:(id)sender
{
    [self.view endEditing:YES];
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 5;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 20;
    
    weakify(self);
    
    
    [actionSheet showWithSender:self animate:YES lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
        strongify(weakSelf);
        strongSelf.arrDataSources = selectPhotos;
        strongSelf.lastSelectMoldels = selectPhotoModels;
        
        [PWBaseDataInstance uploadImages:self.arrDataSources param:nil progress:^(NSProgress *progress){
            [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
            DLog(@"desc:%@, total:%lld, upload:%lld",progress.localizedDescription,progress.totalUnitCount,progress.completedUnitCount);
        } success:^(id json) {
            DLog(@"%@",[json description]);
        } failure:^{
            DLog(@"上传失败");
        }];
    }];
}


- (void)setProgressView:(NSNotification*)notif
{
    NSDictionary* dict = notif.userInfo;
    float pro = [[dict valueForKey:@"pro"] floatValue];
    DLog(@"%f",pro);
    [progressView setProgress:pro];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context

{
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]])
    {
//        NSProgress *progress = (NSProgress *)object;
//        self.progresslabel.text = progress.localizedDescription;
//        progressView.progress = progress.fractionCompleted;
    }
    
}

@end
