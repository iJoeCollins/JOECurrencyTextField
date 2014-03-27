//
//  JOECurrencyTextFieldTests.m
//  JOECurrencyTextFieldTests
//
//  Created by Joseph Collins on 3/6/14.
//  Copyright (c) 2014 Joseph Collins. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JOECurrencyTextField.h"

@interface JOECurrencyTextFieldTests : XCTestCase
@property (nonatomic, strong) JOECurrencyTextField *textField;
@property (nonatomic, weak) id <UITextFieldDelegate> delegate;
@end

@implementation JOECurrencyTextFieldTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.textField = [[JOECurrencyTextField alloc] initWithFrame:CGRectMake(100, 100, 320, 40)];
    self.textField.usesArbitraryFractionDigits = YES;
    self.delegate = self.textField.delegate;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCurrencyFormatting
{
    [self.delegate textFieldDidBeginEditing:self.textField];
    
    [self.delegate textField:self.textField shouldChangeCharactersInRange:NSMakeRange(5, 0) replacementString:@"1"];
    
    [self.delegate textField:self.textField shouldChangeCharactersInRange:NSMakeRange(5, 0) replacementString:@"2"];
    
    [self.delegate textField:self.textField shouldChangeCharactersInRange:NSMakeRange(5, 0) replacementString:@"3"];
    
    XCTAssertEqualObjects(self.textField.text, @"$1.23", @"Expected $1.23, instead showing %@", self.textField.text);
}

- (void)testDecimalValue
{
    NSDecimalNumber *decimal123 = [NSDecimalNumber decimalNumberWithString:@"1.23"];
    
    [self.delegate textFieldDidBeginEditing:self.textField];
    
    [self.delegate textField:self.textField shouldChangeCharactersInRange:NSMakeRange(5, 0) replacementString:@"1"];

    [self.delegate textField:self.textField shouldChangeCharactersInRange:NSMakeRange(5, 0) replacementString:@"2"];

    [self.delegate textField:self.textField shouldChangeCharactersInRange:NSMakeRange(5, 0) replacementString:@"3"];

    XCTAssertEqualObjects(self.textField.decimalValue, decimal123, @"Expected 1.23, instead showing %@", self.textField.decimalValue);
}

- (void)testPaste
{
    NSDecimalNumber *decimal123 = [NSDecimalNumber decimalNumberWithString:@"12345678901234567.89"];
    
    [self.delegate textFieldDidBeginEditing:self.textField];
    
    [self.delegate textField:self.textField shouldChangeCharactersInRange:NSMakeRange(26, 0) replacementString:@"1234567890123456789"];
    
    XCTAssertEqualObjects(self.textField.decimalValue, decimal123, @"Expected 12345678901234567.89, instead showing %@", self.textField.decimalValue);
    XCTAssertEqualObjects(self.textField.text, @"$12,345,678,901,234,567.89", @"Expected $12,345,678,901,234,567.89 instead showing %@", self.textField.text);
}

@end
