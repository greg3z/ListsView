//
//  ElementListable.swift
//  ListView
//
//  Created by Grégoire Lhotellier on 10/02/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import Foundation
import UIKit

protocol ElementListable {
    
    func cellType() -> UITableViewCell.Type
    func configureCell(_ cell: UITableViewCell)
    func editActions() -> [EditAction]
    
}

extension ElementListable {
    
    func cellType() -> UITableViewCell.Type {
        return UITableViewCell.self
    }
    
    func editActions() -> [EditAction] {
        return []
    }
    
}

struct EditAction {
    
    let title: String
    let style: UITableViewRowActionStyle
    
}
