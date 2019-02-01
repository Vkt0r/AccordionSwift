//
//  MainTableViewController.swift
//  Example
//
//  Created by Victor Sigler on 8/8/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
    }
}
