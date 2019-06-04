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
public typealias ScrollViewDidScrollClosure = (UIScrollView) -> Void

@objc final class TableViewDelegate: NSObject {
    
    // MARK: - Properties
    
    var didSelectRowAtIndexPath: DidSelectRowAtIndexPathClosure?
    var heightForRowAtIndexPath: HeightForRowAtIndexPathClosure?
    
    var scrollViewDidScrollClosure: ScrollViewDidScrollClosure?
}

extension TableViewDelegate: UITableViewDelegate {
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtIndexPath?(tableView, indexPath)
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAtIndexPath!(tableView, indexPath)
    }
}

extension TableViewDelegate: UIScrollViewDelegate {
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollClosure?(scrollView)
    }
}
