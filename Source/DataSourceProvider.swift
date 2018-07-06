//
//  DataSourceProvider.swift
//  AccordionSwift
//
//  Created by Victor Sigler Lopez on 7/3/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import Foundation

public final class DataSourceProvider<DataSource: DataSourceType, 
    ParentCellConfig: CellViewConfigType, 
    ChildCellConfig: CellViewConfigType>
where ParentCellConfig.Item == DataSource.Item, ChildCellConfig.Item == DataSource.Item.ChildItem {
    
    // MARK: - Properties
    
    /// The data source.
    public var dataSource: DataSource
    
    /// The parent cell configuration.
    public let parentCellConfig: ParentCellConfig
    
    /// The child cell configuration.
    public let childCellConfig: ChildCellConfig
    
    /// The UITableViewDataSource
    private var _tableViewDataSource: TableViewDataSource?
    
    /// The UITableViewDelegate
    private var _tableViewDelegate: TableViewDelegate?
    
    // MARK: - Initialization
    
    /// Initializes a new data source provider.
    ///
    /// - Parameters:
    ///   - dataSource: The data source.
    ///   - cellConfig: The cell configuration.
    public init(dataSource: DataSource, 
                parentCellConfig: ParentCellConfig,
                childCellConfig: ChildCellConfig) {
        self.dataSource = dataSource
        self.parentCellConfig = parentCellConfig
        self.childCellConfig = childCellConfig
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
            
            let (parentPosition, isParent, currentPos) = self.dataSource.findParentOfCell(atIndexPath: indexPath)
            
            guard isParent else {
                let item = self.dataSource.childItem(at: indexPath, parentIndex: parentPosition, currentPos: currentPos)
                return self.childCellConfig.tableCellFor(item: item!, tableView: tableView, indexPath: indexPath)
            }
            
            let item = self.dataSource.item(at: IndexPath(item: parentPosition, section: indexPath.section))!
            return self.parentCellConfig.tableCellFor(item: item, tableView: tableView, indexPath: indexPath)
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

extension DataSourceProvider {
    
    // MARK: - UITableViewDelegate
    
    /// The UITableViewDataSource protocol handler
    public var tableViewDelegate: UITableViewDelegate {
        if _tableViewDelegate == nil {
            _tableViewDelegate = configTableViewDelegate()
        }
        
        return _tableViewDelegate!
    }
    
    private func configTableViewDelegate() -> TableViewDelegate {
        
        let delegate = TableViewDelegate()
        
        delegate.didSelectRowAtIndexPath = { [unowned self] (tableView, indexPath) -> Void in
            let (parentIndex, isParent, _) = self.dataSource.findParentOfCell(atIndexPath: indexPath)
            
            if isParent {
                tableView.beginUpdates()
                
                let item = self.dataSource.item(atRow: parentIndex, inSection: indexPath.section)
                
                switch (item!.state) {
                case .expanded:
                    
                    let numberOfChilds = item!.childs.count
                    let indexPaths = (parentIndex + 1...parentIndex + numberOfChilds)
                        .map { IndexPath(row: $0, section: indexPath.section)}
                    
                    tableView.deleteRows(at: indexPaths, with: .fade)
                    self.dataSource.collapseChilds(atIndexPath: indexPath, parentIndex: parentIndex)
                
                case .collapsed:
                    
                    let numberOfChilds = item!.childs.count
                    var insertPos = indexPath.row + 1
                    
                    let indexPaths = (0..<numberOfChilds)
                        .map { _ -> IndexPath in
                            let indexPath = IndexPath(row: insertPos, section: indexPath.section)
                            insertPos += 1
                            return indexPath
                    }
                    
                    tableView.insertRows(at: indexPaths, with: .fade)
                    self.dataSource.expandParent(atIndexPath: indexPath, parentIndex: parentIndex)
                }
                
                tableView.endUpdates()
            }
        }
        
        delegate.heightForRowAtIndexPath = { [unowned self] (tableView, indexPath) -> CGFloat in
            return !self.dataSource.findParentOfCell(atIndexPath: indexPath).isParent ? 35.0 : 40.0
        }
        
        return delegate
    }
    
}

