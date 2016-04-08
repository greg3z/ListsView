//
//  LCListController.swift
//  Kawet
//
//  Created by Grégoire Lhotellier on 12/01/2016.
//  Copyright © 2016 Kawet. All rights reserved.
//

import UIKit

class SinglePageCollectionController<Collection: TitleSectionedCollectionType where Collection.Generator.Element: ElementListable>: UITableViewController {
    
    var collection: Collection {
        didSet {
            refreshControl?.endRefreshing()
            tableView.reloadData()
        }
    }
    var refreshCallback: (() -> Void)?
    var elementTouched: ((Collection.Generator.Element, UITableViewCell) -> Void)?
    var elementAction: ((Collection.Generator.Element, String) -> Void)?
    var tickStyle = TickStyle.None {
        didSet {
            tableView.allowsMultipleSelection = tickStyle == .Multiple
        }
    }
    let selectedIndexes: [NSIndexPath]
    
    init(collection: Collection, style: UITableViewStyle = .Plain, selectedIndexes: [NSIndexPath] = []) {
        self.collection = collection
        self.selectedIndexes = selectedIndexes
        super.init(style: style)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 90
        tableView.tableFooterView = UIView()
        for indexPath in selectedIndexes {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        }
        if #available(iOS 9.0, *) {
            tableView.cellLayoutMarginsFollowReadableWidth = false
        }
        if refreshCallback != nil {
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        }
    }
    
    func refresh() {
        refreshCallback?()
    }
    
    // UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return collection.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection.numberOfElementsInSections(section)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return collection.titleForSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let element = collection.elementAtIndexPath(indexPath) else {
            return UITableViewCell()
        }
        let cellType = element.cellType()
        let cellId = "\(cellType)"
        tableView.registerClass(cellType, forCellReuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        element.configureCell(cell)
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
        return cell
    }
    
    // UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let element = collection.elementAtIndexPath(indexPath), cell = tableView.cellForRowAtIndexPath(indexPath) else {
            return
        }
        if tickStyle != .None {
            cell.accessoryType = .Checkmark
        }
        elementTouched?(element, cell)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        guard let element = collection.elementAtIndexPath(indexPath) else {
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

enum TickStyle {
    case None, Single, Multiple
}
