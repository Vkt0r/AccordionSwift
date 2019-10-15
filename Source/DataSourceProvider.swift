//
//  DataSourceProvider.swift
//  AccordionSwift
//
//  Created by Victor Sigler Lopez on 7/3/18.
//  Updated by Kyle Wood on 15/10/19.
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

    public typealias HeightForChildAtIndexPathClosure = (UITableView, IndexPath, DataSource.Item.ChildItem?) -> CGFloat
    public typealias HeightForParentAtIndexPathClosure = (UITableView, IndexPath, DataSource.Item?) -> CGFloat

    private typealias ParentCell = (tableView: UITableView, currentPosition: Int, indexPath: IndexPath, index: Int)

    // MARK: - Properties

    /// The data source.
    public var dataSource: DataSource

    // The currently expanded parent
    private var expandedParent: ParentCell? = nil

    // Defines if accordion can have more than one cell open at a time
    private var numberExpandedParentCells: NumberCellsExpanded

    /// The parent cell configuration.
    private let parentCellConfig: ParentCellConfig

    /// The child cell configuration.
    private let childCellConfig: ChildCellConfig

    /// The UITableViewDataSource
    private var _tableViewDataSource: TableViewDataSource?

    /// The UITableViewDelegate
    private var _tableViewDelegate: TableViewDelegate?

    /// The closure to be called when a Parent cell is selected
    private let didSelectParentAtIndexPath: DidSelectParentAtIndexPathClosure?

    /// The closure to be called when a Child cell is selected
    private let didSelectChildAtIndexPath: DidSelectChildAtIndexPathClosure?

    /// The closure to define the height of the Parent cell at the specified IndexPath
    private let heightForParentCellAtIndexPath: HeightForParentAtIndexPathClosure?

    /// The closure to define the height of the Child cell at the specified IndexPath
    private let heightForChildCellAtIndexPath: HeightForChildAtIndexPathClosure?

    /// The closure to be called when scrollView is scrolled
    private let scrollViewDidScroll: ScrollViewDidScrollClosure?

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
                didSelectChildAtIndexPath: DidSelectChildAtIndexPathClosure? = nil,
                heightForParentCellAtIndexPath: HeightForParentAtIndexPathClosure? = nil,
                heightForChildCellAtIndexPath: HeightForChildAtIndexPathClosure? = nil,
                scrollViewDidScroll: ScrollViewDidScrollClosure? = nil,
                numberExpandedParentCells: NumberCellsExpanded = .multiple
    ) {
        self.dataSource = dataSource
        self.parentCellConfig = parentCellConfig
        self.childCellConfig = childCellConfig
        self.didSelectParentAtIndexPath = didSelectParentAtIndexPath
        self.didSelectChildAtIndexPath = didSelectChildAtIndexPath
        self.heightForParentCellAtIndexPath = heightForParentCellAtIndexPath
        self.heightForChildCellAtIndexPath = heightForChildCellAtIndexPath
        self.scrollViewDidScroll = scrollViewDidScroll
        self.expandedParent = nil
        self.numberExpandedParentCells = numberExpandedParentCells
    }

    // MARK: - Private Methods

    // Update the cells of the table based on the selected parent cell
    //
    // - Parameters:
    //   - tableView: The UITableView to update
    //   - item: The DataSource item that was selected
    //   - currentPosition: The current position in the data source
    //   - indexPaths: The last IndexPath of the new cells expanded
    //   - parentIndex: The index of the parent item selected
    private func update(_ tableView: UITableView, _ item: DataSource.Item?, _ currentPosition: Int, _ indexPath: IndexPath, _ parentIndex: Int) {
        guard let item = item else {
            return
        }

        let numberOfChildren = item.children.count
        guard numberOfChildren > 0 else {
            return
        }

        let selectedParentCell: ParentCell = ParentCell(
                tableView: tableView,
                currentPosition: currentPosition,
                indexPath: indexPath,
                index: parentIndex)

        tableView.beginUpdates()
        toggleCellState(currentState: item.state, selectedParentCell: selectedParentCell)
        tableView.endUpdates()

        // If the cells were expanded then we verify if they are inside the CGRect
        if item.state == .expanded {
            let lastCellIndexPath = IndexPath(item: indexPath.item + numberOfChildren, section: indexPath.section)
            // Scroll the new cells expanded in case of be outside the UITableView CGRect
            scrollCellIfNeeded(atIndexPath: lastCellIndexPath, tableView)
        }
    }

    // Toggle the state of the selected parent cell between expanded and collapsed
    //
    // - Parameters:
    //   - currentState: The current state of the selected parent
    //   - selectedParentCell: The actual cell selected
    private func toggleCellState(currentState: State, selectedParentCell: ParentCell) {
        switch (currentState) {
        case .expanded:
            // Collapse the parent and it's children
            collapse(parent: selectedParentCell)
            expandedParent = nil
        case .collapsed:
            // Expand the parent and it's children
            switch numberExpandedParentCells {
            case .single:
                if let expandedParent = expandedParent {
                    collapse(parent: expandedParent)
                }
                expand(parent: selectedParentCell)
                expandedParent = selectedParentCell
            case .multiple:
                expand(parent: selectedParentCell)
            }
        }
    }

    // Expand the parent cell and it's children
    //
    // - Parameters:
    //   - parent: The actual parent cell to be expanded
    private func expand(parent: ParentCell) {
        let numberOfChildren = dataSource.item(atRow: parent.index, inSection: parent.indexPath.section)?.children.count ?? 0

        guard numberOfChildren > 0 else {
            return
        }

        var insertPos = 1 + {
            switch numberExpandedParentCells {
            case .single:
                // Make use of parent index due to fact indexPath.row does not update the row position after
                // collapsing the previously expanded parent
                return parent.index
            case .multiple:
                // Make use of indexPath if multiple parents can be expanded as indexPath.row will be up to date
                return parent.indexPath.row
            }
        }()

        let indexPaths = (0..<numberOfChildren)
                .map { _ -> IndexPath in
            let indexPath = IndexPath(row: insertPos, section: parent.indexPath.section)
            insertPos += 1
            return indexPath
        }

        parent.tableView.insertRows(at: indexPaths, with: .fade)
        dataSource.expandParent(atIndexPath: parent.indexPath, parentIndex: parent.index)
    }

    // Collapse the parent cell and it's children
    //
    // - Parameters:
    //   - parent: The actual parent cell to be expanded
    private func collapse(parent: ParentCell) {
        let numberOfChildren = dataSource.item(atRow: parent.index, inSection: parent.indexPath.section)?.children.count ?? 0

        guard numberOfChildren > 0 else {
            return
        }

        let startPosition: Int = {
            switch numberExpandedParentCells {
            case .single:
                // Make use of parent index as current position in data source might not be in the correct position
                return parent.index
            case .multiple:
                return parent.currentPosition
            }
        }()

        let indexPaths = (startPosition + 1...startPosition + numberOfChildren)
                .map {
            IndexPath(row: $0, section: parent.indexPath.section)
        }

        parent.tableView.deleteRows(at: indexPaths, with: .fade)
        dataSource.collapseChildren(atIndexPath: parent.indexPath, parentIndex: parent.index)
    }

    /// Scroll the new cells expanded in case of be outside the UITableView CGRect
    ///
    /// - Parameters:
    ///   - indexPaths: The last IndexPath of the new cells expanded
    ///   - tableView: The UITableView to update
    private func scrollCellIfNeeded(atIndexPath indexPath: IndexPath, _ tableView: UITableView) {

        let cellRect = tableView.rectForRow(at: indexPath)

        // Scroll to the cell in case of not being visible
        if !tableView.bounds.contains(cellRect) {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
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
                numberOfItemsInSection: { [unowned self] (section) -> Int in
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
                let childItem = index >= 0 ? item?.children[index] : nil
                self.didSelectChildAtIndexPath?(tableView, indexPath, childItem)
            }
        }

        delegate.heightForRowAtIndexPath = { [unowned self] (tableView, indexPath) -> CGFloat in
            let (parentIndex, isParent, currentPosition) = self.dataSource.findParentOfCell(atIndexPath: indexPath)
            let item = self.dataSource.item(atRow: parentIndex, inSection: indexPath.section)

            if isParent {
                return self.heightForParentCellAtIndexPath?(tableView, indexPath, item) ?? 40
            }

            let index = indexPath.row - currentPosition - 1
            let childItem = index >= 0 ? item?.children[index] : nil
            return self.heightForChildCellAtIndexPath?(tableView, indexPath, childItem) ?? 35
        }

        delegate.scrollViewDidScrollClosure = { [unowned self] (scrollView) -> Void in
            self.scrollViewDidScroll?(scrollView)
        }

        return delegate
    }
}

