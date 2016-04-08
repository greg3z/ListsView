//
//  MultiBookViewController2.swift
//  FormViewController
//
//  Created by Grégoire Lhotellier on 01/04/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import UIKit

class BookViewController<Element: ElementListable>: UIViewController, UIPageViewControllerDataSource {
    
    let pageViewControllers: [PageViewController<Element>]
    
    init(book: Book<Element>, selectedElements: [Element] = []) {
        var pageViewControllers = [PageViewController<Element>]()
        for i in 0..<book.pages.count {
            let page = book.pages[i]
            let pageViewController = PageViewController(page: page, selectedElements: selectedElements)
            pageViewControllers.append(pageViewController)
        }
        self.pageViewControllers = pageViewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controller: UIViewController
        if pageViewControllers.count == 1 {
            controller = pageViewControllers.first!
        }
        else {
            let pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
            pageController.dataSource = self
            pageController.setViewControllers([pageViewControllers.first!], direction: .Forward, animated: false, completion: nil)
            controller = pageController
        }
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        addChildViewController(controller)
    }
    
    func setElementTouched(elementTouched: (Element, UITableViewCell) -> Void) {
        for pageViewController in pageViewControllers {
            pageViewController.elementTouched = elementTouched
        }
    }
    
    func setTickStyle(tickStyle: TickStyle) {
        for pageViewController in pageViewControllers {
            pageViewController.tickStyle = tickStyle
        }
    }
    
    // UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? PageViewController<Element>, index = pageViewControllers.indexOf(viewController) where index > 0 {
            return pageViewControllers[index - 1]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? PageViewController<Element>, index = pageViewControllers.indexOf(viewController) where index < pageViewControllers.count - 1 {
            return pageViewControllers[index + 1]
        }
        return nil
    }
    
}
