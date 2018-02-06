//
//  LGReciteWordsController.m
//  Word
//
//  Created by Charles Cao on 2018/1/26.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import "LGReciteWordsController.h"
#import "LGStudyTypeController.h"
#import "LGUserManager.h"
#import "LGNoStudyTypeController.h"
#import "LGRecitePlanController.h"

@interface LGReciteWordsController ()

@property (nonatomic, strong) LGUserModel *user;
@property (nonatomic, strong) LGNoStudyTypeController *noStudyTypeController;  //没有记忆计划
@property (nonatomic, strong) LGRecitePlanController *recitePlanController;     //有记忆计划

@end

@implementation LGReciteWordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	//[self configNavigationBar];
	
	[self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj isKindOfClass:[LGNoStudyTypeController class]]) {
			self.noStudyTypeController = obj;
		}else{
			self.recitePlanController = obj;
		}
	}];
	[self showController:NO];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:LOGIN_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
	[self configData];
}

- (void)configData{
	__weak typeof(self) weakSelf = self;
	[self.request requestUserInfo:^(id response, LGError *error) {
		[LGUserManager shareManager].user = [LGUserModel mj_objectWithKeyValues:response[@"data"]];
		[weakSelf showController:YES];
	}];
}


/**
 转换 childController;
 有计划和记忆模式显示 LGRecitePlanController,
 没有计划和记忆模式显示 LGNoStudyTypeController

 @param animated 是否动画
 */
- (void)showController:(BOOL)animated {
	
	NSTimeInterval duration = animated ? 0.5 : 0;
	 LGUserModel *user = [LGUserManager shareManager].user;
	
	if (StringNotEmpty(user.planWords) && user.studyModel != LGStudyNone) {
		[self transitionFromViewController:self.noStudyTypeController toViewController:self.recitePlanController duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
	}else{
		[self transitionFromViewController:self.recitePlanController toViewController:self.noStudyTypeController duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
	}
	
	
}

- (void)configNavigationBar{
	
	UIButton *header = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
	header.layer.cornerRadius = 22;
	header.layer.masksToBounds = YES;
	[header setImage:PLACEHOLDERIMAGE forState:UIControlStateNormal];
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:header];
	self.navigationItem.leftBarButtonItem = leftItem;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//语音搜索
- (IBAction)speakSearchAction:(id)sender {
	NSLog(@"yuy");
}

//拍照搜索
- (IBAction)pictureSearch:(id)sender {
	NSLog(@"拍照");
}

//登录成功
- (void)loginSuccess{
	
	[self configData];
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
