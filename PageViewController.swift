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
    var refreshCallback: (() -> Void)?
    var elementTouched: ((Element, UITableViewCell) -> Void)?
    var elementAction: ((Element, String) -> Void)?
    var tickStyle = TickStyle.None {
        didSet {
            tableView.allowsMultipleSelection = tickStyle == .Multiple
        }
    }
    var selectedElements: Set<Element>
    var context: CellTypeContext? = nil
    
    init(page: Page<Element>, style: UITableViewStyle = .Plain, selectedElements: Set<Element> = []) {
        self.page = page
        self.selectedElements = selectedElements
        super.init(style: style)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 90
        tableView.tableFooterView = UIView()
        if #available(iOS 9.0, *) {
            tableView.cellLayoutMarginsFollowReadableWidth = false
        }
        if refreshCallback != nil {
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        for selectedElement in selectedElements {
            let indexes = page.indexesOf(selectedElement)
            for index in indexes {
                tableView.selectRowAtIndexPath(index.indexPath, animated: false, scrollPosition: .None)
            }
        }
        selectedElements.removeAll()
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
        let cellType = element.cellType(context)
        let cellId = "\(cellType)"
        tableView.registerClass(cellType, forCellReuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        if tickStyle == .None {
            cell.selectionStyle = .Gray
        }
        else {
            cell.selectionStyle = .None
            if let selectedIndexPaths = tableView.indexPathsForSelectedRows where selectedIndexPaths.contains(indexPath) {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
            }
        }
        element.configureCell(cell, context: context)
        return cell
    }
    
    // UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let element = page[indexPath], cell = tableView.cellForRowAtIndexPath(indexPath) else {
            return
        }
        if tickStyle != .None {
            cell.accessoryType = .Checkmark
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
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else {
            return
        }
        cell.accessoryType = .None
    }
    
}

extension Page {
    
    subscript(indexPath: NSIndexPath) -> Element? {
        let index = PageIndex(sectionsSize: [], currentIndex: (section: indexPath.section, element: indexPath.row))
        return self[safe: index]
    }
    
}

extension PageIndex {
    
    var indexPath: NSIndexPath {
        return NSIndexPath(forRow: currentIndex.element, inSection: currentIndex.section)
    }
    
    init(indexPath: NSIndexPath) {
        self.init(sectionsSize: [], currentIndex: (section: indexPath.section, element: indexPath.row))
    }
    
}

enum TickStyle {
    case None, Single, Multiple
}

extension CollectionType where Generator.Element: Equatable {
    
    func indexesOf(searchedElement: Generator.Element) -> [Index] {
        var indexes = [Index]()
        var index = startIndex
        while index != endIndex {
            let element = self[index]
            if element == searchedElement {
                indexes.append(index)
            }
            index = index.successor()
        }
        return indexes
    }
    
}
