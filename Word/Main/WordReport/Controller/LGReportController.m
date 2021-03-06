//
//  LGReportController.m
//  Word
//
//  Created by Charles Cao on 2018/4/4.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import "LGReportController.h"
#import "UIScrollView+LGRefresh.h"
#import "LGReportModel.h"
#import "NSDate+Utilities.h"

@interface LGReportController ()

@property (nonatomic, strong) LGReportModel *reportModel;

@end

@implementation LGReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	__weak typeof(self) weakSelf = self;
	[self.scrollView setHeaderRefresh:^{
		[weakSelf reqeustData];
	}];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self reqeustData];
}

//请求报表
- (void)reqeustData{
	[self.request requestReportCompletion:^(id response, LGError *error) {
		[self.scrollView lg_endRefreshing];
		if ([self isNormal:error]) {
            self.reportModel = [LGReportModel mj_objectWithKeyValues:response];
		}
	}];
}

- (void)setReportModel:(LGReportModel *)reportModel{
    _reportModel = reportModel;
    
    self.weekTotalLabel.text = [NSString stringWithFormat:@"总量:(%@)",reportModel.week.all];
    [self.weekData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        NSString *description;
        NSString *num;
        switch (btn.tag) {
            case 100:
                description = @"熟知量";
                num = reportModel.week.knowWell;
                break;
            case 101:
                description = @"认识量";
                num = reportModel.week.know;
                break;
            case 102:
                description = @"模糊量";
                num = reportModel.week.dim;
                break;
            case 103:
                description = @"忘记量";
                num = reportModel.week.forget;
                break;
            case 104:
                description = @"不认识";
                num = reportModel.week.notKnow;
                break;
            default:
                break;
        }
        [btn setTitle:[NSString stringWithFormat:@"%@   (%@)",description,num] forState:UIControlStateNormal];
    }];
    
    self.reportPieView.weekReportModel = reportModel.week;
	[self.lineChartView setReportData:reportModel];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
