//
//  MultiCollectionController2.swift
//  FormViewController
//
//  Created by Grégoire Lhotellier on 01/04/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import UIKit

class CollectionController<Collection: MultiTitleSectionedCollectionType where Collection.Collection.Generator.Element: ElementListable>: UIViewController, UIPageViewControllerDataSource {
    
    let collectionControllers: [SinglePageCollectionController<Collection.Collection>]
    
    init(collection: Collection) {
        var collectionControllers = [SinglePageCollectionController<Collection.Collection>]()
        for i in 0..<collection.numberOfPages() {
            let subCollection = collection.collectionForPage(i)
            let singlePageController = SinglePageCollectionController(collection: subCollection)
            collectionControllers.append(singlePageController)
        }
        self.collectionControllers = collectionControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controller: UIViewController
        if collectionControllers.count == 1 {
            controller = collectionControllers.first!
        }
        else {
            let pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
            pageController.dataSource = self
            pageController.setViewControllers([collectionControllers.first!], direction: .Forward, animated: false, completion: nil)
            controller = pageController
        }
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        addChildViewController(controller)
    }
    
    func setElementTouched(elementTouched: (Collection.Collection.Generator.Element, UITableViewCell) -> Void) {
        for collectionController in collectionControllers {
            collectionController.elementTouched = elementTouched
        }
    }
    
    func setTickStyle(tickStyle: TickStyle) {
        for collectionController in collectionControllers {
            collectionController.tickStyle = tickStyle
        }
    }
    
    // UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? SinglePageCollectionController<Collection.Collection>, index = collectionControllers.indexOf(viewController) where index > 0 {
            return collectionControllers[index - 1]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? SinglePageCollectionController<Collection.Collection>, index = collectionControllers.indexOf(viewController) where index < collectionControllers.count - 1 {
            return collectionControllers[index + 1]
        }
        return nil
    }
    
}
