//
//  MainTabViewController.swift
//  ProyectoEnergias
//
//  Created by cdt307 on 3/6/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    @IBInspectable var defaultTab:Int = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = defaultTab;
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
