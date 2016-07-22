//
//  PUtils.m
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#include <objc/runtime.h>
#import "PUtils.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <AVFoundation/AVFoundation.h>

@interface PUtils ()<UIAlertViewDelegate>

@end

@implementation PUtils
#pragma mark Zhouxin
#pragma mark- 数据解析
+ (NSDictionary*)DataFromJson:(id)json {
    
    NSDictionary *DataDic = [NSJSONSerialization JSONObjectWithData:json
                                                            options:NSJSONReadingMutableLeaves
                                                              error:nil];
    return DataDic;
}

+ (NSArray*)ArrayFromJson:(id)json {
    
    NSArray *DataDic = [NSJSONSerialization JSONObjectWithData:json
                                                            options:NSJSONReadingMutableLeaves
                                                              error:nil];
    return DataDic;
}

+ (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
}

+ (NSString*)JsonFromData:(id)data
{
    NSString *jsonString = nil;
    NSData *jsonData = [PUtils JsonFormData:data];
    if (!jsonData) {
        NSLog(@"Got an error");
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        DLog(@"jsonString:%@",jsonString);
    }
    return jsonString;
}

+ (NSData*)JsonFormData:(id)data{
    
    NSError* error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    return jsonData;
}


#pragma mark /*数据持久化
#pragma mark NSData数据的持久化
+ (BOOL)saveNSDataToLocal:(NSData*)data{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [cacheDir stringByAppendingPathComponent:@"history"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path];
    if (!isExists) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    NSLog(@"%@",path);
    if ([data writeToFile:path atomically:YES]) {
        return YES;
    }
    return NO;
}

+ (BOOL)saveDataToLocal:(NSString*)str{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [cacheDir stringByAppendingPathComponent:@"history"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path];
    if (!isExists) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    NSData *resultData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",path);
    if ([resultData writeToFile:path atomically:YES]) {
        return YES;
    }
    return NO;
}

+ (NSData*)readDataFromLocal{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [cacheDir stringByAppendingPathComponent:@"history"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path];
    if (isExists) {
        NSData* data=[NSData dataWithContentsOfFile:path options:0 error:NULL];
        return data;
    }
    return nil;
}


