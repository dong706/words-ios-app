//
//  LGCourseListController.h
//  Word
//
//  Created by Charles Cao on 2018/4/9.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGCourseListController : UIViewController

@property (nonatomic, assign) LGCourseType type;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
