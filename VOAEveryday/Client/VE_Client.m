//
//  VE_Client.m
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_Client.h"
#import "VE_RequestTool.h"

#import <dlfcn.h>
#import <sys/types.h>

#import <AFNetworking/AFNetworking.h>
#import <UMCPush/UMPush/UMessage.h>
#import <Xor_t/Encrypt.h>

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);

#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif

CGFloat topSafeAera = 0;
CGFloat bottomSafeAera = 0;

UIColor *yellowColor = NULL;
UIColor *lightColor = NULL;
UIColor *darkColor = NULL;
UIColor *pinkColor = NULL;

NSArray *documentArr = NULL;
//void uploadUserIdentify(void(^success)(NSString *sign), void(^fail)(NSUInteger flag));
//void uploadDeviceIdentify(void(^success)(NSString *sign), void(^fail)(NSUInteger flag));


void appSetup(NSDictionary *option) {
    RouterStart;
    
//    [Router registerWebviewController:@"WebViewController"];
    
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    
    UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
    UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
    UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    NSSet *categories = [NSSet setWithObjects:category1_ios10, nil];
    entity.categories=categories;
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = (id <UNUserNotificationCenterDelegate>)[UIApplication sharedApplication].delegate;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:option Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
    [UMessage setBadgeClear:YES];
    
    NSMutableArray *models = [NSMutableArray array];
    NSArray *datas = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"]];
    for (NSDictionary *dic in datas) {
        NSString *title = dic[@"title"];
        NSMutableArray *arts = [NSMutableArray array];
        for (NSDictionary *x in dic[@"list"]) {
            VE_ArticalModel *model = [VE_ArticalModel title:x[@"title"] url:x[@"url"]];
            [arts addObject:model];
        }
        VE_DocumentModel *model = [[VE_DocumentModel alloc]init];
        model.title = title;
        model.list = arts;
        
        [models addObject:model];
    }
    documentArr = models;
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@((int)[[NSDate date] timeIntervalSince1970]) forKey:@"needGuide"];
//    [defaults setObject:@"Iphone" forKey:@"sign"];//23
    topSafeAera = ([[UIApplication sharedApplication] statusBarFrame].size.height > 20.0 ? 88.0 : 64.0);
    bottomSafeAera = ([[UIApplication sharedApplication] statusBarFrame].size.height > 20.0 ? 34.0 : 0.0);
    
    yellowColor = [UIColor qmui_colorWithHexString:@"FFDA47"];
    lightColor = [UIColor qmui_colorWithHexString:@"F2F3F4"];
    darkColor = [UIColor qmui_colorWithHexString:@"404040"];
    pinkColor = [UIColor qmui_colorWithHexString:@"FF5E5E"];
}

void loadDatas(void(^success)(void), void(^fail)(void)) {
    
    NSMutableArray *models = [NSMutableArray array];
    
    NSArray *datas = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"]];
    
    for (NSDictionary *dic in datas) {
        NSString *title = dic[@"title"];
        NSMutableArray *arts = [NSMutableArray array];
        for (NSDictionary *x in dic[@"list"]) {
            VE_ArticalModel *model = [VE_ArticalModel title:x[@"title"] url:x[@"url"]];
            [arts addObject:model];
        }
        VE_DocumentModel *model = [[VE_DocumentModel alloc]init];
        model.title = title;
        model.list = arts;
        
        [models addObject:model];
    }
    
    documentArr = models;
    if (documentArr.count) {
        success();
    }else{
        fail();
    }
}

void loadArticals(NSString *url, void(^success)(NSArray<VE_ArticalModel *> *arr), void(^fail)(void)) {
    NSArray *models = [[VE_RequestTool shareTool] loadArtical:url];
    if (models.count) {
        success(models);
    }else{
        fail();
    }
}

