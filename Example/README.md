## Examples:
### Implementation:
1. Using a UIViewController, please see: `AccordionViewController`
2. Using a UITableViewController, please see: `AccordionTableViewController`

### Behaviors:
The library supports the following behaviors: 
1. Multiple parent cells can be open at once (Example: [AccordionViewController](https://github.com/Vkt0r/AccordionSwift/blob/master/Example/Views/AccordionViewController.swift))
2. Only one parent cell can be opened at once (Example: [AccordionTableViewController](https://github.com/Vkt0r/AccordionSwift/blob/master/Example/Views/AccordionTableViewController.swift))

The default behavior is to allow multiple parent cells to be open at once. The behavior can be changed by setting the `numberOfExpandedParentCells` in the `DataProvider` constructor to either `.single` or `.multiple`. One can also specify an element to be expanded initially, this can be achieved by setting the `numberOfExpandedParentCells` to `.single` and by setting the state of the `Parent` to `.expanded` (See [example](https://github.com/Vkt0r/AccordionSwift/blob/master/Example/Views/AccordionTableViewController.swift))

```swift
DataSourceProvider(
    dataSource: dataSource,
    parentCellConfig: parentCellConfig,
    childCellConfig: childCellConfig,
    didSelectParentAtIndexPath: didSelectParentCell,
    didSelectChildAtIndexPath: didSelectChildCell,
    scrollViewDidScroll: scrollViewDidScroll,
    // Configure DataSourceProvider to have only one parent expanded at a time
    numberOfExpandedParentCells: .single // .multiple
)
```