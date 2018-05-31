//
//  LGWordDetailMoreMenuView.h
//  Word
//
//  Created by Charles Cao on 2018/5/31.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGWordDetailMoreMenuViewDelegate <NSObject>

- (void)submiteError;

@end

@interface LGWordDetailMoreMenuView : UIView

@property (nonatomic, weak) id<LGWordDetailMoreMenuViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *muteLabel;

@property (weak, nonatomic) IBOutlet UISwitch *muteSwitch;

@end