//
//  ViewController.m
//  JCCurrencyTextField
//
//  Created by Joseph Collins on 3/6/14.
//  Copyright (c) 2014 Joseph Collins. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet JOECurrencyTextField *textField;
@property (weak, nonatomic) IBOutlet JOECurrencyTextField *textField2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.textField.usesArbitraryFractionDigits = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
