//
//  LGGuideController.m
//  Word
//
//  Created by Charles Cao on 2018/4/23.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import "LGGuideController.h"
#import "LGUserManager.h"

@interface LGGuideController ()

@end

@implementation LGGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapAction:(id)sender {
	[LGUserManager shareManager].isFirstLaunch = YES;
	[self.view removeFromSuperview];
	[self removeFromParentViewController];
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
