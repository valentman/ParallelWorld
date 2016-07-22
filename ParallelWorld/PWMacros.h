//
//  PWMacros.h
//  ParallelWorld
//
//  Created by Joe.Pen on 6/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#ifndef PWMacros_h
#define PWMacros_h

//-------------------------系统---------------------------
//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IOS7 (IOS_VERSION >= 7.0)
#define IS_IOS8 (IOS_VERSION >= 8.0)
#define IS_IOS9 (IOS_VERSION >= 9.0)
#define _IPHONE80_ 80000

#define PWAppdelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否iphone 5、iphone6、iphone6plus、是否是iPad
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
(CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) || \
CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size)) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define Divide ((iPhone5 || iPhone4) ? 3 : 4)

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//应用程序的名字
#define AppDisplayName              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

//当前语言
#define CURRENTLANGUAGE           ([[NSLocale preferredLanguages] objectAtIndex:0])


//-------------------获取设备系统数据----------------------
//获取屏幕 宽度、高度、宽高比
#define PJ_SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define PJ_SCREEN_WIDTH  PJ_SCREEN_BOUNDS.size.width
#define PJ_SCREEN_HEIGHT PJ_SCREEN_BOUNDS.size.height
#define PJ_SCREEN_ASPECTRATIO PJ_SCREEN_WIDTH/PJ_SCREEN_HEIGHT
#define ORIGINAL_MAX_WIDTH 640.0f
#define ZERORECT CGRectMake(0, 0, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT)

#define VERTICALSHOWRECT(height) CGRectMake(0, PJ_SCREEN_HEIGHT - height, PJ_SCREEN_WIDTH, height)
#define VERTICALHIDERECT(height) CGRectMake(0, PJ_SCREEN_HEIGHT, PJ_SCREEN_WIDTH, height)
#define HORIZONSHOWRECT(width) CGRectMake(PJ_SCREEN_WIDTH - width, 0, width, PJ_SCREEN_HEIGHT)
#define HORIZONHIDERECT(width) CGRectMake(PJ_SCREEN_WIDTH, 0, width, PJ_SCREEN_HEIGHT)

#define ZEROVERTICALHIDERECT VERTICALHIDERECT(0)
#define ZEROHORIZONHIDERECT HORIZONSHOWRECT(0)

//NavBar高度
//ios7以上视图中包含状态栏预留的高度
#define kHeightInViewForStatus (IS_IOS7?20:0)
//状态条占的高度
#define StatusBar_HEIGHT (IS_IOS7?0:20)
//导航栏高度
#define NavigationBar_HEIGHT (IS_IOS7?64:44)
#define Tabbar_HEIGHT 49
//中英状态下键盘的高度
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)


//---------------获取设备系统缓存目录和文件目录---------------
#define CachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define FileManager [NSFileManager defaultManager]

//-------------------------内存----------------------------
//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }
#define SAFE_RELEASE(x) [x release];x=nil




//-------------------------图片-----------------------------
//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//加载图片
#define IMAGE(NAME,EXT) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
#define PNGIMAGE(NAME) IMAGE(NAME,@"png")
#define JPGIMAGE(NAME) IMAGE(NAME,@"jpg")
#define IMAGENAMED(NAME) [UIImage imageNamed:NAME]
#define DefaultPlaceHolderCircle IMAGENAMED(@"placeholder_circle")
#define DefaultPlaceHolderSquare IMAGENAMED(@"placeholder_square")
#define DefaultPlaceHolderSquarePlus IMAGENAMED(@"placeholder_squarePlus")
#define DefaultPlaceHolderRectangle IMAGENAMED(@"placeholder_rectangle")

//字体大小（常规/粗体）
#define BOLDSYSTEMFONT(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)     [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME,FONTSIZE)      [UIFont fontWithName:(NAME) size:(FONTSIZE)]



//------------------------颜色类-------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]
#define UIColorFromHEX(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
#define FORGROUND_COLOR RGB(242,236,231)

//清除背景色
#define CLEARCOLOR [UIColor clearColor]
#define WHITECOLOR [UIColor whiteColor]
#define BLACKCOLOR [UIColor blackColor]
#define BLUECOLOR  [UIColor blueColor]
#define REDCOLOR   [UIColor redColor]
#define GRAYCOLOR  [UIColor grayColor]
#define LIGHTGRAYCOLOR [UIColor lightGrayColor]

