//
//  ListsView.swift
//  ListsView
//
//  Created by Grégoire Lhotellier on 01/04/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import UIKit

class ListsView<Element>: UIViewController {
    
    let book: Book<Element>
    let cellType: (Element -> UITableViewCell.Type)?
    var pageViews = [PageView<Element>]()
    var refreshCallback: (Void -> Void)? {
        didSet {
            for pageView in pageViews {
                pageView.refreshCallback = refreshCallback
            }
        }
    }
    var elementTouched: ((Element, UITableViewCell) -> Void)?
    var configureCell: ((Element, cell: UITableViewCell, tableView: UITableView, indexPath: NSIndexPath) -> Void)? {
        didSet {
            for pageView in pageViews {
                pageView.configureCell = configureCell
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
            let pageView = PageView(page: page, cellType: cellType)
            pageView.elementTouched = elementTouched
            pageView.configureCell = configureCell
            pageViews.append(pageView)
        }
        let multiPageView = MultiPageView(views: pageViews)
        multiPageView.view.frame = view.bounds
        view.addSubview(multiPageView.view)
        addChildViewController(multiPageView)
    }
    
    func reloadVisibleCells() {
        for pageView in pageViews {
            pageView.reloadVisibleCells()
        }
    }
    
    func reloadData() {
        for pageView in pageViews {
            pageView.tableView.reloadData()
        }
    }
    
    func endRefreshing() {
        for pageView in pageViews {
            pageView.refreshControl?.endRefreshing()
        }
    }
    
}