#pragma mark NSMutableArray数据的持久化
+ (BOOL)writeArrayToDocumentsDirectory:(NSMutableArray*)array withPlistName:(NSString*)plistName{
    NSString *plistPath = [DocumentsDirectory stringByAppendingPathComponent:plistName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    if (!isExists) {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    return [array writeToFile:plistPath atomically:YES];
}

+ (NSMutableArray*)readArrayFromDocumentsDirectoryWithName:(NSString*)plistName
{
    NSString *plistPath = [DocumentsDirectory stringByAppendingPathComponent:plistName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    NSMutableArray* array = [NSMutableArray array];
    if (isExists) {
        array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    return array;
}

+ (NSMutableArray*)readArrayFromBundleDirectoryWithName:(NSString*)plistName
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    NSMutableArray* array = [NSMutableArray array];
    if (isExists) {
        array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    return array;
}


#pragma mark 把可变字典数据的持久化
+ (BOOL)writeDictionaryToDocumentsDirectory:(NSMutableDictionary*)dict withPlistName:(NSString*)plistName
{
    NSError *error;
    NSString *plistPath = [DocumentsDirectory stringByAppendingPathComponent:plistName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    if (!isExists) {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:dict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                                  options:NSPropertyListMutableContainersAndLeaves
                                                                    error:&error];
    if(plistData) {
        return [plistData writeToFile:plistPath atomically:YES];
    }
    return NO;
}

+ (NSMutableDictionary*)readDictionaryFromDocumentsDirectoryWithPlistName:(NSString*)plistName
{
    NSError *error;
    NSPropertyListFormat format;
    NSString *plistPath = [DocumentsDirectory stringByAppendingPathComponent:plistName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    if (isExists) {
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSMutableDictionary* dic =[NSPropertyListSerialization propertyListWithData:plistXML
                                                                            options:NSPropertyListMutableContainersAndLeaves
                                                                             format:&format
                                                                              error:&error];
        return dic;
    }
    return nil;
}

+ (NSMutableDictionary*)readDictionaryFromBundleDirectoryWithPlistName:(NSString*)plistName
{
    NSError *error;
    NSPropertyListFormat format;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    if (isExists) {
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSMutableDictionary* dic =[NSPropertyListSerialization propertyListWithData:plistXML
                                                                            options:NSPropertyListMutableContainersAndLeaves
                                                                             format:&format
                                                                              error:&error];
        return dic;
    }
    return nil;
}


#pragma mark 正则判断

+ (BOOL)isCarNumberPlate:(NSString*)carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    BOOL isMatched = [carNo isMatchedByRegex:carRegex];
    return isMatched;
}

+ (BOOL)isLicencePlate:(NSString *)plateNum{
    NSString* PhoneNum = @"^[A-Z0-9]{5}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PhoneNum];
    if ([regextestmobile evaluateWithObject:plateNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isPhoneNumber:(NSString *)mobileNum{
    NSString* PhoneNum = @"^\\d{11}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PhoneNum];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    if (!mobileNum) {
        return NO;
    }
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,187,183,184,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,153,177,180,181,189
     * 最新号段：145、147、170、176、178
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|4[57]|7[068])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,187,183,184,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0217-9]|8[2-478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,153,177,180,181,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\\\d{3})\\\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark UI组件设置
+( UIColor *) getColorFromString:( NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range. length = 2 ;
    range. location = 0 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&red];
    range. location = 2 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&green];
    range. location = 4 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&blue];
    return [ UIColor colorWithRed :( float )(red/ 255.0f ) green :( float )(green/ 255.0f ) blue :( float )(blue/ 255.0f ) alpha : 1.0f ];
}

+ (void)setSepratorColorforTableView:(UITableView *)tableView{
    tableView.separatorColor = RGBA(230.0f, 230.0f, 230.0f, 1.0f);
}

+ (void)setExtraCellLineHidden: (UITableView *)tableView{
    tableView.separatorColor = RGBA(230.0f, 230.0f, 230.0f, 1.0f);
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0];
    
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}


void backLastView(id sender, SEL _cmd)
{
    [((UIViewController*)sender).navigationController popViewControllerAnimated:YES];
}

+ (void)customizeNavigationBarForTarget:(UIViewController*)target
{
    [self customizeNavigationBarForTarget:target hiddenButton:false];
}

+ (void)customizeNavigationBarForTarget:(UIViewController *)target hiddenButton:(BOOL)hidden
{
    SEL backToLastView = sel_registerName("backLastView:");
    class_addMethod([target class],backToLastView,(IMP)backLastView,"v@:");    //动态的给类添加一个方法
    
    //UIButton
    UIButton *leftBtn = [[ UIButton alloc ] initWithFrame : CGRectMake(- 20 , 0 , 44 , 44 )];
    [leftBtn setBackgroundImage:[UIImage imageNamed:(hidden? @"all_arrow_backwhite" : @"prodetail_btn_backnor")] forState:UIControlStateNormal];
    [leftBtn addTarget:target action:backToLastView forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; //将leftItem设置为自定义按钮
    
    //UIBarButtonItem
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithCustomView: leftBtn];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 20 : 0))
    {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -20 ;//这个数值可以根据情况自由变化
        target.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
        
    } else
    {
        target.navigationItem.leftBarButtonItem = leftItem;
    }
    target.navigationController.interactivePopGestureRecognizer.delegate = (id)target;
}


+ (void)fullScreenGestureRecognizeForTarget:(UIViewController*)currenTarget
{
    UIGestureRecognizer* gesture = currenTarget.navigationController.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView* gestureView = gesture.view;
    
    NSMutableArray* _targets = [gesture valueForKey:@"_targets"];
    id gestureRecogizerTarget = [_targets firstObject];
    id navigationInteractiveTransition = [gestureRecogizerTarget valueForKey:@"_target"];
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:navigationInteractiveTransition action:handleTransition];
    [gestureView addGestureRecognizer:pan];
}


#pragma mark Frames
+ (float)xSizeScale{
    
    return PJ_SCREEN_WIDTH/320;
    
}

+ (float)ySizeScale{
    return PJ_SCREEN_HEIGHT / 568;
}

+ (CGRect)TCGRectMake:(CGRect)crt{
    CGRect rect;
    rect.origin.x = crt.origin.x * [PUtils xSizeScale];
    rect.origin.y = crt.origin.y * [PUtils ySizeScale];
    rect.size.width = crt.size.width * [PUtils xSizeScale];
    rect.size.height= crt.size.height* [PUtils ySizeScale];
    return rect;
}


