//
//  GGNApiClient.m
//  WeiGongAnApp
//
//  Created by dong yiming on 13-3-22.
//  Copyright (c) 2013年 WeiGongAn. All rights reserved.
//

#import "GGApi.h"
#import "NSString+MD5Addition.h"


@implementation GGApi

+(NSString *)apiBaseUrl
{
    return [NSString stringWithFormat:@"%@/", GGN_STR_TEST_SERVER_URL];
}

+ (GGApi *)sharedApi
{
    
    static dispatch_once_t pred;
    static GGApi *_sharedApi = nil;
    
    dispatch_once(&pred, ^{ _sharedApi = [[self alloc] initWithBaseURL:[NSURL URLWithString:[self apiBaseUrl]]]; });
    return _sharedApi;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    //[self setDefaultHeader:@"Accept" value:@"text/json"];
    [self setDefaultHeader:@"Accept" value:@"text/html"];
//    [self setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
//    [self setParameterEncoding:NSUTF8StringEncoding];
    
    
    return self;
}

-(void)canceAllOperations
{
    [self.operationQueue cancelAllOperations];
}

#pragma mark - internal
-(void)_logRawResponse:(id)anOperation
{
    AFHTTPRequestOperation *httpOp = anOperation;
    
    DLog(@"\nRequest:\n%@\n\nRAW DATA:\n%@\n", httpOp.request.URL.absoluteString, httpOp.responseString);
}

-(void)_handleResult:(id)aResultObj
           operation:(id)anOperation
               error:(NSError *)anError
            callback:(GGApiBlock)aCallback
{
    [self _logRawResponse:anOperation];
    
    if (aCallback) {
        aCallback(anOperation, aResultObj, anError);
    }
}

-(void)_execGetWithPath:(NSString *)aPath params:(NSDictionary *)aParams callback:(GGApiBlock)aCallback
{
    [self getPath:aPath
       parameters:aParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [self _handleResult:responseObject operation:operation error:nil callback:aCallback];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              [self _handleResult:nil operation:operation error:error callback:aCallback];
    
          }];
}

-(void)_execPostWithPath:(NSString *)aPath params:(NSDictionary *)aParams callback:(GGApiBlock)aCallback
{
    [self postPath:aPath
        parameters:aParams
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
               [self _handleResult:responseObject operation:operation error:nil callback:aCallback];
               
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               
               [self _handleResult:nil operation:operation error:error callback:aCallback];
               
           }];
}


