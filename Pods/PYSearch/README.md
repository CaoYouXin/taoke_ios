# PYSearch

[![Build Status](https://travis-ci.org/iphone5solo/PYSearch.svg?branch=master)](https://travis-ci.org/iphone5solo/PYSearch)
[![Pod Version](http://img.shields.io/cocoapods/v/PYSearch.svg?style=flat)](http://cocoadocs.org/docsets/PYSearch/)
[![Pod Platform](http://img.shields.io/cocoapods/p/PYSearch.svg?style=flat)](http://cocoadocs.org/docsets/PYSearch/)
[![Pod License](http://img.shields.io/cocoapods/l/PYSearch.svg?style=flat)](https://opensource.org/licenses/MIT)

- 🔍 An elegant search controller for iOS.

## QQ chat room
 <img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/QQChatRoomForPYSearch.jpg" width="200">

## Features
- [x] Support a variety of hot search style
- [x] Support a variety of search history style
- [x] Support a variety of search results display mode
- [x] Support search suggestions
- [x] Support search history (record) cache
- [x] Support callback using delegate or block completion search
- [x] Support CocoaPods
- [x] Support localization
- [x] Support vertical and horizontal screen on iPhone and iPad

## Requirements
* iOS 7.0 or later
* Xcode 7.0 or later

## Architecture
### Main
- `PYSearch`
- `PYSearchConst`
- `PYSearchViewController`
- `PYSearchSuggestionViewController`

### Category
- `UIColor+PYSearchExtension`
- `UIView+PYSearchExtension`
- `NSBundle+PYSearchExtension`

## Contents
* Getting Started
  * [Renderings](#Renderings)
  * [Styles](#Styles)
  
* Usage
  * [How to use](#Howtouse)
  * [Details (See the example program PYSearchExample for details)](#Details)
  * [Custom](#Custom)
  
* [Hope](#Hope)

## <a id="Renderings"></a>Renderings

<img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/PYSearchDemo.gif" width="375"> 

## <a id="Styles"></a>Styles

#### Hot search style
<img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/hotSearchStyle01.png" width="375"> <img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/hotSearchStyle02.png" width="375"><br><img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/hotSearchStyle03.png" width="375"> <img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/hotSearchStyle04.png" width="375"><br><img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/hotSearchStyle05.png" width="375"> <img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/hotSearchStyle06.png" width="375"> 

#### Search history style
<img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/searchHistoryStyle01.png" width="375"> <img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/searchHistoryStyle02.png" width="375"><br><img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/searchHistoryStyle03.png" width="375"> <img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/searchHistoryStyle04.png" width="375"><br><img src="https://github.com/iphone5solo/learngit/raw/master/imagesForPYSearch/searchHistoryStyle05.png" width="375">

## <a id="Howtouse"></a>How to use
* Use CocoaPods:
  - `pod "PYSearch"`
  - Import the main file：`#import <PYSearch.h>`
* Manual import：
  - Drag All files in the `PYSearch` folder to project
  - Import the main file：`#import "PYSearch.h"`
  
  
## <a id="Details"></a>Details (See the example program PYSearchExample for details)
```objc
    // 1. Create hotSearches array
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create searchViewController
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"Search programming language" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Call this Block when completion search automatically
        // Such as: Push to a view controller
        [searchViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
        
    }];
    // 3. present the searchViewController
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];

```

## <a id="Custom"></a>Custom

* Custom search suggestions display
```objc
// 1. Set dataSource
searchViewController.dataSource = self;
// 2. Implement dataSource method
```

* Custom search result dispaly
```objc
// 1. Set searchResultShowMode
searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
// 2. Set searchResultController 
searchViewController.searchResultController = [[UIViewController alloc] init];
```

* Set hotSearchStyle（default is PYHotSearchStyleNormalTag）
```objc
// Set hotSearchStyle
searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
```

* Set searchHistoryStyle（default is PYS
