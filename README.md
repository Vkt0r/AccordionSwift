<p align="center">
  <img src="https://github.com/Vkt0r/AccordionMenu/blob/master/Group.png" alt="Accordion Custom Image"/>
</p>


</br>

<p align="center">
  <img src="https://github.com/Vkt0r/AccordionMenu/blob/master/Apple iPhone 6s Silver.png" alt="Accordion Custom Image"/>
</p>


[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat
            )](http://mit-license.org)
[![Language](http://img.shields.io/badge/language-swift-orange.svg?style=flat
             )](https://developer.apple.com/swift)
[![Platform](http://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat
             )](https://developer.apple.com/resources/)
            
AccordionMenu is an accordion libray written in Swift.


## Height for the parent and child cells

The height for the parent cells and child cell can be modified in an easy way using the function `tableView(_:heightForRowAtIndexPath:)` according to your needs.

```swift
override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return !self.findParent(indexPath.row).isParentCell ? 44.0 : 64.0
}
```

---
# Feedback

## I've found a bug, or have a feature request

Please raise a [GitHub issue](https://github.com/Vkt0r/AccordionMenu/issues). 😱

## Interested in contributing?

Great! Please launch a [pull request](https://github.com/Vkt0r/AccordionMenu/pulls). 👍

---------------------------------------

License:
=================
The MIT License. See the LICENSE file for more infomation.

 
