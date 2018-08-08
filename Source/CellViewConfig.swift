//
//  ViewCellConfigurator.swift
//  AccordionSwift
//
//  Created by Victor Sigler Lopez on 7/3/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import Foundation

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

extension CellViewConfigType {
    
    public func tableCellFor(item: Item, tableView: UITableView, indexPath: IndexPath) -> Cell {
        let reuseIdentifier = reuseIdentiferFor(item: item, indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        return configure(cell: cell, item: item, tableView: tableView, indexPath: indexPath)
    }
}

public struct CellViewConfig<Item, CellType: UITableViewCell>: CellViewConfigType {
    
    // MARK: Type aliases
    
    public typealias Cell = CellType
    
    public typealias CellConfigurator = (Cell, Item?, UITableView, IndexPath) -> Cell
    
    // MARK: Properties
    
    /// A unique identifier that describes the purpose of the cells that the config produces.
    /// The config dequeues cells from the collection view or table view with this reuse identifier.
    ///
    /// - Note: Clients are responsible for registering a cell for this identifier with the collection view or table view.
    public let reuseIdentifier: String
    
    /// A closure used to configure the views.
    public let cellConfigurator: CellConfigurator
    
    // MARK: Initialization
    
    /// Constructs a new reusable view config.
    ///
    /// - Parameters:
    ///   - reuseIdentifier: The reuse identifier with which to dequeue reusable views.
    ///   - cellConfigurator: The closure with which to configure views.
    public init(reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    public func reuseIdentiferFor(item: Item?, indexPath: IndexPath) -> String {
        return reuseIdentifier
    }
    
    public func configure(cell view: Cell, item: Item?, tableView: UITableView, indexPath: IndexPath) -> Cell {
        return cellConfigurator(view, item, tableView, indexPath)
    }
}
