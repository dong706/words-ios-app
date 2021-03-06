//
//  LGWordDetailModel.m
//  Word
//
//  Created by Charles Cao on 2018/2/8.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import "LGWordDetailModel.h"

@implementation LGWordDetailModel

+ (NSDictionary *)mj_objectClassInArray{
	return @{
			 @"sentence" : @"LGSentenceModel",
			 @"lowSentence" : @"LGSentenceModel",
			 @"similarWords" : @"LGSimilarWordsModel"
			 };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
	return @{
			 @"did" : @"do"
			 };
}

- (void)mj_keyValuesDidFinishConvertingToObject{
	
	self.dataSource = [NSMutableArray array];
	
	
	if (ArrayNotEmpty(self.sentence)) {
		LGWordDetailTableDataSource *dataSource = [[LGWordDetailTableDataSource alloc]init];
		dataSource.sectionTitle = @"例句";
		dataSource.type = LGDataSourceExamplesSentence;
		[self.sentence enumerateObjectsUsingBlock:^(LGSentenceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			
			[dataSource.cellContent addObject:obj];
			//最多三个
			if (idx == 2) {
				*stop = YES;
			}
		}];
		[self.dataSource addObject:dataSource];
	}
	
	if (ArrayNotEmpty(self.lowSentence)) {
		LGWordDetailTableDataSource *dataSource = [[LGWordDetailTableDataSource alloc]init];
		dataSource.sectionTitle = @"短句";
		dataSource.type = LGDataSourceText;
		[self.lowSentence enumerateObjectsUsingBlock:^(LGSentenceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			
			NSString *str = [NSString stringWithFormat:@"%@\n%@",obj.english,obj.chinese];
			[dataSource.cellContent addObject:str];
			//最多三个
			if (idx == 2) {
				*stop = YES;
			}
		}];
		[self.dataSource addObject:dataSource];
	}
	
	if (ArrayNotEmpty(self.similarWords)) {
		LGWordDetailTableDataSource *dataSource = [[LGWordDetailTableDataSource alloc]init];
		dataSource.type = LGDataSourceSimilarWords;
		dataSource.sectionTitle = @"形近词";
		[dataSource.cellContent addObject:self.similarWords];
		[self.dataSource addObject:dataSource];
	}
	
	if (StringNotEmpty(self.words.mnemonic)) {
		LGWordDetailTableDataSource *dataSource = [[LGWordDetailTableDataSource alloc]init];
		dataSource.type = LGDataSourceText;
		dataSource.sectionTitle = @"助记";
		[dataSource.cellContent addObject:self.words.mnemonic];
		[self.dataSource addObject:dataSource];
	}
	
	
	if (self.question && [self.question isKindOfClass:[LGQuestionModel class]]) {
		LGWordDetailTableDataSource *dataSource = [[LGWordDetailTableDataSource alloc]init];
		dataSource.sectionTitle = @"例题入口";
		dataSource.type = LGDataSourceQuestion;
		[dataSource.cellContent addObject:self.question.question];
        
		[dataSource.cellContent addObjectsFromArray:self.question.selectItemArr];
		[self.dataSource addObject:dataSource];
	}
	
	LGWordDetailTableDataSource *dataSource = [[LGWordDetailTableDataSource alloc]init];
	dataSource.sectionTitle = @"词典接口";
	dataSource.type = LGDataSourceThirdParty;
	[self.dataSource addObject:dataSource];
}

@end


@implementation LGSentenceModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
	if ([property.name isEqualToString:@"chinese"]) {
		NSString *str = [NSString stringWithFormat:@"%@",oldValue];
		str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
		return str;
	}
	
	if ([property.name isEqualToString:@"english"]) {
		NSString *str = [NSString stringWithFormat:@"%@",oldValue];
		str = [str stringByReplacingOccurrencesOfString:@"<vocab>" withString:@""];
		str = [str stringByReplacingOccurrencesOfString:@"</vocab>" withString:@""];
		return str;
	}
	
	return oldValue;
}


- (NSString *)englishAndChinese{
	NSString *str = [NSString stringWithFormat:@"%@\n%@",self.english,self.chinese];
	//替换掉 <vocab>标签
	str = [str stringByReplacingOccurrencesOfString:@"<vocab>" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"</vocab>" withString:@""];
	return str;
}

@end

@implementation LGWordDetailTableDataSource

- (instancetype)init{
	self = [super init];
	if (self) {
		self.cellContent = [NSMutableArray array];
	}
	return self;
}

@end

@implementation LGQuestionModel

+ (NSDictionary *)mj_objectClassInArray{
	return @{
			 @"selectItemArr" : @"LGQuestionSelectItemModel"
			 };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
	return @{
			 @"selectItemArr" : @"qslctarr"
			 };
}

@end

@implementation LGQuestionSelectItemModel

@end

@implementation LGSimilarWordsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
	return  @{
	  @"ID" : @"id"
	  };
}

@end

