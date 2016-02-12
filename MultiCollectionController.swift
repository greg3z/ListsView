//
//  MultiCollectionController.swift
//  ListView
//
//  Created by Grégoire Lhotellier on 12/02/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import Foundation
import UIKit

class MultiCollectionController<MultiCollection: MultiTitleSectionedCollectionType where MultiCollection.Collection.Generator.Element: ElementListable>: UIPageViewController, UIPageViewControllerDataSource {
    
    var multiCollection: MultiCollection
    var pageControllers = [UIViewController]()
    var elementTouched: ((MultiCollection.Collection.Generator.Element) -> Void)?
    
    init(multiCollection: MultiCollection) {
        self.multiCollection = multiCollection
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        dataSource = self
        initPageControllers()
    }
    
    func initPageControllers() {
        for i in 0..<multiCollection.numberOfPages() {
            let collection = multiCollection.collectionForPage(i)
            let controller = CollectionController(collection: collection)
            controller.elementTouched = {
                element in
                self.elementTouched?(element)
            }
            pageControllers.append(controller)
        }
        setViewControllers([pageControllers.first!], direction: .Forward, animated: false, completion: nil)
    }
    
    // UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let index = pageControllers.indexOf(viewController) where index > 0 {
            return pageControllers[index - 1]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let index = pageControllers.indexOf(viewController) where index < pageControllers.count - 1 {
            return pageControllers[index + 1]
        }
        return nil
    }
    
}
