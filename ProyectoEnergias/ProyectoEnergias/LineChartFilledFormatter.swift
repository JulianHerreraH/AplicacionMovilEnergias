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

@objc(LineChartFormatter)
public class LineChartFilledFormatter: NSObject, IAxisValueFormatter
{
    var estados = ["", "Aguascalientes", "Baja California", "Baja California Sur", "Campeche", "Chiapas", "Chihuahua", "Coahuila", "Colima", "Ciudad de México", "Durango", "Estado de México", "Guanajuato", "Guerrero" , "Hidalgo", "Jalisco", "Michoacán", "Morelos", "Nayarit", "Nuevo León", "Oaxaca", "Puebla", "Querétaro", "Quintana Roo", "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz", "Yucatán", "Zacatecas", "" ]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return estados[Int(value)]
    }
}
