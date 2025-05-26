//
//  AESUtil.m
//  beijing
//
//  Created by wjx on 2024/12/21.
//  Copyright © 2024 zhou last. All rights reserved.
//

#import "AESUtil.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation AESUtil

// AES 加密
+ (NSString *)encrypt:(NSString *)content withKey:(NSString *)key {
    if (!content || !key) {
        return nil;
    }
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [[self class] keyDataFromString:key];
    
    // 加密数据
    NSData *encryptedData = [[self class] AESOperation:kCCEncrypt onData:contentData withKey:keyData];
    if (encryptedData) {
        return [encryptedData base64EncodedStringWithOptions:0]; // Base64 编码
    }
    return nil;
}

// AES 解密
+ (NSString *)decrypt:(NSString *)content withKey:(NSString *)key {
    if (!content || !key) {
        return nil;
    }
    
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:content options:0];
    NSData *keyData = [[self class] keyDataFromString:key];
    
    // 解密数据
    NSData *decryptedData = [[self class] AESOperation:kCCDecrypt onData:encryptedData withKey:keyData];
    if (decryptedData) {
        return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

// 通用的 AES 加解密方法
+ (NSData *)AESOperation:(CCOperation)operation onData:(NSData *)data withKey:(NSData *)key {
    // 校验数据长度
    if (!data || !key || key.length != kCCKeySizeAES128) {
        return nil;
    }
    
    // 输出缓冲区
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t outSize = 0;
    CCCryptorStatus status = CCCrypt(operation,                // 加密或解密
                                     kCCAlgorithmAES,          // 算法：AES
                                     kCCOptionPKCS7Padding | kCCOptionECBMode, // 模式：ECB + PKCS7Padding
                                     key.bytes,                // 密钥
                                     key.length,               // 密钥长度
                                     NULL,                     // ECB 模式无需 IV
                                     data.bytes,               // 输入数据
                                     data.length,              // 输入数据长度
                                     buffer,                   // 输出缓冲区
                                     bufferSize,               // 输出缓冲区大小
                                     &outSize);                // 实际输出大小
    
    if (status == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:outSize];
    }
    
    free(buffer);
    return nil;
}

// 生成 AES 密钥数据
+ (NSData *)keyDataFromString:(NSString *)key {
    NSData *keyData = [key dataUsingEncoding:NSASCIIStringEncoding];
    if (keyData.length < kCCKeySizeAES128) {
        NSMutableData *paddedKey = [NSMutableData dataWithData:keyData];
        [paddedKey setLength:kCCKeySizeAES128]; // 截断或补齐到 16 字节
        return paddedKey;
    }
    return [keyData subdataWithRange:NSMakeRange(0, kCCKeySizeAES128)]; // 截取前 16 字节
}

@end
