//
//  AppDelegate.m
//  Word
//
//  Created by Charles Cao on 2018/1/15.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "LGUserManager.h"
#import "LGRequest.h"
#import "IFlyMSC/IFlyMSC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate () <JPUSHRegisterDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
    
	self.window.backgroundColor = [UIColor whiteColor];
    [self updateSessionForDidFinishLaunching];
	[self configJPush:launchOptions];
	[self configIQkeyboard];
	[self configIFly];
    [self configShareSDK];
    [self configUI];
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	[self.vodplayer resetAudioPlayer];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
	if (self.allowRotation == YES) {
		return UIInterfaceOrientationMaskLandscapeRight;
	}else{
		return (UIInterfaceOrientationMaskPortrait);
	}
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
	// Required - 注册 DeviceToken
	[JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){

	if (@available(iOS 10.0, *)) {
	// Required
	NSDictionary * userInfo = notification.request.content.userInfo;
	if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
		[JPUSHService handleRemoteNotification:userInfo];
	}
	completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
	}
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
	// Required
	if (@available(iOS 10.0, *)) {
	NSDictionary * userInfo = response.notification.request.content.userInfo;
	if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
		[JPUSHService handleRemoteNotification:userInfo];
	}
	completionHandler();  // 系统要求执行这个方法
	}
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	
	// Required, iOS 7 Support
	[JPUSHService handleRemoteNotification:userInfo];
	completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
	// Required,For systems with less than or equal to iOS6
	[JPUSHService handleRemoteNotification:userInfo];
}

/**
 极光推送
 */
- (void)configJPush:(NSDictionary *)launchOptions{
	
	/*********************** apns **************************/
	
	JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
	entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
		// 可以添加自定义categories
		// NSSet<UNNotificationCategory *> *categories for iOS10 or later
		// NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
	}
	[JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
	
	/*********************** jpush **************************/
	
	// init Push
	// notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
	// 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
	
	BOOL isProduction = YES;
#ifdef DEBUG
	isProduction = NO;
#endif
	
	[JPUSHService setupWithOption:launchOptions appKey:@"7f2a83b1b3c73aa39b68943d"
						  channel:@"APP Store"
				 apsForProduction:isProduction
			advertisingIdentifier:nil];
	
}

/**
 键盘
 */
- (void)configIQkeyboard {
	IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
	manager.enable = YES;
	manager.enableAutoToolbar = NO;
	manager.shouldResignOnTouchOutside = YES;
}


/**
 讯飞语音
 */
- (void)configIFly{
	//Set log level
	[IFlySetting setLogFile:LVL_NONE];
	
	//Set whether to output log messages in Xcode console
#ifdef DEBUG
	//暂时不需要日志,调试语音的时候在打开
	[IFlySetting showLogcat:NO];
#else
	[IFlySetting showLogcat:NO];
#endif
	//Set APPID
	[IFlySpeechUtility createUtility:@"appid=5ad6dd9c"];
}


/**
 ShareSDK
 */
- (void)configShareSDK{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ]
        onImport:^(SSDKPlatformType platformType){
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo){
         switch (platformType){
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx43edda5db10ec254"
                                       appSecret:@"9d9423bcf1f9c6b60a65a0dc999af53b"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106849252"
                                      appKey:@"wwsrzVVzDzKDcO6H"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

//启动时更新session
- (void)updateSessionForDidFinishLaunching{
    LGUserModel *userModel = [LGUserManager shareManager].user;
    if (userModel) {
        [self.request updateSessionForFinishLaunching:[userModel mj_keyValues]];
    }
}

//配置一些UI统一样式
- (void)configUI{
    //tabbaritem 选中时标题为白色颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
}

@end
