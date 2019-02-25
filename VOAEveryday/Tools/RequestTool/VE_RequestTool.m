//
//  VE_RequestTool.m
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_RequestTool.h"
#import "TFHpple.h"


@implementation VE_RequestTool

+ (VE_RequestTool *)shareTool{
    static VE_RequestTool *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[VE_RequestTool alloc] init];
        }
    });
    return manager;
}

- (NSArray<VE_DocumentModel *> *)loadDatas {
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:VoaEnglish]];
    
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *documentArr = [xpathParser searchWithXPathQuery:@"//div[@id='left_nav']"];
    
    NSMutableArray *dataArr = [NSMutableArray new];
    NSMutableArray *artical_arr = [NSMutableArray new];
    NSMutableArray *titleArr = [NSMutableArray new];
    NSMutableArray *listTitleArr = [NSMutableArray new];
    
    for (TFHppleElement *element in documentArr) {
        NSArray *TitleElementsArr = [element searchWithXPathQuery:@"//div[@class='left_nav_title']//a"];
        NSArray *ArticalElementsArr = [element searchWithXPathQuery:@"//ul"];
        for (TFHppleElement *TitleElement in TitleElementsArr) {
            [titleArr addObject:TitleElement.text];
            NSLog(@"%@", TitleElement.text);
        }
        [titleArr addObject:@"友情链接"];
        for (TFHppleElement *articalElement in ArticalElementsArr){
            NSArray *ListArr = [articalElement searchWithXPathQuery:@"//li//a"];
            [listTitleArr removeAllObjects];
            NSArray *arr = [NSArray new];
            for (TFHppleElement *listElement in ListArr) {
                VE_ArticalModel *model = [VE_ArticalModel title:listElement.text url:listElement.attributes[@"href"]];
                [listTitleArr addObject:model];
                arr = [NSArray arrayWithArray:listTitleArr];
                NSLog(@"{\"title\":\"%@\", \"url\":\"%@\"}", model.title, model.url);
            }
            [artical_arr addObject:arr];
        }
        if (titleArr.count == artical_arr.count) {
            for (int i = 0; i<titleArr.count; i++) {
                if (i == 4) {
                    break;
                }else{
                    VE_DocumentModel *model = [[VE_DocumentModel alloc]init];
                    
                    model.title = titleArr[i];
                    model.list = artical_arr[i];
                    [dataArr addObject:model];
                }
            }
        }
    }
    return dataArr;
}

- (NSArray<VE_ArticalModel *> *)loadArtical:(NSString *)url {
    NSMutableArray *arr = [NSMutableArray new];
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    
    NSArray *mp3Arr = [xpathParser searchWithXPathQuery:@"//div[@id='list']"];
    
    for (TFHppleElement *element in mp3Arr) {
        NSArray *LiElementsArr = [element searchWithXPathQuery:@"//a[@target='_blank']"];
        for (TFHppleElement *tempAElement in LiElementsArr) {
            NSString *suffixStr = [tempAElement objectForKey:@"href"];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",VoaEnglish,suffixStr];
            VE_ArticalModel *model = [VE_ArticalModel title:tempAElement.text url:urlStr];
            [arr addObject:model];
        }
    }
    return arr;
}

- (void)loadNormalContent:(NSString *)url success:(void(^)(VE_NormalContentModel * model))success fail:(void(^)(void))fail {
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    if (htmlData == nil) {
        fail();
        return;
    }else{
        
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
        
        NSArray *mp3Arr = [xpathParser searchWithXPathQuery:@"//a[@id='mp3']"];
        NSArray *contentArr = [xpathParser searchWithXPathQuery:@"//div[@id='content']"];
        
        NSArray *RelatedArtArr = [xpathParser searchWithXPathQuery:@"//a[@target='_blank']"];
        
        
        for (TFHppleElement *element in mp3Arr) {
            if (element.attributes[@"href"]) {
                _mp3Url = element.attributes[@"href"];
            }
        }
        for (TFHppleElement *element in contentArr) {
            _contentStr = element.content;
        }
        
        
        _RelatedArticles = [NSMutableArray new];
        for (TFHppleElement *element in RelatedArtArr) {
            if ([element.attributes[@"id"] isEqualToString:@"help"]) {
                
            }else{
                VE_ArticalModel *model = [VE_ArticalModel title:element.content url:element.attributes[@"href"]];
                [_RelatedArticles addObject:model];
            }
        }
        VE_NormalContentModel *model = [VE_NormalContentModel url:_mp3Url content:_contentStr relatArr:_RelatedArticles];
        success(model);
    }
}

- (void)loadVideoContent:(NSString *)url success:(void(^)(VE_VideoContentModel * model))success fail:(void(^)(void))fail {
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    if (htmlData==nil) {
        fail();
        return;
    } else {
        
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSArray *contentArr = [xpathParser searchWithXPathQuery:@"//div[@id='content']"];
        
        NSArray *RelatedArtArr = [xpathParser searchWithXPathQuery:@"//a[@target='_blank']"];
        
        NSString *_url;
        NSString *_imgUrl;
        NSString *_des;
        
        for (TFHppleElement *element in contentArr) {
            //_contentStr = element.content;
            _contentStr = element.raw;
            
            NSArray *desArr = [element searchWithXPathQuery:@"//p"];
            NSArray *imgArr = [element searchWithXPathQuery:@"//video"];
            NSArray *mp4Arr = [element searchWithXPathQuery:@"//video//source"];
            TFHppleElement *imgEle;
            if (imgArr[0]) {
                imgEle  = imgArr[0];
                _imgUrl = [NSString stringWithFormat:@"http://www.51voa.com/%@",imgEle.attributes[@"poster"]];
            }
            TFHppleElement *mp4Ele;
            if (mp4Arr) {
                mp4Ele = mp4Arr[0];
                _url = mp4Ele.attributes[@"src"];
                
            }
            
            TFHppleElement *desEle;
            if (desArr.count>0) {
                desEle = desArr[0];
                _des = desEle.text;
            }else{
                _des = NSLocalizedString(@"暫無描述", nil);
            }
            
        }
        
        _RelatedArticles = [NSMutableArray new];
        
        for (TFHppleElement *element in RelatedArtArr) {
            if ([element.attributes[@"id"] isEqualToString:@"help"]) {
                
            }else{
                VE_ArticalModel *model = [VE_ArticalModel title:element.content url:element.attributes[@"href"]];
                [_RelatedArticles addObject:model];
            }
        }
        
        VE_VideoContentModel *model = [VE_VideoContentModel url:_url imgUrl:_imgUrl content:_des relatArr:_RelatedArticles];
        success(model);
        
    }
    
    
    
}
@end
