//
//  DemoViewController.m
//  WebViewDemo
//
//  Created by ShanCheli on 2017/11/29.
//  Copyright © 2017年 优客工场. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

/**
 *  设置  公共 cookie
 */
+ (void)setAppCookie {
    // 逻辑 cookie
    NSMutableDictionary *logicCookie = [NSMutableDictionary dictionaryWithCapacity:0];
    
//    [logicCookie setObject:APP_VERSION forKey:@"app_version"];
//    [logicCookie setObject:CurrentSystemVersion forKey:@"os_version"];
//    [logicCookie setObject:CurrentLanguage forKey:@"language"];
//    [logicCookie setObject:[[UIDevice currentDevice] yztl_deviceId] forKey:@"mac_id"];
    [logicCookie setObject:@"ios" forKey:@"plat"];
    
    for (NSString *key in logicCookie) {
        [DemoViewController setCookie:key value:[logicCookie objectForKey:key]];
    }
}

/**
 *  设置 cookie
 */
+ (void)setCookie:(NSString *)key value:(NSString *)value  {
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    
    [cookieDic setObject:key forKey:NSHTTPCookieName];
    [cookieDic setValue:value forKey:NSHTTPCookieValue];
    
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieDic];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
}


/*
 iOS提供了两个类，用于操作cookie：
 1. NSHTTPCookie  2. NSHTTPCookieStorage
 NSHTTPCookieStorage是一个单例，存储管理所有的cookie。一个NSHTTPCookie对象是一个cookie。可以理解为NSHTTPCookieStorage管理的目标就是NSHTTPCookie。
 */

// 1、第一次进入应用，登录获取Cookie，此时如果用到的是AFN去获取接口数据，Cookie已经写入了，所以无需处理，每次请求的时候，会自动将该cookie传给后台去验证

// 2、将Cookie缓存到本地：
- (void)saveCookies {
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"username" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"rainbird" forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"cnrainbird.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"cnrainbird.com" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey:@"Cookie"];
    [defaults synchronize];
}

// 3、当第二次进入应用的时候，先判断NSUserDefault是否有缓存的Cookie，如果有，需要将cookie写入，然后进入应用

- (void)setCookies {
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"]];
    NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie * cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
}

// 4、当用户选择退出登录，需要清除缓存中的cookie，同时要将NSUserDefault中的Cookie删除

- (void)removeCookies {
    
    // 清除请求头中的Cookie：
    NSHTTPCookieStorage *manager = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookieStorage) {
        [manager deleteCookie:cookie];
    }
    
    // 清除NSUserDefault中的Cookie
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Cookie"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