//接口地址：http://rhtsoft.gnway.net:8888/mobile/mobile-listAreaInfo.rht
//参数：id   地区id  默认为0
//返回参数：(json格式)
//typeId：0表示为地区列表信息，1表示为警员信息
//地区列表信息：地区id，地区名称
//警员信息：警员id,姓名、性别、警号、联系电话、警员图片地址、所属派出所、派出所电话、监督电话。警员图片调用文件下载接口进行下载
-(void)getAreas:(GGApiBlock)aCallback
{
    NSString *path = @"mobile-listAreaInfo.rht";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

-(void)getPolicemanByAreaID:(long long)anAreaID callback:(GGApiBlock)aCallback
{
    NSString *path = @"mobile-listAreaInfo.rht";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:__LONGLONG(anAreaID) forKey:@"id"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//找警察搜索
//接口地址：http://rhtsoft.gnway.et:8888/mobile/mobile-searchAreaInfo.rht
//参数：searchKey 查找关键字
//返回参数：(json格式)
//typeId：0表示为地区列表信息，3表示没有查询到信息
//地区列表信息：地区id，地区名称
-(void)searchAreaByKeyword:(NSString *)aKeyword callback:(GGApiBlock)aCallback
{
    NSString *path = @"mobile-searchAreaInfo.rht";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:aKeyword forKey:@"searchKey"];
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
}


//接口地址：http://rhtsoft.gnway.net:8888/mobile/mobile-clueInfo.rht
//参数：contentType：通缉令栏目文章列表 值为2
//columnId:栏目列表id
//contentId：文章id  根据具体列表传其中一个值
//typeId: 0表示为栏目列表  1标示为文章列表
//栏目列表：栏目列表id: columnId  栏目列表名称：name
//文章列表：文章列表id: contentId  文章列表名称：title
-(void)getWantedRootCategory:(GGApiBlock)aCallback
{
    NSString *path = @"mobile-clueInfo.rht";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:__LONGLONG(2) forKey:@"contentType"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

-(void)getWantedSubCategoryWithID:(long long)aColumnID callback:(GGApiBlock)aCallback
{
    NSString *path = @"mobile-clueInfo.rht";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:__LONGLONG(aColumnID) forKey:@"columnId"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

//接口地址：http://rhtsoft.gnway.net:8888/mobile/mobile-versionCompare.rht
//参数：cltVerion  客户端版本
//返回参数：(json格式)
//返回：verName当前服务器端版本号 如：1.2  可以理解为：小版本
//verCode 当前服务器端版本号 如：2  可以理解为；大版本
//客户端检查自己版本是否与服务器端版本一样，一样无需进行升级，不一样需要升级
//举例：verName值为1.3，客户端自己的版本号为1.2，表示有更新文件 调用文件下载接口进行下载。
-(void)checkUpdateWithCurrentVersion:(NSString *)aCurrentVersion  callback:(GGApiBlock)aCallback
{
    NSString *path = @"mobile-versionCompareIos.rht";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:aCurrentVersion forKey:@"cltVerion"];
    
    [self _execPostWithPath:path params:parameters callback:aCallback];
}

//接口地址：http://rhtsoft.gnway.net:8888/mobile/mobile-saveMap.rht
//参数：areaId  地区标识		老河口：2		襄阳：3
//mbNum   机器编号
//pcNum   报警编号   客户端产生 要求每次报警产生的编号唯一
//mapX    报警地点纬度
//mapY    报警地点经度
#define REPORT_AREA_ID  2
-(NSString *)uniqueNumber
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    int randInt = arc4random() % 100000;
    
    return [NSString stringWithFormat:@"%@%d", dateStr, randInt];
}

-(void)reportPoliceWithAreaID:(long)anAreaID
                  mbNum:(NSString *)aMbNum
                  pcNum:(NSString *)aPcNum
                   mapX:(float)aMapX
                   mapY:(float)aMapY
               callback:(GGApiBlock)aCallback
{
    NSString *path = @"mobile-saveMap.rht";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:__LONG(anAreaID) forKey:@"areaId"];
    [parameters setObject:aMbNum forKey:@"mbNum"];
    [parameters setObject:aPcNum forKey:@"pcNum"];
    [parameters setObject:__FLOAT(aMapX) forKey:@"mapX"];
    [parameters setObject:__FLOAT(aMapY) forKey:@"mapY"];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}

-(void)reportPoliceWithAreaIDV2:(long)anAreaID
                          mbNum:(NSString *)aMbNum
                          pcNum:(NSString *)aPcNum
                           mapX:(float)aMapX
                           mapY:(float)aMapY
                         pcName:(NSString *)aPcName
                        pcPhone:(NSString *)aPcPhone
                       callback:(GGApiBlock)aCallback;
{
    NSString *path = @"mobile-saveMapByBaseDecodeThree.rht";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //mapx mapy 作base64 编码
    NSString * sMapx = [NSString stringWithFormat:@"%f",aMapX];
    NSString * sMapy = [NSString stringWithFormat:@"%f",aMapY];
    
//    aPcName = [aPcName encodeBase64String];
    sMapx = [sMapx encodeBase64String];
    sMapy = [sMapy encodeBase64String];
    
    [parameters setObject:__LONG(anAreaID) forKey:@"areaId"];
    [parameters setObject:aMbNum forKey:@"mbNum"];
    [parameters setObject:aPcNum forKey:@"pcNum"];
    [parameters setObject:sMapx forKey:@"mapX"];
    [parameters setObject:sMapy forKey:@"mapY"];
    [parameters setObject:aPcName forKey:@"pcName"];
    [parameters setObject:aPcPhone forKey:@"pcPhone"];
    [self _execPostWithPath:path params:parameters callback:aCallback];
}

//机器编码
//接口地址：http://rhtsoft.gnway.net:8888/mobile/mobile-addMachineCode.rht
//参数：code 机器编码
//phonePlatform  手机平台

-(void)reportDeviceCode:(NSString *)aDeviceCode
               callback:(GGApiBlock)aCallback
{
    NSString *path = @"mobile-addMachineCode.rht";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:PHONE_PLATFORM forKey:@"phonePlatform"];
    [parameters setObject:aDeviceCode forKey:@"code"];
    
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}


//接口地址：http://rhtsoft.gnway.net:8888/mobile/mobile- chooseAreaIos.rht
//返回参数：(json格式)
//地区信息
-(void)chooseAreas:(GGApiBlock)aCallback
{
    NSString *path = @"mobile-chooseAreaIos.rht";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [self _execGetWithPath:path params:parameters callback:aCallback];
}
@end
