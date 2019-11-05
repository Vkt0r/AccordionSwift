<p align="center">
  <img src="repo-logo.png" alt="Accordion Custom Image" width=650/>
</p>

<p align="center">
    <a href="https://cocoapods.org/pods/AccordionSwift">
        <img src="https://img.shields.io/cocoapods/v/AccordionSwift.svg?style=flat"
             alt="Pods Version">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/Swift-5.0-orange.svg"
             alt="Swift Version">
    </a>
    <a href="http://mit-license.org">
        <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat"
             alt="License Type">
    </a>
</p>

----------------

_An accordion/dropdown menu to integrate in your projects. This library is protocol oriented, type safe and the new version is inspired in [JSQDataSourcesKit](https://github.com/jessesquires/JSQDataSourcesKit) by Jesse Squires_.


|         | Main Features  |
----------|-----------------
📱 | Compatible with iPhone / iPad
🔨 | Fully customizable cells
🚒 | Supports device rotation
🔥 | Written completely in Swift 


## Requirements 💥
- iOS 10.0+
- Xcode 10.2+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build AccordionSwift 2.0.0+.

To integrate AccordionSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'AccordionSwift', '~> 2.0.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate AccordionSwift into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Vkt0r/AccordionSwift" ~> 2.0.0
```

## Usage ✨
After importing the framework, the library can be used in a `UITableViewController` or a `UIViewController` and offers full customization of the cells and data source:

```swift
import UIKit
import AccordionSwift

class AccordionViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Typealias
    
    typealias ParentCellModel = Parent<GroupCellModel, CountryCellModel>
    typealias ParentCellConfig = CellViewConfig<ParentCellModel, UITableViewCell>
    typealias ChildCellConfig = CellViewConfig<CountryCellModel, CountryTableViewCell>
    
    // MARK: - Properties
    
    /// The Data Source Provider with the type of DataSource and the different models for the Parent and Chidl cell.
    var dataSourceProvider: DataSourceProvider<DataSource<ParentCellModel>, ParentCellConfig, ChildCellConfig>?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDataSource()
        
        navigationItem.title = "World Cup 2018"
    }
}
```
The above example shows how to define a `CellViewConfig` for the parent and child cells respectively and how to define the `Parent` model. 

```swift
/// Defines a cell config type to handle a UITableViewCell
public protocol CellViewConfigType {
    
    // MARK: Associated types
    
    /// The type of elements backing the collection view or table view.
    associatedtype Item
    
    /// The type of views that the configuration produces.
    associatedtype Cell: UITableViewCell
    
    // MARK: Methods
    
    func reuseIdentiferFor(item: Item?, indexPath: IndexPath) -> String
    
    @discardableResult
    func configure(cell: Cell, item: Item?, tableView: UITableView, indexPath: IndexPath) -> Cell
}
```

Another step is to define the `DataSourceProvider` in charge of handling the data source and the `CellViewConfig` for each cell. 
The `DataSourceProvider` exposes the `numberOfExpandedParentCells` attribute which can be used to change the behavior of the accordion to only have a `single` item open at once or to have `multiple` items open at any given time. Take note that the default behavior is to have multiple items open.

For a more detailed guide please see the [Example](https://github.com/Vkt0r/AccordionSwift/tree/master/Example) project.

## Screenshots
<img src="https://user-images.githubusercontent.com/30416075/66836060-f2263580-ef60-11e9-9ee5-a46d6c24ca10.png" alt="screenshot" width="450"/>

#### Example of multiple cells open at a time
<img src="https://user-images.githubusercontent.com/30416075/66833387-09aeef80-ef5c-11e9-983c-552b2bed5fd9.gif" alt="screenshot" width="450"/>

#### Example of single cells open at a time
<img src="https://user-images.githubusercontent.com/30416075/66833395-0f0c3a00-ef5c-11e9-9a98-5ccf65a875c9.gif" alt="screenshot" width="450"/>

## TODO

- [ ] Add unit tests for the library.
- [ ] Add CircleCI integration.


## Feedback

## I've found a bug, or have a feature request

Please raise a [GitHub issue](https://github.com/Vkt0r/AccordionMenu/issues). 😱

## Interested in contributing?

Great! Please launch a [pull request](https://github.com/Vkt0r/AccordionMenu/pulls). 👍

---------------------------------------

License:
=================
The MIT License. See the [LICENSE file](LICENSE) for more information.
