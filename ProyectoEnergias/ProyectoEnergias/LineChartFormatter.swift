//
//  LineChartFormatter.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/6/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import Foundation
import Charts

@objc(BarChartFormatter)
public class LineChartFormatter: NSObject, IAxisValueFormatter
{
    var meses = ["Ene 2018", "Feb 2018", "Mar 2018", "Abr 2018", "May 2018", "Jun 2018", "Jul 2018", "Ago 2018", "Sep 2018", "Oct 2018", "Nov 2018", "Dic 2018" , "Ene 2019", "Feb 2019", "Mar 2019", "Abr 2019", "May 2019", "Jun 2019", "Jul 2019", "Ago 2019", "Sep 2019", "Oct 2019", "Nov 2019", "Dic 2019" ]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return meses[Int(value)]
    }
}
