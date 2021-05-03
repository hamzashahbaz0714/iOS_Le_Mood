//
//  Storyboard.swift
//  iOSApplication
//
//  Created by Usman Javaid on 14/11/2019.
//  Copyright © 2019 Ochobase. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case Main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(Class _viewControllerClass: T.Type) -> T {
        let  storboardID = (_viewControllerClass as UIViewController.Type).storyboardID
        return self.instance.instantiateViewController(withIdentifier: storboardID) as! T
    }
}
