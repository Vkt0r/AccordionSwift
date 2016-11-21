<p align="center">
  <img src="https://github.com/Vkt0r/AccordionMenu/blob/master/logo.png" alt="Accordion Custom Image"/>
</p>


</br>

<p align="center">
  <img src="https://github.com/Vkt0r/AccordionMenu/blob/master/iPhones.png" alt="Accordion Custom Image"/>
</p>


[![Build Status](https://travis-ci.org/Vkt0r/AccordionMenu.svg?branch=master)](https://travis-ci.org/Vkt0r/AccordionMenu)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat
            )](http://mit-license.org)
[![Language](http://img.shields.io/badge/language-swift-orange.svg?style=flat
             )](https://developer.apple.com/swift)
[![Platform](http://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat
             )](https://developer.apple.com/resources/)

AccordionMenu is an accordion/dropdown library written in Swift.


## Features

- [x] Compatible with iPhone / iPad
- [x] Fully customizable
- [x] Supports device rotation

## Requirements

- iOS 8.0+
- Xcode 8.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build Alamofire 4.0.0+.

To integrate AccordionMenuSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'AccordionMenuSwift', '~> 1.2.5'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

After import the framework it's neccessary to inherit from the class `AccordionTableViewController` and set it's data source the total of items from the data source and if you like if several cells is expanded or only one like in the following example:

```swift
import UIKit
import AccordionMenuSwift

class AccordionViewController: AccordionTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let item1 = Parent(state: .collapsed, childs: ["SubItem 1", "SubItem 2", "SubItem 3"], title: "Item 1")
        let item2 = Parent(state: .collapsed, childs: ["SubItem 1", "SubItem 2"], title: "Item 2")
        let item3 = Parent(state: .collapsed, childs: ["SubItem 1", "SubItem 2", "SubItem 3"], title: "Item 3")
        let item4 = Parent(state: .collapsed, childs: ["SubItem 1", "SubItem 2"], title: "Item 4")
        let item5 = Parent(state: .collapsed, childs: ["SubItem 1", "SubItem 2"], title: "Item 5")

        self.dataSource = [item1, item2, item3, item4, item5]
        self.numberOfCellsExpanded = .several
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

```

Afterwards it's necessary to define two cells in the `UITableView` with the identifiers `"ParentCell"` and `"ChildCell"` and set its `Style` to **Basic** to add two `UILabels` for the cells.

You can see the Example project for more information in how to integrate it.

## ToDo

- [ ] Add Carthage support.
- [ ] Add suport to be notified when cell is tapped using closures.
- [ ] Add support for multiple levels
- [ ] Improve the integration with functional programming


## Feedback

## I've found a bug, or have a feature request

Please raise a [GitHub issue](https://github.com/Vkt0r/AccordionMenu/issues). 😱

## Interested in contributing?

Great! Please launch a [pull request](https://github.com/Vkt0r/AccordionMenu/pulls). 👍

---------------------------------------

License:
=================
The MIT License. See the LICENSE file for more infomation.
