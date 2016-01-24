We use [CocoaPods](http://cocoapods.org) in order to make installing and updating our SDK super easy. CocoaPods manages library dependencies for your Xcode projects.

### Installing CocoaPods
If you don't have CocoaPods installed on your machine you can install it by using the following command in the comamnd line:
```
sudo gem install cocoapods
```
After that you need to go to the project's directory and initialize CocoaPods
```
cd /project_root
pod init
```
### Getting the SDK
The dependencies for your projects are specified in a single text file called a Podfile. CocoaPods will resolve dependencies between libraries, fetch the resulting source code, then link it together in an Xcode workspace to build your project.
To download the latest release of the SDK add the following line to your Podfile:
```
pod 'SuperAwesome'
```
After the pod source has been added, update your project's dependencies by running the following command in the terminal:
```
pod update
```
Don't forget to use the .xcworkspace file to open your project in Xcode, instead of the .xcproj file, from here on out.
