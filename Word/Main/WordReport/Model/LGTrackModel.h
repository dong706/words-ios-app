//
//  LGTrackModel.h
//  Word
//
//  Created by Charles Cao on 2018/3/30.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  LGTracPackageModel, LGTrackRankModel ,LGTrackUserDataModel, LGTranckEvModel;
@interface LGTrackModel : NSObject

//认识的单词
@property (nonatomic, copy) NSString *know;

//不认识
@property (nonatomic, copy) NSString *notKnow;

//平均每天新学
@property (nonatomic, copy) NSString *everydayNew;

//平均每天复习
@property (nonatomic, copy) NSString *review;

//总单词数
@property (nonatomic, copy) NSString *userAllWords;

//总天数
@property (nonatomic, copy) NSString *insistDay;

@property (nonatomic, copy) NSArray<LGTracPackageModel *> *package;

@property (nonatomic, strong) LGTrackUserDataModel *data;

@property (nonatomic, strong) LGTranckEvModel *ev;

@property (nonatomic, copy) NSArray<LGTrackRankModel *> *rank;

@end

//已完成单词
@interface LGTracPackageModel : NSObject

//词包名字
@property (nonatomic, copy) NSString *name;

//单词总数
@property (nonatomic, copy) NSString *all;

//已经背单词
@property (nonatomic, copy) NSString *console;

@end


@interface LGTrackUserDataModel : NSObject

//用户词汇量
@property (nonatomic, assign) NSInteger num;

//用户排名
@property (nonatomic, assign) NSInteger rank;

@end

//评估的数据
@interface LGTranckEvModel : NSObject

//用户评估量
@property (nonatomic, assign) NSInteger num;

@end

@interface LGTrackRankModel : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;
//单词量
@property (nonatomic, copy) NSString *num;

@end

