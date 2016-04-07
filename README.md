# Notificator

[![CI Status](http://img.shields.io/travis/Bell App Lab/Notificator.svg?style=flat)](https://travis-ci.org/Bell App Lab/Notificator)
[![Version](https://img.shields.io/cocoapods/v/Notificator.svg?style=flat)](http://cocoapods.org/pods/Notificator)
[![License](https://img.shields.io/cocoapods/l/Notificator.svg?style=flat)](http://cocoapods.org/pods/Notificator)
[![Platform](https://img.shields.io/cocoapods/p/Notificator.svg?style=flat)](http://cocoapods.org/pods/Notificator)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8.0+

## Installation

### CocoaPods

Notificator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Notificator"
```

### Git Submodules

**Why submodules, you ask?**

Following [this thread](http://stackoverflow.com/questions/31080284/adding-several-pods-increases-ios-app-launch-time-by-10-seconds#31573908) and other similar to it, and given that Cocoapods only works with Swift by adding the use_frameworks! directive, there's a strong case for not bloating the app up with too many frameworks. Although git submodules are a bit trickier to work with, the burden of adding dependencies should weigh on the developer, not on the user. :wink:

To install Notificator using git submodules:

```
cd toYourProjectsFolder
git submodule add -b Submodule --name Notificator https://github.com/BellAppLab/Notificator.git
```

Navigate to the new Notificator folder and drag the Pods folder to your Xcode project.

## Author

Bell App Lab, apps@bellapplab.com

## License

Notificator is available under the MIT license. See the LICENSE file for more info.
