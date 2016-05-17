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
    let tickStyle: TickStyle
    
    init(book: Book<Element>, selectedElements: Set<Element> = [], tickStyle: TickStyle = .Single, cellType: (Element -> UITableViewCell.Type)? = nil) {
        self.selectedElements = selectedElements
        self.tickStyle = tickStyle
        super.init(data: book, cellType: cellType)
        configureCell = {
            [weak self] element, cell, tableView, indexPath in
            let selectedElement = self?.selectedElements.contains(element) ?? false
            self?.configureSelectableCell?(element, cell: cell, tableView: tableView, indexPath: indexPath, selected: selectedElement)
        }
        elementTouched = {
            element, cell in
            self.elementSelected(element)
        }
    }
    
    func elementSelected(element: Element) {
        if selectedElements.contains(element) {
            selectedElements.remove(element)
        }
        else {
            if tickStyle == .Single {
                selectedElements.removeAll()
            }
            selectedElements.insert(element)
        }
        reloadVisibleCells()
    }
    
}

enum TickStyle {
    case Single, Multiple
}
