//
//  TitleSectionedCollectionType.swift
//  ListView
//
//  Created by Grégoire Lhotellier on 10/02/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import Foundation

protocol TitleSectionedCollectionType: CollectionType {
    
    func numberOfSections() -> Int
    func numberOfElementsInSections(section: Int) -> Int
    func titleForSection(section: Int) -> String?
    func elementAtSectionIndex(sectionIndex: Int, elementIndex: Int) -> Generator.Element?
    
}

extension TitleSectionedCollectionType {
    
    func elementAtIndexPath(indexPath: NSIndexPath) -> Generator.Element? {
        return elementAtSectionIndex(indexPath.section, elementIndex: indexPath.row)
    }
    
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
    
    func elementAtSectionIndex(sectionIndex: Int, elementIndex: Int) -> Generator.Element? {
        if sectionIndex == 0 && elementIndex < count {
            return self[elementIndex]
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
    
    func elementAtSectionIndex(sectionIndex: Int, elementIndex: Int) -> Element? {
        let pageIndex = PageIndex(sectionsSize: [], currentIndex: (sectionIndex, elementIndex))
        return self[safe: pageIndex]
    }
    
}

protocol MultiTitleSectionedCollectionType {
    
    typealias Collection: TitleSectionedCollectionType
    
    func numberOfPages() -> Int
    func collectionForPage(pageIndex: Int) -> Collection
    
}

extension Book: MultiTitleSectionedCollectionType {
    
    func numberOfPages() -> Int {
        return pages.count
    }
    
    func collectionForPage(pageIndex: Int) -> Page<Element> {
        return pages[pageIndex]
    }
    
}
