//
//  LGSimilarWordsCell.m
//  Word
//
//  Created by Charles Cao on 2018/5/31.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import "LGSimilarWordsCell.h"
#import "LGSimilarWordsCollectionCell.h"
#import "NSString+LGString.h"
#import "LGUserManager.h"

@interface LGSimilarWordsCell() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@end

@implementation LGSimilarWordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSimilarWords:(NSArray<LGSimilarWordsModel *> *)similarWords{
	if (_similarWords != similarWords) {
		_similarWords = similarWords;
		
		UICollectionViewFlowLayout  *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
		
		[self.collectionView reloadData];
		self.collectionHeightConstraint.constant = flowLayout.collectionViewContentSize.height;
	}
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return self.similarWords.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	LGSimilarWordsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LGSimilarWordsCollectionCell" forIndexPath:indexPath];
	cell.similarWord = self.similarWords[indexPath.row];
	return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
	NSString *text = self.similarWords[indexPath.row].word;
	CGFloat width = [text getStringRectWidthOfHeight:0 fontSize:14 + [LGUserManager shareManager].user.fontSizeRate.floatValue];
	return CGSizeMake(ceil(width), 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	[self.delegate selectedSimilar:self.similarWords[indexPath.row]];
}


@end
