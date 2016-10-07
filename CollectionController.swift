//
//  LCListController.swift
//  Kawet
//
//  Created by Grégoire Lhotellier on 12/01/2016.
//  Copyright © 2016 Kawet. All rights reserved.
//

import UIKit

class CollectionController<Collection: TitleSectionedCollectionType>: UITableViewController where Collection.Iterator.Element: ElementListable {
    
    var collection: Collection {
        didSet {
            refreshControl?.endRefreshing()
            tableView.reloadData()
        }
    }
    var refreshCallback: (() -> Void)?
    var elementTouched: ((Collection.Iterator.Element) -> Void)?
    var elementAction: ((Collection.Iterator.Element, String) -> Void)?

    init(collection: Collection, style: UITableViewStyle = .plain) {
        self.collection = collection
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            refreshControl?.addTarget(self, action: #selector(CollectionController.refresh), for: .valueChanged)
        }
    }
    
    func refresh() {
        refreshCallback?()
    }
    
    // UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return collection.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection.numberOfElementsInSections(section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return collection.titleForSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let element = collection.elementAtIndexPath(indexPath) else {
            return UITableViewCell()
        }
        let cellType = element.cellType()
        let cellId = "\(cellType)"
        tableView.register(cellType, forCellReuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        element.configureCell(cell)
        return cell
    }
    
    // UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let element = collection.elementAtIndexPath(indexPath) else {
            return
        }
        elementTouched?(element)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
    
}
