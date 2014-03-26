//
//  JOECurrencyTextField.m
//
//  Version 0.1.0
//
//  Created by Joseph Collins on 03/06/14.
//
//  Distributed under The MIT License (MIT)
//  Get the latest version here:
//
//  http://www.github.com/ijoecollins/JOECurrencyTextField
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

#import "JOECurrencyTextField.h"

@implementation JOECurrencyTextField

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
        [_formatter setLocale:[NSLocale autoupdatingCurrentLocale]];
        [_formatter setMaximumIntegerDigits:17];
        _activeOffset = 0;

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
        [_formatter setLocale:[NSLocale autoupdatingCurrentLocale]];
        [_formatter setMaximumIntegerDigits:17];
        _activeOffset = 0;
        
        self.delegate = self;
    }
    return self;
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // Make sure the text field isn't empty and is formatted correctly.
    // Create an NSDecimalNumber from the textfields text so we can format it
    self.decimalValue = [self decimalNumberFromCurrencyString:self.text scale:self.formatter.minimumFractionDigits];
    
    // Format the decimal value as currency
    self.text = [self.formatter stringFromNumber:self.decimalValue];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Toggle the number of fractional digits from 2 to four
    if ([string isEqualToString:@"."] && self.usesArbitraryFractionDigits) {
        [self toggleFractionDigits:textField];
        
        return NO;
    }
    
    // Get the string resulting from the change
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // Clean the string of all non decimal characters
    NSString *cleanString = [self cleanCurrencyString:resultString];
    
    // If the cleaned string's length is less than unsigned long long overflow length
    if ([cleanString length] <= 19) {
        
        // Convert the cleaned string into a mantissa value
        unsigned long long mantissa = strtoull([cleanString UTF8String], NULL, 10);
        
        // Get the length of the mantissa
        NSUInteger length = mantissa != 0 ? (floor(log10(llabs(mantissa))) + 1) : 0;
        
        // Get the bufferLength based on the formatters minimumFractionDigits and maximumIntegerDigits
        NSUInteger bufferLength = (self.formatter.minimumFractionDigits + self.formatter.maximumIntegerDigits);
        
        // If length is less than the sum of integer and fraction digit limits continue.
        if (length <= bufferLength - _activeOffset) {
            
            // Create an NSDecimalNumber from the textfields text so we can format it
            self.decimalValue = [NSDecimalNumber decimalNumberWithMantissa:mantissa exponent:(-1 * self.formatter.minimumFractionDigits) isNegative:NO];
            
            // Format the decimal number given as currency
            self.text = [self.formatter stringFromNumber:self.decimalValue];
        }

    }
    
    return NO;
}

- (IBAction)dismissKeyboard:(id)sender {
    [self resignFirstResponder];
}


#pragma mark - Private Methods

#warning this is an incomplete but working solution to controlling decimal places. It should probably be left to the user of the class to decide how to setup the formatting of fraction and integer digit limits
- (void)toggleFractionDigits:(UITextField *)textField
{
    BOOL twoMinimumFractionDigits = (self.formatter.minimumFractionDigits == 2);
    self.formatter.minimumFractionDigits = twoMinimumFractionDigits ? 4 : 2;
    self.formatter.maximumIntegerDigits = twoMinimumFractionDigits ? 1 : 17;
    _activeOffset = twoMinimumFractionDigits ? 1 : 0;
    
    textField.text = [self.formatter stringFromNumber:@(0)];
}

/*! Method converts a string formatted as currency to a decimal number object with a given scale argument.
 
 @b Example: Given scale:4, @"$0.0045" -> 0.0045
 
 @param string NSString argument to be converted to a decimal number
 @param scale The number of digits a rounded value should have after its decimal point.
 @return The resulting NSDecimalNumber object.
 */
- (NSDecimalNumber *)decimalNumberFromCurrencyString:(NSString *)string scale:(short)scale
{
    NSString *cleanString = [self cleanCurrencyString:string];
    unsigned long long mantissa = strtoull([cleanString UTF8String], NULL, 10);
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithMantissa:mantissa exponent:(-1 * scale) isNegative:NO];
    
    return decimalNumber;
}

/*! This method cleans a NSString representing currency.  It takes an inverted decimalDigitCharacterSet to remove currency symbols, commas, and decimals.
 
 @param string The string to be cleaned.
 @return The resulting digit only string.
 */
- (NSString *)cleanCurrencyString:(NSString *)string
{
    NSCharacterSet *invertedDecimalSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:invertedDecimalSet];
    NSString *_cleanString = [components componentsJoinedByString:@""];
    
    return _cleanString;
}

@end
