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
    var meses = [" Ene 2018 ", " Feb 2018 ", " Mar 2018 ", " Abr 2018 ", " May 2018 ", " Jun 2018 ", " Jul 2018 ", " Ago 2018 ", " Sep 2018 ", " Oct 2018 ", " Nov 2018 ", " Dic 2018 " , " Ene 2019 ", " Feb 2019 ", " Mar 2019 ", " Abr 2019 ", " May 2019 ", " Jun 2019 ", " Jul 2019 ", " Ago 2019 ", " Sep 2019 ", " Oct 2019 ", " Nov 2019 ", " Dic 2019 "]
    var consumptionByMonth:[Double] = [480.0,120.0,123.0,156.0,123.0,123.0,123.0,140.0,200.0,600.0,140.0,0.0,480.0,120.0,123.0,156.0,123.0,123.0,123.0,140.0,200.0,600.0,140.0,0.0]
    @IBOutlet weak var lineChartView: LineChartView! //cambia el nombre del view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart(dataPoints: meses, values: consumptionByMonth)
        // Do any additional setup after loading the view.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        let formato:LineChartFormatter = LineChartFormatter()
        let xaxis:XAxis = XAxis()
        lineChartView.noDataText = "Aún no tienes suficientes recibos para generar estadísticas"
        var dataEntries: [ChartDataEntry] = []
        var counter = 0
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y:values[i])
            dataEntries.append(dataEntry)
            counter = counter + 1
            formato.stringForValue(Double(i), axis: xaxis)
            xaxis.valueFormatter = formato
        }
        lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Consumo por mes")
        let chartData = LineChartData()
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        //barChartView.leftAxis.drawGridLinesEnabled = false
        chartDataSet.lineWidth = 4.0
        chartDataSet.colors = [UIColor(red: 24/255, green: 150/255, blue: 30/255, alpha: 1)]
        chartDataSet.circleHoleColor = UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1)

        chartDataSet.circleColors = [UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1)]
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInCubic)
        let limit = ChartLimitLine(limit: 500.0,label: "Límite de tarifa para alto consumo")
        lineChartView.leftAxis.addLimitLine(limit)
        chartData.addDataSet(chartDataSet)
        lineChartView.data = chartData
    lineChartView.zoomToCenter(scaleX: 5.0, scaleY: 0.5)
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
