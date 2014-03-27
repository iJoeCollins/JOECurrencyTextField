Setup Guide
-----------

Open your terminal and run:

> ```git clone git@github.com:iJoeCollins/JOECurrencyTextField.git```

Drag the JOECurrencyTextField folder into your project.

Then in your .pch file:

> ```#import "JOECurrencyTextField.h"```

Or just import the header files where needed.

Interface Builder Setup
-----------------------

If you are using IB, drag in a UITextField and remember to set the class type to "JOECurrencyTextField".

Control drag from your text field to the source interface to wire up an IBOutlet.

Configure the text field further in your view controller viewDidLoad method. See [Programming Guide](http://developer.ijoe.co/library/JOECurrencyTextField/docs/Programming%20Guide) for more info and examples.
