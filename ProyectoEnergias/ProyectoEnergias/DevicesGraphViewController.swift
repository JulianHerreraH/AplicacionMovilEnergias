//
//  PeriodConsumptionViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/1/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import Charts
import FirebaseAuth
import Firebase
class DevicesGraphViewController: UIViewController {

    @IBOutlet weak var bubbleChartView: BubbleChartView! //cambia el nombre del view
    var dataObj: [Any]?
    var dataStringURL = "http://martinmolina.com.mx/201911/data/ProyectoEnergiasRenovables/graphDevices.json"

    var devices = [" ","Calentador","Aire Acondicionado","Refrigerador", "Congelador","TV CRT","Computadora", "Plancha","Cafetera", "Impresora","Aspiradora" ,"Lavadora", "Consola","Microondas", "TV LCD", "Horno eléctrico", "Decodificador", "Secadora", "Sistema de audio", "Tostador", "DVD", "Regulador", "Licuadora", "Módem", "..."]
    var consumption = [0.0, 249, 182, 103,97,46,36,30,27,26,24,19,16,13,11,10,9,9,7,4,4,3,2,2, 0]
    override func viewDidLoad() {
        super.viewDidLoad()
        //DOWLOAD FROM JSON HAPPENS HERE
        var dataURL = URL(string:dataStringURL)
        let data = try? Data(contentsOf: dataURL!)
        dataObj = try!JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject]
        print("DATAOBJ\(dataObj)")
        var mapDictionary = dataObj?[0] as! [String:Any]
        print("MAP\(mapDictionary)")
        devices = mapDictionary["devices"] as! [String]
        var consumptionPerDevice = mapDictionary["consumption"] as! [Double]
        consumption = consumptionPerDevice
        
        setChart(dataPoints: self.devices, values: self.consumption)
            // ...
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var amounts = [0, 249, 182, 103,97,46,36,30,27,26,24,19,16,13,11,10,9,9,7,4,4,3,2,2, 0]
        let formato:BubbleChartFormatter = BubbleChartFormatter()
        let xaxis:XAxis = XAxis()
        bubbleChartView.noDataText = "Aún no tienes suficientes recibos para generar estadísticas"
        var dataEntries: [BubbleChartDataEntry] = []
        var counter = 0
        for i in 0..<dataPoints.count {
            let dataEntry = BubbleChartDataEntry(x: Double(i), y:values[i], size: (CGFloat(amounts[i])))
            
            dataEntries.append(dataEntry)
            counter = counter + 1
            formato.stringForValue(Double(i), axis: xaxis)
            xaxis.valueFormatter = formato
        }
        
        
        bubbleChartView.xAxis.valueFormatter = xaxis.valueFormatter
        let chartDataSet = BubbleChartDataSet(values: dataEntries, label: "Consumo total por mes (kWh)")
        let chartData = BubbleChartData()
        bubbleChartView.rightAxis.enabled = false
        bubbleChartView.leftAxis.enabled = false
        bubbleChartView.xAxis.drawGridLinesEnabled = false
        bubbleChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInCubic)
        chartDataSet.colors.append(UIColor(red: 149/255.0, green: 125/255.0, blue: 173/255.0, alpha: 1.0))
        chartDataSet.colors.append(UIColor(red: 224/255.0, green: 187/255.0, blue: 228/255.0, alpha: 1.0))
 
        chartDataSet.colors.append(UIColor(red: 210/255.0, green: 145/255.0, blue: 188/255.0, alpha: 1.0))
        chartDataSet.colors.append(UIColor(red: 254/255.0, green: 200/255.0, blue: 216/255.0, alpha: 1.0))
        chartDataSet.colors[0] = UIColor(red: 255/255.0, green: 223/255.0, blue: 211/255.0, alpha: 1.0)
        bubbleChartView.doubleTapToZoomEnabled = false
        bubbleChartView.scaleXEnabled = false
        bubbleChartView.scaleYEnabled = false
        bubbleChartView.highlightPerTapEnabled = false
        bubbleChartView.highlightPerDragEnabled = false
        bubbleChartView.dragXEnabled = true
        bubbleChartView.dragYEnabled = true

        chartData.addDataSet(chartDataSet)

        bubbleChartView.data = chartData

        bubbleChartView.xAxis.granularityEnabled = true
        bubbleChartView.xAxis.granularity = 1.0
        bubbleChartView.zoom(scaleX: 10.0, scaleY: 0.8, x: 0.0, y: 0.0)
        
    bubbleChartView.bubbleData?.setValueFont(UIFont (name: "Helvetica Neue", size: 18))
        
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
