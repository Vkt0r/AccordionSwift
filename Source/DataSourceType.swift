//
//  DataSourceType.swift
//  AccordionSwift
//
//  Created by Victor Sigler Lopez on 7/3/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import Foundation

/// Defines a sectioned data source to be displayed in the UITableView
public protocol DataSourceType {
    
    // MARK: - Associated Type
    
    /// The type of items in the data source.
    associatedtype Item: ParentType
    
    // MARK: - Typealias
    
    /// An typealias with the position of the parent cell, if the current cell is parent or not and its current position
    typealias ParentResult = (parentPosition: Int, isParent: Bool, currentPos: Int)
    
    // MARK: - Methods
    
    /// - Returns: The number of items in the specified section.
    func numberOfSections() -> Int
    
    /// - Parameter section: A section index in the data source.
    /// - Returns: The number of items in the specified section.
    func numberOfItems(inSection section: Int) -> Int
    
    /// - Parameter section: A section in the data source.
    /// - Returns: The items in the specified section.
    func items(inSection section: Int) -> [Item]?
   
    /// - Parameters:
    ///   - row: A row index in the data source.
    ///   - section:  A section index in the data source.
    /// - Returns: The item specified by the section number and row number, otherwise nil.
    func item(atRow row: Int, inSection section: Int) -> Item?
    
    /// - Parameters:
    ///   - row: A row index in the data source.
    ///   - section: A section index in the data source.
    ///   - parentIndex: The index of the parent cell.
    ///   - currentPos: The current position in the data source.
    /// - Returns: The child item specified by the by the section number, row number, parent index and current position
    func childItem(atRow row: Int, inSection section: Int, parentIndex: Int, currentPos: Int) -> Item.ChildItem?
    
    /// - Parameter section: A section in the data source.
    /// - Returns: The header title for the specified section.
    func headerTitle(inSection section: Int) -> String?
    
    /// - Parameter section: A section in the data source.
    /// - Returns: The footer title for the specified section.
    func footerTitle(inSection section: Int) -> String?
    
    /// Expand the parent cell in the data source.
    ///
    /// - Parameters:
    ///   - indexPath: The index path in the data source.
    ///   - parentIndex: The index of the parent to expand.
    mutating func expandParent(atIndexPath indexPath: IndexPath, parentIndex: Int)
    
    /// Collapse the parent cell in the data source.
    ///
    /// - Parameters:
    ///   - indexPath: The index path in the data source.
    ///   - parentIndex: The index of the parent to expand.
    mutating func collapseChilds(atIndexPath indexPath: IndexPath, parentIndex: Int)
}

extension DataSourceType {
    
    /// Get the item at the specified IndexPath
    ///
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: The item specified by indexPath, otherwise nil.
    public func item(at indexPath: IndexPath) -> Item? {
        return item(atRow: indexPath.row, inSection: indexPath.section)
    }
    
    public func childItem(at indexPath: IndexPath, parentIndex: Int, currentPos: Int) -> Item.ChildItem? {
        return childItem(atRow: indexPath.row, inSection: indexPath.section, parentIndex: parentIndex, currentPos: currentPos)
    }
    
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: A tuple with the position of the parent cell, true if the current row is parent, otherwise false and the current position in the data source.
    public func findParentOfCell(atIndexPath indexPath: IndexPath) -> ParentResult {
        let row = indexPath.row
        guard let items = items(inSection: indexPath.section) else { return (0, true, 0) }
        return self.findParentOfCell(atRow: row, itemsInSection: items)
    }
    
    /// - Parameters:
    ///   - row: A row index in the data source.
    ///   - items: The items in the specified section.
    /// - Returns: A tuple with the position of the parent cell, true if the current row is parent, otherwise false and the current position in the data source.
    private func findParentOfCell(atRow row: Int, itemsInSection items: [Item]) -> ParentResult {
        
        guard row > 0 else { return (0, true, 0) }
        
        var position = 0
        var parent = 0
        var item = items[parent]
        
        repeat {
            position += (item.state == .expanded) ? item.childs.count + 1 : 1
            parent += 1
            
            // check for the boundaries of the data source
            if parent < items.count {
                item = items[parent]
            }
            
        } while (position < row)
        
        // if it is a parent cell then the indexes should be equal
        guard position != row else { return (parent, position == row, position) }
        item = items[parent - 1]
        return (parent - 1, position == row, position - item.childs.count - 1)
    }
} 
