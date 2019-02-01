//
//  Section.swift
//  AccordionSwift
//
//  Created by Victor Sigler Lopez on 7/3/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import Foundation

/// Defines a section of items
public struct Section<Item: ParentType> {
    
    // MARK: - Properties
    
    /// The elements in the section.
    public var items: [Item]
    
    /// The header title for the section.
    public let headerTitle: String?
    
    /// The footer title for the section.
    public let footerTitle: String?
    
    /// The number of elements in the section.
    public var count: Int {
        return items.count
    }
    
    /// The number of elements in the section for collapsed and expanded
    public var total: Int
    
    // MARK: - Initialization
    
    /// Constructs a new section.
    ///
    /// - Parameters:
    ///   - items: The elements in the section.
    ///   - headerTitle: The section header title.
    ///   - footerTitle: The section footer title.
    public init(items: Item..., headerTitle: String? = nil, footerTitle: String? = nil) {
        self.init(items, headerTitle: headerTitle, footerTitle: footerTitle)
    }
    
    /// Constructs a new section.
    ///
    /// - Parameters:
    ///   - items: The elements in the section.
    ///   - headerTitle: The section header title.
    ///   - footerTitle: The section footer title.
    public init(_ items: [Item], headerTitle: String? = nil, footerTitle: String? = nil) {
        self.items = items
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.total = items.reduce(0) { (numberOfItems, cell) -> Int in
            let isExpanded = cell.state == .expanded
            return numberOfItems + (isExpanded ? cell.childs.count + 1 : 1)
        }
    }
    
    // MARK: - Subscript
    
    /// - Parameter index: The index of the item to return.
    /// - Returns: The item at `index`.
    public subscript (index: Int) -> Item {
        get { return items[index] }
        set { items[index] = newValue }
    }
}
