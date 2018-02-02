//
//  LGFreeWordListCell.m
//  Word
//
//  Created by Charles Cao on 2018/2/1.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import "LGFreeWordListCell.h"

@implementation LGFreeWordListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWordModel:(LGFreeWordModel *)wordModel{
	self.wordNameLabel.text = wordModel.word;
	self.wordPhonogramLabel.text = wordModel.phonetic_us;
	self.wordMeaningLabel.text = wordModel.translate;
	
	switch (wordModel.firstStatus) {
		case LGFreeWordStatusNone:
			self.backgroundColor = [UIColor lg_colorWithHexString:@"f1f1f1"];
			break;
		case LGFreeWordStatusKnow1:
		case LGFreeWordStatusKnow2:
			self.backgroundColor = [UIColor lg_colorWithHexString:@"cbffe6"];
			break;
		case LGFreeWordStatusIncognizance:
			self.backgroundColor = [UIColor lg_colorWithHexString:@"f9c5c4"];
			break;
		case LGFreeWordStatusVague:
			self.backgroundColor = [UIColor lg_colorWithHexString:@"fceac1"];
			break;
	}
	
}

@end
