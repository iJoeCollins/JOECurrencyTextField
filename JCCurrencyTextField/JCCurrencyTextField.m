//
//  JCCurrencyTextField.m
//
//  Version 1.0
//
//  Created by Joseph Collins on 03/06/14.
//
//  Distributed under The MIT License (MIT)
//  Get the latest version here:
//
//  http://www.github.com/ijoecollins/JCCurrencyTextField
//
//  Copyright (c) 2014 Joseph Collins.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "JCCurrencyTextField.h"
#import "JCCurrencyUtil.h"

@implementation JCCurrencyTextField

#pragma mark - Initialization

/*! The designated initializer when using code.
 
 @param frame Used to size and position the control.
 @return Returns a JCCurrencyTextField object.
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _utility = [JCCurrencyUtil new];
        [_utility registerTextField:self];
        _scale = _utility.formatter.minimumFractionDigits;
        
        self.delegate = self;
    }
    return self;
}

/*! The designated initializer when loading from a nib or storyboard.
 
 @param aDecoder An NSCoder object.
 @return Returns a JCCurrencyTextField object.
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _utility = [JCCurrencyUtil new];
        [_utility registerTextField:self];
        _scale = _utility.formatter.minimumFractionDigits;
        
        self.delegate = self;
    }
    return self;
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self userInfo:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![string length]) {
        return YES;
    }
    
    if ([string isEqualToString:@"."] && self.usesArbitraryFractionDigits) {
        [self.utility toggleFractionDigits:textField];
        self.scale = self.utility.formatter.minimumFractionDigits;
        
        return NO;
    }
    
    return [self.utility isActive];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self resignFirstResponder];
}


@end