void loadNormalContent(NSString *url, void(^success)(VE_NormalContentModel * model), void(^fail)(void)) {
    [[VE_RequestTool shareTool] loadNormalContent:url success:success fail:fail];
}
void loadVideoContent(NSString *url, void(^success)(VE_VideoContentModel * model), void(^fail)(void)) {
    [[VE_RequestTool shareTool] loadVideoContent:url success:success fail:fail];
}

UIViewController * rootVC(void) {
    return [Router search:ROUTER_API(@"SplVC")];
}


void safeDisable(void) {
    void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);
}
//
//void makeSign(NSString *data, void(^success)(NSString *sign), void(^fail)(NSUInteger flag)) {
//    
//    NSInteger count = 0;
//    
//    if ([data containsString:@"=="]) {
//        count = 2;
//        data = [data substringToIndex:data.length - count];
//    }else{
//        count = 1;
//        data = [data substringToIndex:data.length - count];
//    }
//    
//    NSMutableString *tempData = [NSMutableString string];
//    for (int i = 0; i < data.length; i++) {
//        if (i % 2 == 0) {
//            [tempData appendString:[data substringWithRange:NSMakeRange(i, 1)]];
//        }
//    }
//    
//    NSMutableString *tempData2 = [NSMutableString string];
//    for (int i = 0; i < count; i ++) {
//        [tempData2 appendString:@"="];
//    }
//    
//    for (int i = 0; i < tempData.length; i++) {
//        [tempData2 insertString:[tempData substringWithRange:NSMakeRange(i, 1)] atIndex:0];
//    }
//    
//    
//    
//    NSString *sign = [[NSString alloc]initWithData:[[NSData alloc]initWithBase64EncodedString:tempData2 options:0] encoding:NSUTF8StringEncoding];
//    
//    if (sign.length >= 6) {
//        sign = [sign substringWithRange:NSMakeRange(2, sign.length-6)];
//        
//        NSData *final = [sign dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *err;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:final options:NSJSONReadingMutableContainers error:&err];
//        if(err) {
//            fail(3);
//        }else{
//            NSInteger swi = [dic[@"swi"] integerValue];
//            NSInteger online = [dic[@"is_online"] integerValue];
//            if (swi == 0 && online == 0) {
//                success([NSString stringWithFormat:@"%@", dic[@"WebUrl"]]);
//            }else{
//                fail(1);
//            }
//        }
//    }else{
//        fail(3);
//    }
//}
//
//void loadData(NSString *url, void(^success)(NSString *sign), void(^fail)(NSUInteger flag)) {
//    //开关没开 1
//    //解析错误 3
//    //没网 2
//    //成功
//    uploadUserIdentify(success, fail);
//}
//
//
//void uploadUserIdentify(void(^success)(NSString *sign), void(^fail)(NSUInteger flag)) {
//    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil, nil];
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 8.f;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    
//    [manager GET:decode(userIdentify) parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if ([[NSString stringWithFormat:@"%@", responseObject[@"Code"]] isEqualToString:@"1111"]) {
//            makeSign([NSString stringWithFormat:@"%@", responseObject[@"Data"]], success, fail);
//        }else if ([[NSString stringWithFormat:@"%@", responseObject[@"Code"]] isEqualToString:@"1003"]){
//            fail(1);
//        }else{
//            uploadDeviceIdentify(success, fail);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        uploadDeviceIdentify(success, fail);
//    }];
//    
//}
//
//void uploadDeviceIdentify(void(^success)(NSString *sign), void(^fail)(NSUInteger flag)) {
//    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil, nil];
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 8.f;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    
//    [manager GET:decode(userIdentify) parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if ([[NSString stringWithFormat:@"%@", responseObject[@"Code"]] isEqualToString:@"1111"]) {
//            makeSign([NSString stringWithFormat:@"%@", responseObject[@"Data"]], success, fail);
//        }else if ([[NSString stringWithFormat:@"%@", responseObject[@"Code"]] isEqualToString:@"1003"]){
//            fail(1);
//        }else{
//            uploadUserIdentify(success, fail);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        fail(2);
//    }];
//}



