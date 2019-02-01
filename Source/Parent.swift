//
//  Parent.swift
//  AccordionSwift
//
//  Created by Victor Sigler Lopez on 7/5/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import Foundation

/// Defines the state of a cell
public enum State {
    case collapsed
    case expanded
}

public protocol ParentType {
    
    // MARK: - Associated Types
    
    /// The type of item in the ParentType
    associatedtype Item
    
    /// The type of item in the Child
    associatedtype ChildItem
    
    /// The current state of the cell
    var state: State { get set }
    
    /// The item in the parent cell
    var item: Item { get }
    
    /// The childs of the cell
    var childs: [ChildItem] { get }
}

/// Defines the Parent model for the cells
public class Parent<Item, ChildItem>: ParentType {
    
    // MARK: - Properties
    
    /// The current state of the cell
    public var state: State
    
    /// The item in the parent cell
    public let item: Item
    
    /// The childs of the cell
    public let childs: [ChildItem]
    
    // MARK: - Initializer
    
    /// Construct a new Parent model
    ///
    /// - Parameters:
    ///   - state: The state of the cell
    ///   - item: The item in the cell
    ///   - childs: The childs assigned to the cell
    public init(state: State = .collapsed, item: Item, childs: [ChildItem]) {
        self.state = state
        self.item = item
        self.childs = childs
    }
}
