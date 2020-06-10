---
title: Add the SDK through CocoaPods
description: Add the SDK through CocoaPods
---

# Add the SDK through CocoaPods

We use [CocoaPods](http://cocoapods.org/) in order to make installing and updating our SDK super easy. CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects.

If you don’t have CocoaPods installed on your machine you can install it by issuing the following command in your terminal:

{% highlight shell %}
sudo gem install cocoapods
{% endhighlight %}

After that you need to go to the project’s directory and initialize CocoaPods

{% highlight shell %}
cd /path_to/my_project/
pod init
{% endhighlight %}

This will also create a special file called a <strong>Podfile</strong>, where you can specify what dependencies to add to your new project. Usually it will look similar to this:

You can add the SDK to your project by declaring the following Pod:

{% highlight shell %}
target 'MyProject' do
    pod 'SuperAwesome', '7.2.6'
end
{% endhighlight %}

This will tell CocoaPods to fetch the latest version of the iOS Publisher SDK. This will contain everything you need in order to load and display banner, interstitial and video ads.

After the pod source has been added, update your project’s dependencies by running the following command in the terminal:

{% highlight shell %}
pod update
{% endhighlight %}

Don’t forget to use the <strong>.xcworkspace</strong> file to open your project in Xcode, instead of the .xcproj file, from here on out.

You can import the main SDK header file like so:

{% highlight objective_c %}
#import "SuperAwesome.h"
{% endhighlight %}