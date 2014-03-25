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
        _formatter = [[NSNumberFormatter alloc] init];
        [_formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [_formatter setLocale:[NSLocale currentLocale]];
//        _active = YES;
        _scale = _formatter.minimumFractionDigits;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self];
        
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
        _formatter = [[NSNumberFormatter alloc] init];
        [_formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [_formatter setLocale:[NSLocale currentLocale]];
//        _active = YES;
        [_formatter setMaximumIntegerDigits:17];
        _scale = _formatter.minimumFractionDigits;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self];
        
        self.delegate = self;
    }
    return self;
}

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

#pragma mark - UITextField Delegate Methods

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self userInfo:nil];
//}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (![string length]) {
//        return YES;
//    }
    
    if ([string isEqualToString:@"."] && self.usesArbitraryFractionDigits) {
        [self toggleFractionDigits:textField];
        self.scale = self.formatter.minimumFractionDigits;
        
        return NO;
    }
    
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *cleanString = [JCCurrencyUtil cleanCurrencyString:resultString];
    
    unsigned long long mantissa = strtoull([cleanString UTF8String], NULL, 10);
    
    NSUInteger length = mantissa != 0 ? (floor(log10(llabs(mantissa))) + 1) : 0;
    NSUInteger bufferLength = (self.formatter.minimumFractionDigits + self.formatter.maximumIntegerDigits);
    if (length < bufferLength) {
        // Create an NSDecimalNumber from the textfields text so we can format it
        NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithMantissa:mantissa exponent:(-1 * self.scale) isNegative:NO];
        
        // Format the decimal number given as currency
        self.text = [self.formatter stringFromNumber:decimalNumber];
    }
    
    return NO;
}

#warning this is an incomplete but working solution, still needs to work out arbitrary number of decimal places
//- (void)textFieldTextDidChange:(NSNotification *)notification
//{
//    // Format the changed text
//    [self formatChangedText];
//    
//    // Limit the number of digits that can be entered by the user (based on buffer limit of unsigned long long)
//    [self switchActiveWithLength:[self lengthOfCurrencyValue]];
//}

- (IBAction)dismissKeyboard:(id)sender {
    [self resignFirstResponder];
}


#pragma mark - Private Methods

//- (void)formatChangedText
//{
//    // Create an NSDecimalNumber from the textfields text so we can format it
//    NSDecimalNumber *decimalNumber = [JCCurrencyUtil decimalNumberFromCurrencyString:self.text scale:self.formatter.minimumFractionDigits];
//    
//    // Format the decimal number given as currency
//    self.text = [self.formatter stringFromNumber:decimalNumber];
//}

//- (NSUInteger)lengthOfCurrencyValue
//{
//    // Clean the string of any non decimal characters and convert it to a possibly very large integer
//    NSString *cleanString = [JCCurrencyUtil cleanCurrencyString:self.text];
//    unsigned long long mantissa = strtoull([cleanString UTF8String], NULL, 10);
//    NSUInteger length = (floor(log10(llabs(mantissa))) + 1);
//    
//    return length;
//}
//
//
//- (void)switchActiveWithLength:(NSUInteger)length
//{
//    // This switches active based on the limit of decimal characters an unsigned long long can hold at 2 and 4 decimal places
//    if (self.formatter.minimumFractionDigits == 2) {
//        switch (length) {
//            case 19:
//                self.active = NO;
//                break;
//            case 18:
//                self.active = YES;
//            default:
//                break;
//        }
//    } else {
//        switch (length) {
//            case 4:
//                self.active = NO;
//                break;
//            case 3:
//                self.active = YES;
//            default:
//                break;
//        }
//    }
//}

#warning this is an incomplete but working solution to controlling decimal places
- (void)toggleFractionDigits:(UITextField *)textField
{
    BOOL twoMinimumFractionDigits = (self.formatter.minimumFractionDigits == 2);
    self.formatter.minimumFractionDigits = twoMinimumFractionDigits ? 4 : 2;
    self.formatter.maximumIntegerDigits = twoMinimumFractionDigits ? 1 : 17;
    
    textField.text = nil;
//    self.active = YES;
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:textField userInfo:nil];
}

@end
