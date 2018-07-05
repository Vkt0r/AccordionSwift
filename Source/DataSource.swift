//
//  DataSource.swift
//  AccordionSwift
//
//  Created by Victor Sigler Lopez on 7/3/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import Foundation

public struct DataSource<Item: ParentType> {
    
    // MARK: - Properties
    
    /// The sections in the data source.
    public var sections: [Section<Item>]
    
    // MARK: -  Initialization
    
    /// Constructs a new DataSource.
    ///
    /// - Parameter sections: The sections for the data source.
    public init(_ sections: [Section<Item>]) {
        self.sections = sections
    }
    
    /// Constructs a new DataSource.
    ///
    /// - Parameter sections: The sections for the data source.
    public init(sections: Section<Item>...) {
        self.sections = sections
    }
    
    // MARK: - Methods
    
    /// Inserts the item at the specified index path
    ///
    /// - Parameters:
    ///   - item: The item to be inserted.
    ///   - indexPath: The index path specifying the location for the item.
    public mutating func insert(item: Item, at indexPath: IndexPath) {
        insert(item: item, atRow: indexPath.row, inSection: indexPath.section)
    }
    
    /// Inserts the item at the specified row and section.
    ///
    /// - Parameters:
    ///   - item: The item to insert.
    ///   - row:  The row index of the item.
    ///   - section: The section index of the item.
    public mutating func insert(item: Item, atRow row: Int, inSection section: Int) {
        guard section < numberOfSections() else { return }
        guard row <= numberOfItems(inSection: section) else { return }
        sections[section].items.insert(item, at: row)
    }
    
    /// Add the item at the specified section.
    ///
    /// - Parameters:
    ///   - item:  The item to be added.
    ///   - section: The section location for the item.
    public mutating func append(_ item: Item, inSection section: Int) {
        guard let items = items(inSection: section) else { return }
        insert(item: item, atRow: items.endIndex, inSection: section)
    }
    
    /// Removes the item at the specified row and section.
    ///
    /// - Parameters:
    ///   - row: The row location of the item.
    ///   - section: The section location of the item.
    /// - Returns: The item removed, otherwise nil if it does not exist.
    @discardableResult
    public mutating func remove(atRow row: Int, inSection section: Int) -> Item? {
        guard item(atRow: row, inSection: section) != nil else { return nil }
        return sections[section].items.remove(at: row)
    }
    
    /// Removes the item at the specified index path.
    ///
    /// - Parameter indexPath: The index path specifying the location of the item.
    /// - Returns:  The item at `indexPath`, otherwise nil if it does not exist.
    @discardableResult
    public mutating func remove(at indexPath: IndexPath) -> Item? {
        return remove(atRow: indexPath.row, inSection: indexPath.section)
    }
    
    // MARK: - Subscripts
    
    /// The section at the specified index.
    ///
    /// - Parameter index: The index of a section.
    public subscript (index: Int) -> Section<Item> {
        get { return sections[index] }
        set { sections[index] = newValue }
    }
    
    /// The item at the specified index path.
    ///
    /// - Parameter indexPath: The index path of an item.
    public subscript (indexPath: IndexPath) -> Item {
        get { return sections[indexPath.section].items[indexPath.row] }
        set { sections[indexPath.section].items[indexPath.row] = newValue }
    }
}

extension DataSource: DataSourceType {
    
    // MARK: - DataSourceType Methods
    
    public func numberOfSections() -> Int {
        return sections.count
    }
    
    public func numberOfItems(inSection section: Int) -> Int {
        guard section < sections.count else { return 0 }
        return sections[section].total
    }
    
    public func items(inSection section: Int) -> [Item]? {
        guard section < sections.count else { return nil }
        return sections[section].items
    }
    
    public func item(atRow row: Int, inSection section: Int) -> Item? {
        guard let items = items(inSection: section) else { return nil }
        guard row < items.count else { return nil }
        return items[row]
    }
    
    public func headerTitle(inSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].headerTitle
    }
    
    public func footerTitle(inSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].footerTitle
    }
    
    public func findParentOfCell(atIndexPath indexPath: IndexPath) -> ParentResult {
        let row = indexPath.row
        guard let items = items(inSection: indexPath.section) else { return (0, true, 0) }
        return self.findParentOfCell(atRow: row, itemsInSection: items)
    }
    
    public func childItem(atRow row: Int, inSection section: Int, parentIndex: Int, currentPos: Int) -> Item.ChildItem? {
        guard let items = items(inSection: section) else { return nil }
        return items[parentIndex].childs[row - currentPos - 1]
    }
    
    public mutating func expandParent(atIndexPath indexPath: IndexPath, parentIndex: Int) {
        let section = indexPath.section
        guard var items = items(inSection: section) else { return }
        items[parentIndex].state = .expanded
        sections[section].total += items.count
    }
    
    public mutating func collapseChilds(atIndexPath indexPath: IndexPath, parentIndex: Int) {
        let section = indexPath.section
        guard var items = items(inSection: section) else { return }
        items[parentIndex].state = .collapsed
        sections[section].total -= items.count
    }
}

extension DataSource {
    
    // MARK: - Methods
    
    private func findParentOfCell(atRow row: Int, itemsInSection items: [Item]) -> ParentResult {
        
        guard row > 0 else { return (0, true, 0) }
        
        var position = 0
        var parent = 0
        var item = items[parent]
        
        repeat {
            switch (item.state) {
            case .expanded:
                position += item.childs.count + 1
            case .collapsed:
                position += 1
            }
            
            parent += 1
            
            // if is not outside of the data source boundaries
            if parent < items.count {
                item = items[parent]
            }
            
        } while (position < row)
        
        // if is a parent cell the indexes are equal
        guard position != row else  { return (parent, position == row, position) }
        item = items[parent - 1]
        return (parent - 1, position == row, position - item.childs.count - 1)
    }
}
