//
//  Custom2BackSegue.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/9/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class Custom2BackSegue: UIStoryboardSegue {
    override func perform() {
        if let navigationController = source.navigationController as UINavigationController? {
            var controllers = navigationController.viewControllers
            controllers.removeLast()
            controllers.append(destination)
            navigationController.setViewControllers(controllers, animated: true)
        }
    }
}