#pragma mark 提示框
+(void)tipWithText:(NSString *)text onView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 20.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud setYOffset:PJ_SCREEN_HEIGHT/4];
    [hud hide:YES afterDelay:1.5];
}

+(void)tipWithText:(NSString *)text andView:(UIView *)view
{
    [PUtils tipWithText:text withCompeletHandler:nil];
}

+ (void)tipWithText:(NSString*)text withCompeletHandler:(GeneralBlockHandler)compeletBlock
{
    AppDelegate* mydelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mydelegate.window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 20.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud setYOffset:PJ_SCREEN_HEIGHT/4];
    [hud hide:YES afterDelay:1.5];
    hud.completionBlock = compeletBlock;
}

+ (UIView*)showInfoCanvasOnTarget:(id)target action:(SEL)buttonSel{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, (PJ_SCREEN_HEIGHT-100)/2, PJ_SCREEN_WIDTH, 200)];
    
    UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_icon_noweb.png"]];
    image.frame = CGRectMake((PJ_SCREEN_WIDTH - 60)/2,0, 60, 60);
    [view addSubview:image];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, PJ_SCREEN_WIDTH, 24)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:14];
    lab.textColor = RGBA(51, 51, 51, 1);
    lab.text = @"网络异常，请确认当前网络是否连接";
    [view addSubview:lab];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((PJ_SCREEN_WIDTH - 60)/2, 104, 60, 44)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    [button setTitleColor:RGBA(255, 0, 0, 255) forState:UIControlStateNormal];
    [button addTarget:target action:buttonSel forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return view;
}




#pragma mark- PJoe
#pragma mark 字符串处理

+ (BOOL)isBlankString:(NSString *)string
{
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


+ (NSString*)cutString:(NSString*)str Prefix:(NSString*)pre
{
    NSRange range = [str rangeOfString:pre];
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" :-''""{}"];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString* ns2 = [str stringByTrimmingCharactersInSet:set];
    return [ns2 substringWithRange:NSMakeRange(range.location+range.length, ([ns2 length]-(range.location+range.length)))];
}

+ (NSString*)resetString:(NSString*)str
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" :-'''"""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* ns2 = [str stringByTrimmingCharactersInSet:set];
    return ns2;
}

+ (CGSize)calculateTitleSizeWithString:(NSString *)string AndFontSize:(CGFloat)fontSize
{
    return [self calculateStringSizeWithString:string Font:SYSTEMFONT(fontSize) Width:280];
}

+ (CGSize)calculateTitleSizeWithString:(NSString *)string WithFont:(UIFont*)font
{
    return [self calculateStringSizeWithString:string Font:font Width:280];
}

+ (CGSize)calculateStringSizeWithString:(NSString*)string Font:(UIFont*)font Width:(CGFloat)width
{
    NSDictionary *dic = @{NSFontAttributeName: font};
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

+ (NSMutableAttributedString*)stringWithDeleteLine:(NSString*)string
{
    NSUInteger length = [string length];
    if (0 == length) {
        return nil;
    }
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, length)];
    return attri;
}


#pragma mark 界面控制器处理
+ (UIViewController*)getViewControllerFromStoryboard:(NSString*)storyboardName andVCName:(NSString*)vcName
{
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    return [story instantiateViewControllerWithIdentifier:vcName];
}

+ (UIViewController*)getViewControllerInUINavigator:(UINavigationController*)navi withClass:(Class)_class
{
    UIViewController* vc;
    for (vc in navi.viewControllers)
    {
        if ([vc isKindOfClass:_class])
        {
            break;
        }
    }
    return vc;
}

+ (id)getXibViewByName:(NSString*)xibName
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:xibName owner:self options:nil];
    return [nib objectAtIndex:0];
}









+ (BOOL)isTimeCrossMinInterval:(int)intervalTimer withIdentity:(NSString*)userDefault
{
    UInt64 currentTime = [[NSDate date] timeIntervalSince1970];     //当前时间
    UInt64 lastUpdateTime = [[USER_DEFAULT valueForKey:userDefault] longLongValue];   //上次更新时间
    UInt64 intervalTime = currentTime - lastUpdateTime;
    if (0 == lastUpdateTime ||
        intervalTime > intervalTimer*60)
    {
        [USER_DEFAULT setValue:[NSString stringWithFormat:@"%llu",currentTime] forKey:userDefault];
        return YES;
    }
    return NO;
}

