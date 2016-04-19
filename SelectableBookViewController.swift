//
//  SelectableBookViewController.swift
//  CollectionControllerExample
//
//  Created by Grégoire Lhotellier on 19/04/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import UIKit

class SelectableBookViewController<Element: Hashable>: BookViewController<Element> {
    
    var selectedElements: Set<Element>
    var configureSelectableCell: ((Element, cell: UITableViewCell, tableView: UITableView, indexPath: NSIndexPath, selected: Bool) -> Void)?
    
    init(book: Book<Element>, selectedElements: Set<Element> = [], cellTypeForElement: Element -> UITableViewCell.Type) {
        self.selectedElements = selectedElements
        super.init(book: book, cellTypeForElement: cellTypeForElement)
        configureCell = {
            [weak self] element, cell, tableView, indexPath in
            let selectedElement = self?.selectedElements.contains(element) ?? false
            self?.configureSelectableCell?(element, cell: cell, tableView: tableView, indexPath: indexPath, selected: selectedElement)
        }
    }
    
}
