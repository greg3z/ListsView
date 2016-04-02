//
//  MultiCollectionController2.swift
//  FormViewController
//
//  Created by Grégoire Lhotellier on 01/04/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import UIKit

class CollectionController<Collection: MultiTitleSectionedCollectionType where Collection.Collection.Generator.Element: ElementListable>: UIViewController, UIPageViewControllerDataSource {
    
    let collection: Collection
    let collectionControllers: [SinglePageCollectionController<Collection.Collection>]
    
    init(collection: Collection) {
        var collectionControllers = [SinglePageCollectionController<Collection.Collection>]()
        for i in 0..<collection.numberOfPages() {
            let subCollection = collection.collectionForPage(i)
            collectionControllers.append(SinglePageCollectionController(collection: subCollection))
        }
        self.collectionControllers = collectionControllers
        self.collection = collection
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
