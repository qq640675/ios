
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

- (NSString *)emoji;

- (CGSize)sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font;

- (CGSize)bounding:(CGFloat)width height:(float)height andFont:(UIFont *)font;
- (NSString *)originName;

+ (NSString *)currentName;

- (NSString *)firstStringSeparatedByString:(NSString *)separeted;

+ (BOOL) isNullOrEmpty:(NSString *)string;


@end
