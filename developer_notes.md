

## Testing

navigate to the test tab in Xcode and run the test

## Deploy SDK.


The library is deployed via cocoa pods whos documents for doing this are at
[![cocoapods depoly](https://guides.cocoapods.org/making/getting-setup-with-trunk)]() 


## First time you have done a deploy for any SDK

1) pod trunk register [your email] '[your name]' --description='[something descriptive]'
2) once you have done this check your email and click the link
3) add a project admin to add your email addres to the project using the command pod trunk add-owner SuperAwesome [yourEmail]


## Before you deploy - SuperAwsome SDK

1) run `cd [your/project/sa-mobile-sdk-ios]`

2) run the pod lint with
`pod spec lint SuperAwesome.podspec` 
and resolve any errors

3) add a git tag with the name of the new version making sure it matches the version in the pod spec
    eg `git tag 1.2.3`  then run 
    `git push --tags`
 
4) `pod trunk push SuperAwesome.podspec --allow-warnings`
 
 - note you must update the spec source to the latest tag and the validation perfomed by pods is of the tagged version not the latest commit in git

## Deploy - SuperAwsome ADMob SDK

The same process as above except
`pod trunk push SuperAwesomeAdMob.podspec --allow-warnings`
