//
//  LGDiscoverDetailController.m
//  Word
//
//  Created by Charles Cao on 2018/4/4.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import "LGDiscoverDetailController.h"
#import "LGWebController.h"

@interface LGDiscoverDetailController ()

@end

@implementation LGDiscoverDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self configData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configData{
    self.title = self.discoverModel.title;
	[self.discoverImageView sd_setImageWithURL:[NSURL URLWithString:WORD_DOMAIN(self.discoverModel.image)]];
    
    __weak typeof(self) weakSelf = self;
    [self.discoverModel.content htmlToAttributeStringContent:WORD_DOMAIN(@"") width:SCREEN_WIDTH completion:^(NSMutableAttributedString *attrStr) {
        weakSelf.contentTextView.attributedText = attrStr;
        [weakSelf.activityView stopAnimating];
    }];
}

//报名
- (IBAction)signAction:(id)sender {
	LGWebController *web = [LGWebController contactAdvisorWebController];
	[self.navigationController pushViewController:web animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
