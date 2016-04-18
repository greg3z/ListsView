//
//  MultiBookViewController2.swift
//  FormViewController
//
//  Created by Grégoire Lhotellier on 01/04/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import UIKit

class BookViewController<Element: ElementListable>: MultiPageViewController {
    
    var bookPageViewControllers: [PageViewController<Element>] {
        return pageViewControllers as! [PageViewController]
    }
    var context: CellTypeContext? = nil {
        didSet {
            for pageViewController in bookPageViewControllers {
                pageViewController.context = context
            }
        }
    }
    var refreshCallback: (Void -> Void)? {
        didSet {
            for pageViewController in bookPageViewControllers {
                pageViewController.refreshCallback = refreshCallback
            }
        }
    }
    var elementTouched: ((Element, UITableViewCell) -> Void)?
    var selectedElements: Set<Element>
    
    init(book: Book<Element>, selectedElements: Set<Element> = [], tickStyle: TickStyle = .None) {
        self.selectedElements = selectedElements
        var pageViewControllers = [PageViewController<Element>]()
        for i in 0..<book.pages.count {
            let page = book.pages[i]
            let pageViewController = PageViewController(page: page, selectedElements: selectedElements, tickStyle: tickStyle)
            pageViewControllers.append(pageViewController)
        }
        super.init(pageViewControllers: pageViewControllers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for pageViewController in bookPageViewControllers {
            pageViewController.elementTouched = {
                [weak self] element, cell in
                self?.selectedElements = pageViewController.selectedElements
                for otherPageViewController in self?.bookPageViewControllers ?? [] where otherPageViewController != pageViewController {
                    otherPageViewController.selectedElements = self!.selectedElements
                }
                self?.elementTouched?(element, cell)
            }
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
