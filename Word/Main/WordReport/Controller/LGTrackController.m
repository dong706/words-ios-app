//
//  LGTrackController.m
//  Word
//
//  Created by Charles Cao on 2018/3/30.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import "LGTrackController.h"
#import "LGTrackRankCell.h"
#import "LGTrackFinishProgressCell.h"
#import "LGTrackRankHeaderView.h"
#import "UIScrollView+LGRefresh.h"
#import "LGTrackFinishHeaderView.h"
#import "LGTrackModel.h"
#import "LGUserManager.h"
#import "LGBeginEstimateController.h"

@interface LGTrackController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LGTrackModel *trackModel;

@end

@implementation LGTrackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self configTable];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configTable{
	[self.tableView registerNib:[UINib nibWithNibName:@"LGTrackRankHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"LGTrackRankHeaderView"];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"LGTrackFinishHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"LGTrackFinishHeaderView"];
	
	__weak typeof(self) weakSelf = self;
	[self.tableView setHeaderRefresh:^{
		[weakSelf requestData];
	}];
}

- (void)requestData{
	[self.request reqeustTrackCompletion:^(id response, LGError *error) {
		[self.tableView lg_endRefreshing];
		if ([self isNormal:error]) {
			self.trackModel = [LGTrackModel mj_objectWithKeyValues:response];
		}
	}];
}

- (void)setTrackModel:(LGTrackModel *)trackModel{
    
    //谜之为nil，谜之崩溃
    if (trackModel == nil) {
        return;
    }
    
	_trackModel = trackModel;
	self.totalWordsLabel.text = trackModel.userAllWords;
	self.knowLabel.text = trackModel.know;
	self.incognizanceLabel.text = trackModel.notKnow;
    [self.pieView setPieDayStudy:trackModel.everydayNew.integerValue dayReview:trackModel.review.integerValue];
    [LGUserManager shareManager].user.estimateWords = @(trackModel.ev.num).stringValue;
	NSString *totalDayStr =  [NSString stringWithFormat:@"总天数:%@天",trackModel.insistDay];
	NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:totalDayStr];
	[attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, totalDayStr.length)];
	[attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:[totalDayStr rangeOfString:trackModel.insistDay]];
	self.totalDayLabel.attributedText = attrString;
    
    [self.tableView reloadData];
}

#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) { return self.trackModel.package.count;}
	if (section == 1) { return self.trackModel.rank.count;}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		LGTrackFinishProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LGTrackFinishProgressCell"];
        cell.packageModel = self.trackModel.package[indexPath.row];
		return cell;
	}else{
		LGTrackRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LGTrackRankCell"];
        [cell setTrackRankModel:self.trackModel.rank[indexPath.row] rank:indexPath.row + 1];
		return cell;
	}
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 25 : 63;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		LGTrackFinishHeaderView *finishHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LGTrackFinishHeaderView"];
		return finishHeader;
	}else{
		LGTrackRankHeaderView *rankHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LGTrackRankHeaderView"];
        rankHeader.userRankData = self.trackModel.data;
		return rankHeader;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return section == 0 ? 30 : 64;
}


#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end