//+ (FSDateTime*)getLeftDatetime:(NSInteger)timeStamp
//{
//    FSDateTime* dateTime = [[FSDateTime alloc]init];
//    NSInteger ms = timeStamp;
//    NSInteger ss = 1;
//    NSInteger mi = ss * 60;
//    NSInteger hh = mi * 60;
//    NSInteger dd = hh * 24;
//    
//    // 剩余的
//    NSInteger day = ms / dd;// 天
//    NSInteger hour = (ms - day * dd) / hh;// 时
//    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
//    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
//    NSString* hourStr = [NSString stringWithFormat:@"%ld", hour];
//    if (hour < 10)
//    {
//        hourStr =[NSString stringWithFormat:@"0%ld", hour];
//    }
//    
//    NSString* minutesStr = [NSString stringWithFormat:@"%ld", minute];
//    if (minute < 10)
//    {
//        minutesStr = [NSString stringWithFormat:@"0%ld", minute];
//    }
//    
//    NSString* secondStr = [NSString stringWithFormat:@"%ld", second];
//    if (second < 10)
//    {
//        secondStr = [NSString stringWithFormat:@"0%ld", second];
//    }
//    
//    dateTime.day = [NSString stringWithFormat:@"%ld", day];
//    dateTime.hour = hourStr;
//    dateTime.minute = minutesStr;
//    dateTime.second = secondStr;
//    return dateTime;
//}

+ (NSString*)getCurrentHourTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}


+ (NSString*)getCurrentDateTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (NSString*)getFullDateTime:(NSInteger)time
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:time]];
    return dateTime;
}

//+ (NSString*)getChatDatetime:(NSInteger)chatTime
//{
//    NSInteger timeInterval;
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"HH:mm"];
//    if(chatTime > 140000000000) {
//        timeInterval = chatTime / 1000;
//    }
//    NSString* dateTime = [[NSDate dateWithTimeIntervalSince1970:timeInterval] formattedTime];
//    return dateTime;
//}

+ (NSString*)getDateTimeSinceTime:(NSInteger)skillTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate:skillTime];
    NSString* dateTime = [formatter stringFromDate:date];
    return dateTime;
}

+ (void)printClassMethodList:(id)target
{
    Class currentClass=[target class];
    while (currentClass) {
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(currentClass, &methodCount);
        unsigned int i = 0;
        for (; i < methodCount; i++) {
            NSLog(@"%@ - %@", [NSString stringWithCString:class_getName(currentClass) encoding:NSUTF8StringEncoding], [NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding]);
        }
        
        free(methodList);
        currentClass = class_getSuperclass(currentClass);
    }
}

+ (void)printClassMemberVarible:(id)target
{
    unsigned int count = 0;
    Ivar* var = class_copyIvarList([target class], &count);
    for (int i = 0; i < count; i++)
    {
        Ivar _var = *(var + i);
        DLog(@"%s, %s",ivar_getTypeEncoding(_var), ivar_getName(_var));
    }
}

+ (void)performBlock:(GeneralBlockHandler)block afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

+ (void)callHotLine:(NSString*)phoneNum AndTarget:(id)target
{
    /*  第一种调用拨打电话的方式
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [target addSubview:callWebview];
     */
    if ([self isCanSIMCardAvaiable])
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

+ (CATextLayer *)creatTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point andNumOfMenu:(int)_numOfMenu
{
    
    CGSize size = [self calculateTitleSizeWithString:string AndFontSize:15];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (PJ_SCREEN_WIDTH / _numOfMenu) - 25) ? size.width : PJ_SCREEN_WIDTH / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 15.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}


+ (CAShapeLayer *)creatIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

/**
 * @margin
 * @viewSize
 * @index
 * @divide
 */
