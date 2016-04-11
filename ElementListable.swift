//
//  ElementListable.swift
//  ListView
//
//  Created by Grégoire Lhotellier on 10/02/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import Foundation
import UIKit

protocol ElementListable: Hashable {
    
    func cellType(context: CellTypeContext?) -> UITableViewCell.Type
    func configureCell(cell: UITableViewCell, context: CellTypeContext?)
    func editActions() -> [EditAction]
    
}

extension ElementListable {
    
    func cellType(context: CellTypeContext?) -> UITableViewCell.Type {
        return UITableViewCell.self
    }
    
    func editActions() -> [EditAction] {
        return []
    }
    
}

protocol CellTypeContext {
    
}

struct EditAction {
    
    let title: String
    let style: UITableViewRowActionStyle
    
}
