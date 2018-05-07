//
//  LGWordDetailModel.h
//  Word
//
//  Created by Charles Cao on 2018/2/8.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGFreeWordModel.h"

//cell 类型
typedef NS_ENUM(NSUInteger, LGWordDetailTableDataSourceType) {
	LGDataSourceText,	    //普通文字类型
	LGDataSourceQuestion,   //列题
	LGDataSourceThirdParty  //第三方
};

@class LGSentenceModel , LGWordDetailTableDataSource, LGQuestionSelectItemModel, LGQuestionModel;
@interface LGWordDetailModel : NSObject

@property (nonatomic, strong) NSString *percent;//认知率
@property (nonatomic, strong) LGFreeWordModel *words;
@property (nonatomic, strong) NSArray<LGSentenceModel *> *sentence;
@property (nonatomic, strong) NSArray<LGSentenceModel *> *lowSentence;
@property (nonatomic, strong) LGQuestionModel *question;
@property (nonatomic, copy) NSString *did; //已背单词

/**
 自定义字段,用于背单词详情页tableview 的数据源
 */
@property (nonatomic, strong) NSMutableArray<LGWordDetailTableDataSource *> *dataSource;

@end

@interface LGSentenceModel : NSObject

@property (nonatomic, copy) NSString *english;
@property (nonatomic, copy) NSString *chinese;

@end

@interface LGWordDetailTableDataSource  : NSObject

@property (nonatomic, copy)  NSString *sectionTitle;
@property (nonatomic, strong) NSMutableArray *cellContent;
@property (nonatomic, assign) LGWordDetailTableDataSourceType type;

@end


@interface LGQuestionModel : NSObject

@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *questionanswer;
@property (nonatomic, copy) NSArray<LGQuestionSelectItemModel *> *selectItemArr;

@end

@interface LGQuestionSelectItemModel : NSObject

//A. B. C. 
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *select;
//自定义字段，是否显示当前选项的对错
@property (nonatomic, assign) BOOL isShowRightOrWrong;

//自定义字段，是否是正确答案
@property (nonatomic, assign) BOOL isRightAnswer;

@end