+ (CGRect)viewFramFromDynamic:(CZJMargin)margin size:(CGSize)viewSize index:(int)index divide:(int)divide
{
    // 列数
    int column = index%divide;
    // 行数
    int row = index/divide;
    // 动态调整中间间距
    CGFloat horiMiddleMargin = (PJ_SCREEN_WIDTH - divide*viewSize.width - 2*margin.horisideMargin) / (divide-1);
    if (horiMiddleMargin > 15)
    {
        horiMiddleMargin = 15;
    }
    
    // 很据列数和行数算出x、y
    int childX = column * (viewSize.width + horiMiddleMargin);
    int childY = row * (viewSize.height + margin.vertiMiddleMargin);
    CGRect rect = CGRectMake(childX + margin.horisideMargin, childY + margin.vertiMiddleMargin, viewSize.width, viewSize.height);
    return rect;
}

/**
 * @margin
 * @viewSize
 * @index
 * @divide
 * @筛选界面专用，没有间距限制
 */
+ (CGRect)viewFrameFromDynamic:(CZJMargin)margin
                          size:(CGSize)viewSize
                         index:(int)index
                        divide:(int)divide
                      subWidth:(int)width
{
    // 列数
    int column = index%divide;
    // 行数
    int row = index/divide;
    // 动态调整中间间距
    CGFloat horiMiddleMargin = (PJ_SCREEN_WIDTH - width - divide*viewSize.width - 2*margin.horisideMargin) / (divide-1);
    // 很据列数和行数算出x、y
    int childX = column * (viewSize.width + horiMiddleMargin);
    int childY = row * (viewSize.height + margin.vertiMiddleMargin);
    CGRect rect = CGRectMake(childX + margin.horisideMargin, childY + margin.vertiMiddleMargin, viewSize.width, viewSize.height);
    return rect;
}


#pragma mark - Camera Utility
+ (BOOL) isCameraAvailable:(UIViewController *)base
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的相机功能好像有问题哦~\n去\"设置>隐私>相机\"开启一下吧" delegate:base cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    return YES;
}

+ (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


#pragma mark UIImage Scale Utility
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



+ (void)downloadImageWithURL:(NSString*)imgUrl
                 andFileName:(NSString*)imgName
                 withSuccess:(GeneralBlockHandler)success
                     andFail:(GeneralBlockHandler)fail
{
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        DLog(@"receivedSize:%ld, expectedSize:%ld",receivedSize,expectedSize);
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
        NSString* imagepath2 = [DocumentsDirectory stringByAppendingPathComponent:imgName];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        if ([UIImageJPEGRepresentation(image,0) writeToFile:imagepath2 atomically:YES])
        {
            if (success)
            {
                success();
            }
        }
        else
        {
            if (fail)
            {
                fail();
            }
        }
        
    }];
}


//计算单个文件大小返回值是M
+ (float)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        // 返回值是字节 B K M
        return size/1024.0/1024.0;
    }
    return 0;
}

//计算目录大小
+ (float)folderSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 计算单个文件大小
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
         folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

//清理缓存文件
//同样也是利用NSFileManager API进行文件操作，SDWebImage框架自己实现了清理缓存操作，我们可以直接调用
+ (void)clearFile:(NSString *)path andSuccess:(GeneralBlockHandler)success
{
    BACK(^{
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            NSArray *childerFiles=[fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles) {
                //如有需要，加入条件，过滤掉不想删除的文件
                NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
        // SDImageCache 自带缓存
        [[SDImageCache sharedImageCache] cleanDisk];
        MAIN(success);
    });
}

+ (void)clearCache:(GeneralBlockHandler)success
{
    [self clearFile:CachesDirectory andSuccess:success];
}


+ (NSMutableArray*)getAggregationArrayFromArray:(NSArray*)sourcArray
{
    NSMutableArray* destArray = [NSMutableArray array];
    float count = (float)sourcArray.count;
    float count2 = ceilf(count/2);
    [destArray removeAllObjects];
    for (int i  = 0; i < count2; i++)
    {
        NSMutableArray* array = [NSMutableArray array];
        [destArray addObject:array];
    }
    for (int i = 0; i < count; i++) {
        int index = i / 2;
        [destArray[index] addObject:sourcArray[i]];
    }
    return destArray;
}



+ (NSString*)getCurrentVersion
{
    //获取bundle里面关于当前版本的信息
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"nowVersion == %@",nowVersion);
    return nowVersion;
}



+ (BOOL)isCanSIMCardAvaiable
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    if (!carrier.isoCountryCode) {
        [self tipWithText:@"未安装SIM卡" andView:nil];
        return NO;
    }
    return YES;
}

@end
