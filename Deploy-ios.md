
The library is deployed via cocoa pods whos documents for doing this are at
[![cocoapods depoly](https://guides.cocoapods.org/making/getting-setup-with-trunk)]() 


## First time you have done a deploy

1) pod trunk register [your email] '[your name]' --description='[something descriptive]'
2) once you have done this check your email and click the link
3) add a project admin to add your email addres to the project using the command pod trunk add-owner SuperAwesome [yourEmail]


## Before you deploy
1) run the pod lint with
`pod spec lint SuperAwesome.podspec` 
and resolve any errors

2) add a git tag with the name of the new version making sure it matches the version in the pod spec
eg `git tag 1.2.3`  then run 
`git push --tags`
 then `pod trunk push SuperAwesome.podspec`
 
 - note you must update the spec source to the latest tag and the validation perfomed by pods is of the tagged version not the latest commit in git


