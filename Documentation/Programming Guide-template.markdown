Programming Guide
-----------------

This programming guide serves as a reference on how to go about using the included api. Each example shows a possible setting, or use of the control.

<a name="usingarbitraryfractionaldigits"></a>
Using Arbitrary Fractional Digits
--------------------------------
Currently the textfield only supports either two or four decimal places, but would like and am planning to let the user of the class decide this by setting the number formatters minimumFractionDigits and maximumIntegerDigits properties.

```
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.textField.usesArbitraryFractionDigits = YES;
}
```