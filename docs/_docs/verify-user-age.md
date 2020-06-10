---
title: Verifying a user’s age
description: Verifying a user’s age
---

# Verifying a user’s age

A new feature in the SDK is the ability to verify a user’s age, given a date of birth.

An example below:

{% highlight objective_c %}
#import "AwesomeAds.h"

// some date in format YYYY-MM-DD
NSString* dateOfBirth = @"2012-02-02";

[AwesomeAds triggerAgeCheck:dateOfBirth response:^(GetIsMinorModel *model) {
  if (model != nil) {
    // relevant values in the model
    NSString* country = model.country;
    NSInteger consentAgeForCountry = model.consentAgeForCountry;
    NSInteger age = model.age;
    BOOL isMinor = model.isMinor;
  }
}];
{% endhighlight %}