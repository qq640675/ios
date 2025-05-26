
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YLThirdSetup : NSObject

@property (nonatomic ,strong) NSString *we_chat_app_id;
@property (nonatomic ,strong) NSString *we_chat_secret;
@property (nonatomic ,strong) NSString *qq_app_id;
@property (nonatomic ,strong) NSString *tencent_cloud_app_id;
@property (nonatomic ,strong) NSString *tencent_cloud_bucket;
@property (nonatomic ,strong) NSString *tencent_cloud_secret_id;
@property (nonatomic ,strong) NSString *tencent_cloud_secret_key;
@property (nonatomic ,strong) NSString *tencent_cloud_region;
@property (nonatomic ,strong) NSString *agora_app_id;
@property (nonatomic ,strong) NSString *tim_app_id;
@property (nonatomic ,strong) NSString *jpush_appkey;
@property (nonatomic ,strong) NSString *sharetrace_appkey;
@property (nonatomic ,strong) NSString *amap_apikey;
@property (nonatomic ,strong) NSString *btkey_ios_ver;
@property (nonatomic ,strong) NSString *btkey_ios_file;

@property (nonatomic ,strong) NSString *serverurl;
@property (nonatomic ,strong) NSString *socketip;
@property (nonatomic ,strong) NSString *selfcodeurl;

+ (YLThirdSetup *)thirdDefault;
@end
