//
//  TableViewDelegate.swift
//  AccordionSwift
//
//  Created by Victor Sigler Lopez on 7/5/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import Foundation

typealias DidSelectRowAtIndexPathClosure = (UITableView, IndexPath) -> Void
typealias HeightForRowAtIndexPathClosure = (UITableView, IndexPath) -> CGFloat

@objc final class TableViewDelegate: NSObject {
    
    // MARK: - Properties
    
    var didSelectRowAtIndexPath: DidSelectRowAtIndexPathClosure?
    var heightForRowAtIndexPath: HeightForRowAtIndexPathClosure?
}

extension TableViewDelegate: UITableViewDelegate {
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtIndexPath?(tableView, indexPath)
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAtIndexPath!(tableView, indexPath)
    }
}
