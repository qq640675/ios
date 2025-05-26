//
//  SandPayGateService.h
//  SandPayGate
//
//  Created by WGPawn on 2023/1/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 环境切换
typedef enum : NSUInteger {
    // uat
    UatEnvironment = 1,
    // 生产
    ProductEnvironment = 2,
    // 测试
    TestEnvironment = 3,
} SDGateEnvironment;

/// code - 成功或失败
/// dataDic -- 成功数据或错误信息
typedef void (^SDPayGateResultBlock)(NSString* status, NSDictionary* dataDic);


@interface SandPayGateService : NSObject




/// 当前的是生产环境还是测试环境还是uat环境
@property (nonatomic, assign, readonly) SDGateEnvironment environment;



/// 设置打印日志
///  isLogEnable YES 会打印日志 默认不打印
@property (nonatomic, assign) BOOL isLogEnable;


///  全支付收银台返回数据
@property (nonatomic, copy) SDPayGateResultBlock sandpayGateResultBlock;



/// 设置当前开发环境
/// - Parameter isProduction: ProductEnvironment -是生产环境 TestEnvironment-是测试环境。 UatEnvironment是uat环境 ，默认是生产环境。
-(void)setEnvironment:(SDGateEnvironment)currentEnvironment;
 
/// 单例
+ (instancetype)shared;

/// 查询交易记录信息 是不是单个支付方式 是不是多个支付方式等等
/// - Parameter tokenID: tokenID id
-(void)queryTradeRecordInfoWith:(NSString*)tokenID;




    
@end

NS_ASSUME_NONNULL_END
