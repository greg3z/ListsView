//
//  LCListController.swift
//  Kawet
//
//  Created by Grégoire Lhotellier on 12/01/2016.
//  Copyright © 2016 Kawet. All rights reserved.
//

import UIKit

class PageViewController<Element: ElementListable>: UITableViewController {
    
    var page: Page<Element> {
        didSet {
            refreshControl?.endRefreshing()
            tableView.reloadData()
        }
    }
    var refreshCallback: (Void -> Void)? {
        didSet {
            setRefreshControl()
        }
    }
    var elementTouched: ((Element, UITableViewCell) -> Void)?
    var elementAction: ((Element, String) -> Void)?
    
    init(page: Page<Element>, style: UITableViewStyle = .Plain) {
        self.page = page
        super.init(style: style)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 90
        tableView.tableFooterView = UIView()
        if #available(iOS 9.0, *) {
            tableView.cellLayoutMarginsFollowReadableWidth = false
        }
        setRefreshControl()
    }
    
    func setRefreshControl() {
        if isViewLoaded() && refreshCallback != nil {
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        }
    }
    
    func refresh() {
        refreshCallback?()
    }
    
    // UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return page.sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return page.sections[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return page.sections[section].title
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let element = page[indexPath] else {
            return UITableViewCell()
        }
        let cellType = element.cellType()
        let cellId = "\(cellType)"
        tableView.registerClass(cellType, forCellReuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        element.configureCell(cell, tableView: tableView, indexPath: indexPath)
        return cell
    }
    
    // UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let element = page[indexPath], cell = tableView.cellForRowAtIndexPath(indexPath) else {
            return
        }
        elementTouched?(element, cell)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        guard let element = page[indexPath] else {
            return []
        }
        var rowActions = [UITableViewRowAction]()
        for editAction in element.editActions() {
            let rowAction = UITableViewRowAction(style: editAction.style, title: editAction.title) {
                [weak self] _, indexPath in
                tableView.setEditing(false, animated: true)
                self?.elementAction?(element, editAction.title)
            }
            rowActions.append(rowAction)
        }
        return rowActions
    }
    
}