//本项目自定义颜色
#define PWBLUECOLOR RGB(44, 148, 255)
#define PWREDCOLOR RGB(251, 70, 78)
#define PWGRAYCOLOR RGB(180, 180, 180)
#define PWGREENCOLOR RGB(0, 204, 204)
#define PWTableViewBGColor RGB(240, 240, 240)
#define PWNAVIBARBGCOLOR RGB(247, 247, 247)
#define PWNAVIBARBGCOLORALPHA(a) UIColorFromHEX(0xF7F7F7,a)


//------------------------调试-------------------------
#ifdef DEBUG
//DEBUG模式下 打印日志,当前行
#define DLog(fmt, ...) NSLog((@"^_^%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

//DEBUG模式下 脱机打印日志
#define iLog(fmt, ...) [iConsole info:(@"%@\n" fmt),([NSString stringWithFormat:@"%s",__FUNCTION__]),##__VA_ARGS__];

//DEBUG模式下 打印日志，并弹出提示框
#define ULog(fmt, ...)  { DLog(fmt);UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show];}

//DEBUG模式下 判断条件打印日志，并弹出提示框
#define DCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
DLog(xx, ##__VA_ARGS__); \
} \
} ((void)0)

//DEBUG模式下，条件判断打印日志
#define PJAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)

//DEBUG模式下，条件判断打印日志,当前行 并弹出一个警告
#define PJAlertAssert(condition, xx, ...) { if ((condition)) { \
ULog(xx, ##__VA_ARGS__); \
} \
} ((void)0)

#else
#define DLog(...)
#define iLog(...)
#define ULog(...)
#define DCONDITIONLOG(condition, xx, ...) ((void)0)
#define PJAssert(condition, ...)
#define PJAlertAssert(condition, xx, ...) ((void)0)
#endif



//成对出现，显示一段程序运行时间
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"\n============>>>IntervalTime: %f", -[startTime timeIntervalSinceNow])


//-------------------------其他-----------------------------
//方正黑体简体字体定义
#define FZFONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

//定义一个API
#define APIURL                @"http://xxxxx/"

//登陆API
#define APILogin              [APIURL stringByAppendingString:@"Login"]

//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]

//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define APPLICATION [UIApplication sharedApplication]

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//TableViewCell分割线
#define HiddenCellSeparator UIEdgeInsetsMake(46, PJ_SCREEN_WIDTH, 0, 0);
#define IndentCellSeparator(num) UIEdgeInsetsMake(0, num, 0, num);

//视图锚点
#define CGPointMiddle CGPointMake(0.5, 0.5)
#define CGPointButtomMiddle CGPointMake(0.5,1.0)
#define CGPointButtomRight CGPointMake(1.0,1.0)
#define CGPointButtomLeft CGPointMake(0,1.0)
#define CGPointTopMiddle CGPointMake(0.5,0)
#define CGPointTopRight CGPointMake(1.0,0)
#define CGPointLeftMiddle CGPointMake(0,0.5)
#define CGPointRightMiddle CGPointMake(1.0,0.5)

//位置
#define CGPointPositionMiddle CGPointMake(PJ_SCREEN_WIDTH*0.5,PJ_SCREEN_HEIGHT*0.5)


//------------------------单例宏---------------------------
//@interface
#define singleton_interface(className) +(className*) shared##className;

//@implementation
#if __has_feature(objc_arc)

#define singleton_implementation(className)\
static className* _instance;\
\
+(id)allocWithZone:(struct _NSZone*)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+ (instancetype) shared##className \
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc]init];\
});\
return _instance;\
}\
\
- (id)copyWithZone:(NSZone*)zone\
{\
return _instance;\
}\

#else

#define singleton_implementation(className)\
static className* _instance;\
\
+(id)allocWithZone:(struct _NSZone*)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+ (instancetype) shared##className \
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc]init];\
});\
return _instance;\
}\
\
- (id)copyWithZone:(NSZone*)zone\
{\
return _instance;\
}\
\
- (oneway void)release { } \
- (id)retain { return self; } \
- (NSUInteger)retainCount { return 1;} \
- (id)autorelease { return self;}

#endif

#endif /* PWMacros_h */
