# TabLayoutView

[![Language](https://img.shields.io/badge/language-Swift%204.0-orange.svg)](https://swift.org/)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TabLayoutView.svg)](https://img.shields.io/cocoapods/v/TabLayoutView.svg)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/dtrisciuoglio/TabLayoutView/blob/master/LICENSE)
[![Email](https://img.shields.io/badge/email-trisci.dario@gmail.com-grey.svg)](mailto:trisci.dario@gmail.com)

A `TabLayoutView` object is a horizontal control made of multiple tabs, each tab functioning as a discrete button.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

**TabLayoutView**

``` swift
    // Initialize the tab layout view
    let origin = CGPoint(x: 0, y: 0)
    let size = CGSize(width: 280, height: 44)
    let frame = CGRect(origin:origin, size:size)
    let tabLayoutView = TabLayoutView(frame: frame)
    tabLayoutView.center = self.view.center
    
    // Set the type
    tabLayoutView.type = .normal
    
    // Set the indicator position
    tabLayoutView.indicatorPosition = .bottom
    
    // Set the indicator color
    tabLayoutView.indicatorColor = .red
    
    // Set the font color
    tabLayoutView.fontColor = .red
    
    // Set the font selected color
    tabLayoutView.fontSelectedColor = .black
    
    // Set the items
    tabLayoutView.items = ["Test A", "Test B", "Test C", "Test D", "Test E", "Test F", "Test G", "Test H", "Test I", "Test L"]
    
    // Set the delegate
    tabLayoutView.delegate = self

    // Add it as a subview
    self.view.addSubview(tabLayoutView)

```

Also support xib and storyboard


## Requirements

* iOS 9.0+
* Xcode 9.0.0
* Swift 4.0+

## Installation
**CocoaPods**

You can use [CocoaPods](http://cocoapods.org) to install TabLayoutView by adding it to your Podfile:

```
   
   platform :ios, '9.0'
   use_frameworks!
   pod "TabLayoutView"
   
```

## Author

Dario Trisciuoglio

## License

TabLayoutView is available under the MIT license. See the LICENSE file for more info.
