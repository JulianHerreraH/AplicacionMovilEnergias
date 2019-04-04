//
//  PeriodConsumptionViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/1/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import Charts

class PeriodConsumptionViewController: UIViewController {
    var meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
    var consumptionByMonth:[Double] = [480.0,120.0,123.0,156.0,123.0,123.0,123.0,140.0,200.0,600.0,140.0,0.0]
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart(dataPoints: meses, values: consumptionByMonth)
        // Do any additional setup after loading the view.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "Aún no tienes suficientes recibos para generar estadísticas"
        var dataEntries: [BarChartDataEntry] = []
        var counter = 0
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y:values[i])
            dataEntries.append(dataEntry)
            counter = counter + 1
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Consumo por mes")
        let chartData = BarChartData()
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        //barChartView.leftAxis.drawGridLinesEnabled = false
        chartDataSet.colors = [UIColor.green]
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInCubic)
        let limit = ChartLimitLine(limit: 500.0,label: "Límite de tarifa para alto consumo")
        barChartView.leftAxis.addLimitLine(limit)
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
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
