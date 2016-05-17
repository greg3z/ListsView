//
//  MultiBookViewController2.swift
//  FormViewController
//
//  Created by Grégoire Lhotellier on 01/04/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import UIKit

class BookViewController<Element>: UIViewController {
    
    let book: Book<Element>
    let cellType: (Element -> UITableViewCell.Type)?
    var pageViewControllers = [PageViewController<Element>]()
    var refreshCallback: (Void -> Void)? {
        didSet {
            for pageViewController in pageViewControllers {
                pageViewController.refreshCallback = refreshCallback
            }
        }
    }
    var elementTouched: ((Element, UITableViewCell) -> Void)?
    var configureCell: ((Element, cell: UITableViewCell, tableView: UITableView, indexPath: NSIndexPath) -> Void)? {
        didSet {
            for pageViewController in pageViewControllers {
                pageViewController.configureCell = configureCell
            }
        }
    }
    
    init(data: Book<Element>, cellType: (Element -> UITableViewCell.Type)? = nil) {
        self.book = data
        self.cellType = cellType
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(data: Page<Element>, cellType: (Element -> UITableViewCell.Type)? = nil) {
        let book = Book(pages: [data])
        self.init(data: book, cellType: cellType)
    }
    
    convenience init(data: [Element], cellType: (Element -> UITableViewCell.Type)? = nil) {
        let book = Book(data)
        self.init(data: book, cellType: cellType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for page in book.pages {
            let pageViewController = PageViewController(page: page, cellType: cellType)
            pageViewController.elementTouched = elementTouched
            pageViewController.configureCell = configureCell
            pageViewControllers.append(pageViewController)
        }
        let multiPageViewController = MultiPageViewController(pageViewControllers: pageViewControllers)
        multiPageViewController.view.frame = view.bounds
        view.addSubview(multiPageViewController.view)
        addChildViewController(multiPageViewController)
    }
    
    func reloadVisibleCells() {
        for pageViewController in pageViewControllers {
            pageViewController.reloadVisibleCells()
        }
    }
    
    func reloadData() {
        for pageViewController in pageViewControllers {
            pageViewController.tableView.reloadData()
        }
    }
    
    func endRefreshing() {
        for pageViewController in pageViewControllers {
            pageViewController.refreshControl?.endRefreshing()
        }
    }
    
}
