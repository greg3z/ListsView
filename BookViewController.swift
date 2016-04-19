//
//  MultiBookViewController2.swift
//  FormViewController
//
//  Created by Grégoire Lhotellier on 01/04/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import UIKit

class BookViewController<Element>: MultiPageViewController {
    
    var bookPageViewControllers: [PageViewController<Element>] {
        return pageViewControllers as! [PageViewController]
    }
    var refreshCallback: (Void -> Void)? {
        didSet {
            for pageViewController in bookPageViewControllers {
                pageViewController.refreshCallback = refreshCallback
            }
        }
    }
    var elementTouched: ((Element, UITableViewCell) -> Void)?
    var configureCell: ((Element, cell: UITableViewCell, tableView: UITableView, indexPath: NSIndexPath) -> Void)? {
        didSet {
            for pageViewController in bookPageViewControllers {
                pageViewController.configureCell = configureCell
            }
        }
    }
    
    init(book: Book<Element>, cellTypeForElement: Element -> UITableViewCell.Type) {
        var pageViewControllers = [PageViewController<Element>]()
        for page in book.pages {
            let pageViewController = PageViewController(page: page, cellTypeForElement: cellTypeForElement)
            pageViewControllers.append(pageViewController)
        }
        super.init(pageViewControllers: pageViewControllers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for pageViewController in bookPageViewControllers {
            pageViewController.elementTouched = {
                [weak self] element, cell in
                self?.elementTouched?(element, cell)
            }
        }
    }
    
    func reloadVisibleCells() {
        for pageViewController in bookPageViewControllers {
            pageViewController.reloadVisibleCells()
        }
    }
    
    func reloadData() {
        for pageViewController in bookPageViewControllers {
            pageViewController.tableView.reloadData()
        }
    }
    
    func endRefreshing() {
        for pageViewController in bookPageViewControllers {
            pageViewController.refreshControl?.endRefreshing()
        }
    }
    
}
