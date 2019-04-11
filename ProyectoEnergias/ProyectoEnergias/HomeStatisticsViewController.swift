//
//  HomeARViewController.swift
//  ProyectoEnergias
//
//  Created by Ali Bryan Villegas Zavala on 3/17/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class HomeStatisticsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Estadísticas"
        navigationItem.backBarButtonItem = backItem
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
