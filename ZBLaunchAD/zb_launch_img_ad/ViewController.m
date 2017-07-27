//
//  ViewController.m
//  zb_launch_img_ad
//
//  Created by zyon on 07/04/2017.
//  Copyright © 2017 zyonbao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    NSLog(@"%@",parent);
}


@end
