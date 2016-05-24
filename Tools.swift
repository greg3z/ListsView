//
//  Tools.swift
//  ListsView
//
//  Created by Grégoire Lhotellier on 10/02/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import UIKit

struct EditAction {
    
    let title: String
    let style: UITableViewRowActionStyle
    
}

extension Page {
    
    subscript(indexPath: NSIndexPath) -> Element? {
        let index = PageIndex(sectionsSize: [], currentIndex: (section: indexPath.section, element: indexPath.row))
        return self[safe: index]
    }
    
}

extension UIViewController {
    
    func addChildView(viewController: UIViewController, frame: CGRect? = nil) {
        viewController.view.frame = frame ?? view.bounds
        view.addSubview(viewController.view)
        addChildViewController(viewController)
    }
    
}
