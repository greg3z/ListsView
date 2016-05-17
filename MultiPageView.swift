//
//  MultiPageView.swift
//  FormViewControllerExample
//
//  Created by Grégoire Lhotellier on 18/04/2016.
//  Copyright © 2016 Grégoire Lhotellier. All rights reserved.
//

import UIKit

class MultiPageView: UIViewController, UIPageViewControllerDataSource {
    
    let views: [UIViewController]
    
    init(views: [UIViewController]) {
        self.views = views
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controller: UIViewController
        if views.count == 1 {
            controller = views.first!
        }
        else {
            let pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
            pageController.dataSource = self
            pageController.setViewControllers([views.first!], direction: .Forward, animated: false, completion: nil)
            controller = pageController
        }
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        addChildViewController(controller)
    }
    
    // UIPageViewDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let index = views.indexOf(viewController) where index > 0 {
            return views[index - 1]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let index = views.indexOf(viewController) where index < views.count - 1 {
            return views[index + 1]
        }
        return nil
    }
    
}
