//
//  AccordionTableViewController.swift
//  Example
//
//  Created by Victor Sigler Lopez on 7/5/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import UIKit
import AccordionSwift

class AccordionTableViewController: UITableViewController {
    
    typealias ParentCellConfig = CellViewConfig<Parent<ParentCellModel, ChildCellModel>>
    typealias ChildCellConfig = CellViewConfig<ChildCellModel>
    
    var dataSourceProvider: DataSourceProvider<DataSource<Parent<ParentCellModel, ChildCellModel>>, ParentCellConfig, ChildCellConfig>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cell1 = Parent(state: .collapsed, item: ParentCellModel(title: "Parent Cell 1"), 
                           childs: [ChildCellModel(title: "Child Cell 1"), 
                                    ChildCellModel(title: "Child Cell 2")])
        
        let cell2 = Parent(state: .collapsed, item: ParentCellModel(title: "Parent Cell 2"), 
                           childs: [ChildCellModel(title: "Child Cell 1"), 
                                    ChildCellModel(title: "Child Cell 1")])
        
        let section0 = Section([cell1, cell2], headerTitle: "Section 0")
        let section1 = Section([cell1, cell2], headerTitle: "Section 1")
        let dataSource = DataSource(sections: section0, section1)
        
        let parentCellConfig = CellViewConfig<Parent<ParentCellModel, ChildCellModel>>(reuseIdentifier: "ParentCell") { (cell, model, tableView, indexPath) -> UITableViewCell in
            cell.textLabel?.text = model?.item.title
            return cell
        }
        
        let childCellConfig = CellViewConfig<ChildCellModel>(reuseIdentifier: "ChildCell") { (cell, item, tableView, indexPath) -> UITableViewCell in
            cell.textLabel?.text = item?.title
            return cell
        }
        
        dataSourceProvider = DataSourceProvider(dataSource: dataSource, 
                                                parentCellConfig: parentCellConfig, 
                                                childCellConfig: childCellConfig)
        
        tableView.dataSource = dataSourceProvider?.tableViewDataSource
        tableView.delegate = dataSourceProvider?.tableViewDelegate
        tableView.tableFooterView = UIView()
    }
}
