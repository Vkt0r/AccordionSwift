//
//  DataSourceProvider.swift
//  AccordionSwift
//
//  Created by Victor Sigler Lopez on 7/3/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import Foundation

public final class DataSourceProvider<DataSource: DataSourceType, CellConfig: CellViewConfigType>
where DataSource.Item == CellConfig.Item {
    
    // MARK: - Properties
    
    /// The data source.
    public var dataSource: DataSource
    
    /// The cell configuration.
    public let cellConfig: CellConfig
    
    private var _tableViewDataSource: TableViewDataSource?
    
    // MARK: - Initialization
    
    /// Initializes a new data source provider.
    ///
    /// - Parameters:
    ///   - dataSource: The data source.
    ///   - cellConfig: The cell configuration.
    public init(dataSource: DataSource, cellConfig: CellConfig) {
        self.dataSource = dataSource
        self.cellConfig = cellConfig
    }
}

extension DataSourceProvider {
    
    // MARK: - UITableViewDataSource
    
    /// The UITableViewDataSource protocol handler
    public var tableViewDataSource: UITableViewDataSource {
        if _tableViewDataSource == nil {
            _tableViewDataSource = configTableViewDataSource()
        }
        
        return _tableViewDataSource!
    }
    
    private func configTableViewDataSource() -> TableViewDataSource {
        
        let dataSource = TableViewDataSource(
            numberOfSections: { [unowned self] () -> Int in
                return self.dataSource.numberOfSections()
            }, 
            numberOfItemsInSection:  { [unowned self] (section) -> Int in
                return self.dataSource.numberOfItems(inSection: section)
        })
        
        dataSource.tableCellForRowAtIndexPath = { [unowned self] (tableView, indexPath) -> UITableViewCell in
            let item = self.dataSource.item(at: indexPath)!
            return self.cellConfig.tableCellFor(item: item, tableView: tableView, indexPath: indexPath)
        }
        
        dataSource.tableTitleForHeaderInSection = { [unowned self] (section) -> String? in
            return self.dataSource.headerTitle(inSection: section)
        }
        
        dataSource.tableTitleForFooterInSection = { [unowned self] (section) -> String? in
            return self.dataSource.footerTitle(inSection: section)
        }
        
        return dataSource
    }
}

