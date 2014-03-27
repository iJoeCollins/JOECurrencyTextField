//
//  JOECurrencyTextField.h
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

#import <UIKit/UIKit.h>

#pragma mark - JOECurrencyTextField Interface

/*!  JOECurrencyTextField is a subclass of UITextField that specifically deals with the entry and formatting of currency.
*/

@interface JOECurrencyTextField : UITextField <UITextFieldDelegate>


///-------------------------------
/// @name Properties
///-------------------------------

/*! The formatter converts NSNumbers into autoupdating localized currency related strings.
*/
@property (nonatomic, strong) NSNumberFormatter *formatter;

/*! The number value of the currency string.
*/
@property (nonatomic, strong, readonly) NSDecimalNumber *decimalValue;

/*! The number of active significant digits allowed to change in every call of the text fields delegate methods.
 
    Example: $0.4523 : the activeOffset is equal to 1. If equal to 2, $0.0452.
*/
@property (nonatomic, assign) NSUInteger activeOffset;

/*! Allows the user to set an arbitrary number of digits after the decimal seperator by pressing the seperator on the keypad.
*/
@property (nonatomic, assign) BOOL usesArbitraryFractionDigits;


///------------------------------------
/// @name Creating JOECurrencyTextField
///------------------------------------

/*! The designated initializer when using code.
 
    @param frame Used to size and position the control.
    @return Returns a JCCurrencyTextField object.
*/
- (instancetype)initWithFrame:(CGRect)frame;


///-------------------------------
/// @name Dismissing the keyboard
///-------------------------------

/*! This method resigns the first responder, dismissing the keyboard.

    @param sender The object that is sending the action message.
*/
- (IBAction)dismissKeyboard:(id)sender;

@end
