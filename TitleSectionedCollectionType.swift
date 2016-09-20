//
//  TitleSectionedCollectionType.swift
//  ListView
//
//  Created by Grégoire Lhotellier on 10/02/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import Foundation

protocol TitleSectionedCollectionType: Collection {
    
    func numberOfSections() -> Int
    func numberOfElementsInSections(_ section: Int) -> Int
    func titleForSection(_ section: Int) -> String?
    func elementAtSectionIndex(_ sectionIndex: Int, elementIndex: Int) -> Iterator.Element?
    
}

extension TitleSectionedCollectionType {
    
    func elementAtIndexPath(_ indexPath: IndexPath) -> Iterator.Element? {
        return elementAtSectionIndex((indexPath as NSIndexPath).section, elementIndex: (indexPath as NSIndexPath).row)
    }
    
}

extension Array: TitleSectionedCollectionType {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfElementsInSections(_ section: Int) -> Int {
        return count
    }
    
    func titleForSection(_ section: Int) -> String? {
        return nil
    }
    
    func elementAtSectionIndex(_ sectionIndex: Int, elementIndex: Int) -> Iterator.Element? {
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
    
    func numberOfElementsInSections(_ section: Int) -> Int {
        return sections[section].count
    }
    
    func titleForSection(_ section: Int) -> String? {
        return sections[section].title
    }
    
    func elementAtSectionIndex(_ sectionIndex: Int, elementIndex: Int) -> Element? {
        let pageIndex = PageIndex(sectionsSize: [], currentIndex: (sectionIndex, elementIndex))
        return self[safe: pageIndex]
    }
    
}

protocol MultiTitleSectionedCollectionType {
    
    associatedtype Collection: TitleSectionedCollectionType
    
    func numberOfPages() -> Int
    func collectionForPage(_ pageIndex: Int) -> Collection
    
}

extension Book: MultiTitleSectionedCollectionType {
    
    func numberOfPages() -> Int {
        return pages.count
    }
    
    func collectionForPage(_ pageIndex: Int) -> Page<Element> {
        return pages[pageIndex]
    }
    
}
