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
        
    func childItem(atRow row: Int, inSection section: Int, parentIndex: Int, currentPos: Int) -> Item.ChildItem?
    
    /// - Parameter section: A section in the data source.
    /// - Returns: The header title for the specified section.
    func headerTitle(inSection section: Int) -> String?
    
    /// - Parameter section: A section in the data source.
    /// - Returns: The footer title for the specified section.
    func footerTitle(inSection section: Int) -> String?
    
    func findParentOfCell(atIndexPath indexPath: IndexPath) -> ParentResult
    
    mutating func expandParent(atIndexPath indexPath: IndexPath, parentIndex: Int)
    
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
} 
