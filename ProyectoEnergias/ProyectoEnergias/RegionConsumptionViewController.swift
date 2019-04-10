//
//  RegionConsumptionViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/8/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//


import UIKit
import Charts

class RegionConsumptionViewController: UIViewController {
    let defaults = UserDefaults.standard
    var averageCost = 0.0
     var estados = ["    Aguascalientes", "   Baja California   ", "   Baja California Sur   ", "Campeche", "Chiapas", "Chihuahua", "Coahuila", "Colima", "Ciudad de México", "Durango", "Estado de México", "Guanajuato", "Guerrero" , "Hidalgo", "Jalisco", "Michoacán", "Morelos", "Nayarit", "Nuevo León", "Oaxaca", "Puebla", "Querétaro", "Quintana Roo", "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz", "Yucatán", "Zacatecas" ]
    var consumptionByMonth:[Double] = [458, 439,624, 327, 156, 323, 738, 775, 485, 330, 431, 282,453, 191, 301, 350, 323, 266, 252, 691, 143, 277,503, 550, 465, 498, 743, 350, 525, 354, 268,349,233]

    
    @IBOutlet weak var lineChartView: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var userDataReceipts = defaults.array(forKey: "userDataReceipts") as! [[String : String]]
        var costoTotal = 0.0
        var receiptCounter = 0.0
        for receipt in userDataReceipts{
            var costoString = receipt["ConsumoTotal"] as! String
            var costoDouble = Double(costoString) ?? -10
            if(costoDouble != -10  || costoDouble != 0) {
                costoTotal += costoDouble
                receiptCounter = receiptCounter + 1.0
            }
        }
        
         averageCost = costoTotal/receiptCounter
        
        let alert = UIAlertController(title: "Importante", message: "Los datos presentados a continuación están basados en la información más reciente publicada por la CFE sobre el consumo promedio por estado", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
        self.present(alert, animated: true)
        setChart(dataPoints: estados, values: consumptionByMonth)
        // Do any additional setup after loading the view.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        let formato:LineChartFilledFormatter = LineChartFilledFormatter()
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
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Consumo promedio de usuario (kWh - Mes)")
        let chartData = LineChartData()
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        //barChartView.leftAxis.drawGridLinesEnabled = false
        chartDataSet.lineWidth = 4.0
        chartDataSet.colors = [UIColor(red: 24/255, green: 30/255, blue: 150/255, alpha: 1)]
        chartDataSet.circleHoleColor = UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 0)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.circleColors = [UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 0)]
        chartDataSet
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        chartDataSet.mode = .cubicBezier
        chartData.addDataSet(chartDataSet)
        var limit = ChartLimitLine(limit: averageCost,label: "")
         var limitLegend = LegendEntry.init(label: "Mi consumo promedio", form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 1))
        limit.lineColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 1)
        lineChartView.leftAxis.addLimitLine(limit)
        lineChartView.legend.extraEntries = [limitLegend]
        lineChartView.data = chartData
        lineChartView.xAxis.granularityEnabled = true
        lineChartView.xAxis.granularity = 1.0
        lineChartView.zoomToCenter(scaleX: 10.0, scaleY: 0.5)
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
