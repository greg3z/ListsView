//
//  MultiPageViewController.swift
//  FormViewControllerExample
//
//  Created by Grégoire Lhotellier on 18/04/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import UIKit

class MultiPageViewController: UIViewController, UIPageViewControllerDataSource {
    
    let pageViewControllers: [UIViewController]
    
    init(pageViewControllers: [UIViewController]) {
        self.pageViewControllers = pageViewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    // UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let index = pageViewControllers.indexOf(viewController) where index > 0 {
            return pageViewControllers[index - 1]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let index = pageViewControllers.indexOf(viewController) where index < pageViewControllers.count - 1 {
            return pageViewControllers[index + 1]
        }
        return nil
    }
    
}
