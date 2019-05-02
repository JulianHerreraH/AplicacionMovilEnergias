//
//  BubbleChartFormatter.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/29/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//
import UIKit
import Foundation
import Charts

@objc(BubbleChartFormatter)
public class BubbleChartFormatter: NSObject, IAxisValueFormatter
{
    var devices = [" ","Calentador","Aire Acondicionado","Refrigerador", "Congelador","TV CRT","Computadora", "Plancha","Cafetera", "Impresora","Aspiradora" ,"Lavadora", "Consola","Microondas", "TV LCD", "Horno eléctrico", "Decodificador", "Secadora", "Sistema de audio", "Tostador", "DVD", "Regulador", "Licuadora", "Módem", "..."]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return devices[Int(value)]
    }
}
