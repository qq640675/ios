//
//  CacheManager.m
//  beijing
//
//  Created by 黎 涛 on 2019/6/29.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "CacheManager.h"
#import "lame.h" //格式转换

@implementation CacheManager

+ (NSString *)recorderPathWithFileName:(NSString *)fileName {
    NSString *str = [fileName stringByAppendingString:@".aac"];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:str];
    return path;
}

+ (NSString *)recorderMP3PathWithFileName:(NSString *)fileName {
    NSString *str = [fileName stringByAppendingString:@".mp3"];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:str];
    return path;
}

+ (void)recorderDeleteFileWithName:(NSString *)fileName {
    // 删除临时创建的缓存文件
    NSString *path = [self recorderPathWithFileName:fileName];
    NSString *path_mp3 = [self recorderMP3PathWithFileName:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
    [fileManager removeItemAtPath:path_mp3 error:nil];
}

+ (void)recorderPCMtoMP3WithFileName:(NSString *)fileName success:(void (^)(void))success {
    NSString *recorderSavePath = [self recorderPathWithFileName:fileName];
    NSString *mp3FilePath = [self recorderMP3PathWithFileName:fileName];
    
    @try {
        int read,write;
        
        FILE *pcm = fopen([recorderSavePath cStringUsingEncoding:1], "rb"); //只读方式打开被转换音频文件
        fseek(pcm, 4 * 1024, SEEK_CUR); //删除头，否则在前一秒钟会有杂音
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb"); //只写方式打开生成的MP3文件
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        //这里要注意，lame的配置要跟AVAudioRecorder的配置一致，否则会造成转换不成功
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);//采样率
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            //以二进制形式读取文件中的数据
            read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            //二进制形式写数据到文件中  mp3_buffer：数据输出到文件的缓冲区首地址  write：一个数据块的字节数  1:指定一次输出数据块的个数   mp3:文件指针
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
        
    } @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    } @finally {
        NSLog(@"MP3生成成功: %@",mp3FilePath);
        if (success) {
            success();
        }
    }
}
    

@end
