//
//  TableViewDataSource.swift
//  AccordionSwift
//
//  Created by Victor Sigler Lopez on 7/5/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import Foundation

typealias NumberOfSectionsClosure = () -> Int
typealias NumberOfItemsInSectionClosure = (Int) -> Int

typealias TableCellForRowAtIndexPathClosure = (UITableView, IndexPath) -> UITableViewCell
typealias TableTitleForHeaderInSectionClosure = (Int) -> String?
typealias TableTitleForFooterInSectionClosure = (Int) -> String?

/// Defines the methods in the UITableViewDataSource
@objc final class TableViewDataSource: NSObject {
    
    // MARK: - Properties
    
    let numberOfSections: NumberOfSectionsClosure
    let numberOfItemsInSection: NumberOfItemsInSectionClosure
    
    var tableCellForRowAtIndexPath: TableCellForRowAtIndexPathClosure?
    var tableTitleForHeaderInSection: TableTitleForHeaderInSectionClosure?
    var tableTitleForFooterInSection: TableTitleForFooterInSectionClosure?
    
    // MARK: - Initializer
    
    /// Construct a new TableViewDataSource
    ///
    /// - Parameters:
    ///   - numberOfSections: The number of sections closure in data source
    ///   - numberOfItemsInSection: The number of items in the section closure in data source
    init(numberOfSections: @escaping NumberOfSectionsClosure,
         numberOfItemsInSection: @escaping NumberOfItemsInSectionClosure) {
        self.numberOfSections = numberOfSections
        self.numberOfItemsInSection = numberOfItemsInSection
    }
}

extension TableViewDataSource: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemsInSection(section)
    }
    
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCellForRowAtIndexPath!(tableView, indexPath)
    }
    
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    @objc func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let closure = tableTitleForHeaderInSection else { return nil }
        return closure(section)
    }
    
    @objc func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let closure = tableTitleForFooterInSection else { return nil }
        return closure(section)
    }
}
