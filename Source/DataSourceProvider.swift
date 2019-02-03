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
    
    // MARK: - Typealias
    
    public typealias DidSelectParentAtIndexPathClosure = (UITableView, IndexPath, DataSource.Item?) -> Void
    public typealias DidSelectChildAtIndexPathClosure = (UITableView, IndexPath, DataSource.Item.ChildItem?) -> Void
    
    // MARK: - Properties
    
    /// The data source.
    public var dataSource: DataSource
    
    /// The parent cell configuration.
    private let parentCellConfig: ParentCellConfig
    
    /// The child cell configuration.
    private let childCellConfig: ChildCellConfig
    
    /// The UITableViewDataSource
    private var _tableViewDataSource: TableViewDataSource?
    
    /// The UITableViewDelegate
    private var _tableViewDelegate: TableViewDelegate?
    
    private let didSelectParentAtIndexPath: DidSelectParentAtIndexPathClosure?
    
    private let didSelectChildAtIndexPath: DidSelectChildAtIndexPathClosure?
    
    // MARK: - Initialization
    
    /// Initializes a new data source provider.
    ///
    /// - Parameters:
    ///   - dataSource: The data source.
    ///   - cellConfig: The cell configuration.
    public init(dataSource: DataSource, 
                parentCellConfig: ParentCellConfig,
                childCellConfig: ChildCellConfig,
                didSelectParentAtIndexPath: DidSelectParentAtIndexPathClosure? = nil,
                didSelectChildAtIndexPath: DidSelectChildAtIndexPathClosure? = nil) {
        self.dataSource = dataSource
        self.parentCellConfig = parentCellConfig
        self.childCellConfig = childCellConfig
        self.didSelectParentAtIndexPath = didSelectParentAtIndexPath
        self.didSelectChildAtIndexPath = didSelectChildAtIndexPath
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
    
    /// Config the UITableViewDataSource methods
    ///
    /// - Returns: An instance of the `TableViewDataSource`
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
    
    private func update(_ tableView: UITableView, _ item: DataSource.Item?, _ currentPosition: Int, _ indexPath: IndexPath, _ parentIndex: Int) {
        
        let numberOfChilds = item!.childs.count
        
        // If the cell doesn't have any child then return
        guard numberOfChilds > 0 else { return }
        
        tableView.beginUpdates()
        
        switch (item!.state) {
        case .expanded:
            
            let indexPaths = (currentPosition + 1...currentPosition + numberOfChilds)
                .map { IndexPath(row: $0, section: indexPath.section)}
            
            tableView.deleteRows(at: indexPaths, with: .fade)
            dataSource.collapseChilds(atIndexPath: indexPath, parentIndex: parentIndex)
            
        case .collapsed:
            
            var insertPos = indexPath.row + 1
            
            let indexPaths = (0..<numberOfChilds)
                .map { _ -> IndexPath in
                    let indexPath = IndexPath(row: insertPos, section: indexPath.section)
                    insertPos += 1
                    return indexPath
            }
            
            tableView.insertRows(at: indexPaths, with: .fade)
            dataSource.expandParent(atIndexPath: indexPath, parentIndex: parentIndex)
        }
        
        tableView.endUpdates()
    }
    
    /// Config the UITableViewDelegate methods
    ///
    /// - Returns: An instance of the `TableViewDelegate`
    private func configTableViewDelegate() -> TableViewDelegate {
        
        let delegate = TableViewDelegate()
        
        delegate.didSelectRowAtIndexPath = { [unowned self] (tableView, indexPath) -> Void in
            let (parentIndex, isParent, currentPosition) = self.dataSource.findParentOfCell(atIndexPath: indexPath)
            let item = self.dataSource.item(atRow: parentIndex, inSection: indexPath.section)
            
            if isParent {
                self.update(tableView, item, currentPosition, indexPath, parentIndex)
                self.didSelectParentAtIndexPath?(tableView, indexPath, item)
            } else {
                let index = indexPath.row - currentPosition - 1
                let childItem = index >= 0 ? item?.childs[index] : nil
                self.didSelectChildAtIndexPath?(tableView, indexPath, childItem)
            }
        }
        
        delegate.heightForRowAtIndexPath = { [unowned self] (tableView, indexPath) -> CGFloat in
            return !self.dataSource.findParentOfCell(atIndexPath: indexPath).isParent ? 35.0 : 40.0
        }
        
        return delegate
    }
}

