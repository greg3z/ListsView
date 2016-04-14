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
    let tickStyle: TickStyle
    var selectedElements: Set<Element> {
        didSet {
            updateVisibleSelectedCells()
        }
    }
    var context: CellTypeContext? = nil
    
    init(page: Page<Element>, style: UITableViewStyle = .Plain, selectedElements: Set<Element> = [], tickStyle: TickStyle = .None) {
        self.page = page
        self.selectedElements = selectedElements
        self.tickStyle = tickStyle
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
    
    func updateVisibleSelectedCells() {
        guard isViewLoaded() else { return }
        for cell in tableView.visibleCells {
            guard let indexPath = tableView.indexPathForCell(cell), element = page[indexPath] else { continue }
            cell.accessoryType = selectedElements.contains(element) ? .Checkmark : .None
        }
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
        let cellType = element.cellType(context)
        let cellId = "\(cellType)"
        tableView.registerClass(cellType, forCellReuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        if tickStyle == .None {
            cell.selectionStyle = .Gray
        }
        else {
            cell.selectionStyle = .None
            cell.accessoryType = selectedElements.contains(element) ? .Checkmark : .None
        }
        element.configureCell(cell, tableView: tableView, indexPath: indexPath, context: context)
        return cell
    }
    
    // UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let element = page[indexPath], cell = tableView.cellForRowAtIndexPath(indexPath) else {
            return
        }
        if tickStyle != .None {
            if selectedElements.contains(element) {
                selectedElements.remove(element)
            }
            else {
                if tickStyle == .Single {
                    selectedElements.removeAll()
                }
                selectedElements.insert(element)
            }
            updateVisibleSelectedCells()
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
