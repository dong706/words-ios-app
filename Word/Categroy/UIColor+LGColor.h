//
//  UIColor+LGColor.h
//  Word
//
//  Created by Charles Cao on 2018/1/20.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LGColor)


/**
 十六进制 转换为 UIColor
 *
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

@end