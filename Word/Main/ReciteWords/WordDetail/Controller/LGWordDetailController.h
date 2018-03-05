//
//  LGWordDetailController.h
//  Word
//
//  Created by Charles Cao on 2018/2/7.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LGWordDetailControllerType) {
	LGWordDetailReciteWords = 0, 	   //背单词模式,默认
	LGWordDetailEbbinghausReview,      //艾宾浩斯复习模式
	LGwordDetailTodayReview,		   //今日复习
    LGwordDetailReview                 //复习
};


@interface LGWordDetailController : UIViewController

//controller 模式
@property (nonatomic, assign) LGWordDetailControllerType controllerType;

//正常复习模式下的复习方式
@property (nonatomic, assign) LGSelectReviewType reviewTyep;
//正常复习模式下的复习 id 数组
@property (nonatomic, strong) NSMutableArray<NSString *> *reviewWordIdArray;

//今日复习模式下(LGwordDetailTodayReview),要复习的状态,0为全部
@property (nonatomic, assign) LGWordStatus todayReviewStatus;

// 艾宾浩斯复习模式(LGWordDetailEbbinghausReview)下需要复习单词的 id 列表
@property (nonatomic, copy) NSMutableArray<NSString *> *ebbinghausReviewWordIdArray;

//当前单词顺序号 (title)
@property (nonatomic, copy) NSString *currentNum;

//单词总共个数 (title)
@property (nonatomic, copy) NSString *total;

//单词 label
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

//播放button距离单词label 的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerButtonTopLayout;

//播放读音 button
@property (weak, nonatomic) IBOutlet UIButton *playerButton;

//译文
@property (weak, nonatomic) IBOutlet UILabel *translateLabel;
//顶部 单词区域
@property (weak, nonatomic) IBOutlet UIView *wordView;

// '模糊' / '忘记'按钮 , 复习模式下为'忘记',背单词模式下为 '模糊'
@property (weak, nonatomic) IBOutlet UIButton *vagueOrForgotButton;

@property (weak, nonatomic) IBOutlet UITableView *wordTabelView;


@end
