//
//  LGWordDetailQuestionCell.h
//  Word
//
//  Created by Charles Cao on 2018/4/20.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGWordDetailQuestionCell : UITableViewCell

@property (nonatomic, copy) NSString *question;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;


/**
 设置例题

 @param question 问题
 @param word 高亮的单词
 @param completion 异步解析 html 回调
 @param article 文章
 */
- (void)setQuestion:(NSString *)question word:(NSString *)word article:(NSString *)article completion:(void(^)(void))completion;

@end
