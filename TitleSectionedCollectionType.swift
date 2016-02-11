//
//  TitleSectionedCollectionType.swift
//  ListView
//
//  Created by Grégoire Lhotellier on 10/02/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import Foundation

protocol TitleSectionedCollectionType: CollectionType {
    
    typealias Element
    
    func numberOfSections() -> Int
    func numberOfElementsInSections(section: Int) -> Int
    func titleForSection(section: Int) -> String?
    func elementAtIndexPath(indexPath: NSIndexPath) -> Element?
    
}

extension Array: TitleSectionedCollectionType {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfElementsInSections(section: Int) -> Int {
        return count
    }
    
    func titleForSection(section: Int) -> String? {
        return nil
    }
    
    func elementAtIndexPath(indexPath: NSIndexPath) -> Element? {
        if indexPath.section == 0 && indexPath.row < count {
            return self[indexPath.row]
        }
        return nil
    }
    
}

extension Page: TitleSectionedCollectionType {
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfElementsInSections(section: Int) -> Int {
        return sections[section].count
    }
    
    func titleForSection(section: Int) -> String? {
        return sections[section].title
    }
    
    func elementAtIndexPath(indexPath: NSIndexPath) -> Element? {
        if indexPath.section < sections.count && indexPath.row < sections[indexPath.section].count {
            return self[indexPath.section][indexPath.row]
        }
        return nil
    }
    
}
