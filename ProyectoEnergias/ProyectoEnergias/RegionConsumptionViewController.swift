//
//  RegionConsumptionViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/8/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//


import UIKit
import Charts
import FirebaseAuth
import Firebase

class RegionConsumptionViewController: UIViewController {
    let defaults = UserDefaults.standard
    var averageCost = 0.0
     var estados = ["", "    Aguascalientes", "   Baja California   ", "   Baja California Sur   ", "Campeche", "Chiapas", "Chihuahua", "Coahuila", "Colima", "Ciudad de México", "Durango", "Estado de México", "Guanajuato", "Guerrero" , "Hidalgo", "Jalisco", "Michoacán", "Morelos", "Nayarit", "Nuevo León", "Oaxaca", "Puebla", "Querétaro", "Quintana Roo", "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz", "Yucatán", "Zacatecas" , ""]
    var consumptionByMonth:[Double] = [0, 252, 377,1100, 249, 237, 375, 317, 252, 270, 258, 261, 254,210, 195, 262, 242, 325, 207, 277, 190, 228, 260,350, 248, 435, 498, 291, 523, 232, 212, 329,340,214,0]
    private let locationManager = LocationManager()

    
    @IBOutlet weak var lineChartView: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var costoTotal = 0.0
        var receiptCounter = 0.0
        var userDataReceipts = [[String : String]]()
        
        var ref:DatabaseReference = Database.database().reference()
        var recibos:NSArray?
        ref.child("usuarios").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            print("FOUNDVALUE")
            
            if value != nil{
                recibos = (value?["Recibos"] as? NSArray)!
                print("FOUNDVALUEARRAY")
                if recibos != nil {
                    print(recibos)

                }
            }
            
            userDataReceipts = recibos as! [[String : String]]
            
            print("reCEIVED DATA FROM FIREBASE")
            //print(recibos)
            if (recibos != nil ){
                var userDataReceiptsMine = [[String:String]]()
                userDataReceipts = recibos as! [[String : String]]
            }
            
            for receipt in userDataReceipts{
                var costoString = receipt["CostoTotal"] as! String
                var costoDouble = Double(costoString) ?? -10
                if(costoDouble != -10  || costoDouble != 0) {
                    costoTotal += costoDouble
                    receiptCounter = receiptCounter + 1.0
                }
            }
            print("AAVERAGE")
            
            self.averageCost = costoTotal/receiptCounter
            print(self.averageCost)
            self.view.layoutIfNeeded()
            let alert = UIAlertController(title: "Importante", message: "Los datos presentados a continuación están basados en la información más reciente publicada por la CFE sobre el consumo promedio por estado", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
            //self.present(alert, animated: true)
            self.setChart(dataPoints: self.estados, values: self.consumptionByMonth)
            // Do any additional setup after loading the view.
            self.removeSpinner()
            // ...
        }) { (error) in
            let alert = UIAlertController(title: "alerta", message: error.localizedDescription, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            print("ERRORFOUND")
            print(error.localizedDescription)
            self.removeSpinner()
            }
        
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
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Consumo promedio de usuario ($ - Bimestral)")
        let chartData = LineChartData()
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        //barChartView.leftAxis.drawGridLinesEnabled = false
        chartDataSet.lineWidth = 4.0
        chartDataSet.colors = [UIColor(red: 24/255, green: 30/255, blue: 150/255, alpha: 1)]
        chartDataSet.circleHoleColor = UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 0)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.circleColors = [
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1),
            UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1)
        ]
        var limitLegend = LegendEntry.init(label: "Mi ubicación actual", form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1))
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        chartDataSet.mode = .cubicBezier
        chartData.addDataSet(chartDataSet)
        var limit = ChartLimitLine(limit: averageCost,label: "")
         var limitLegend2 = LegendEntry.init(label: "Mi consumo promedio", form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 1))
        limit.lineColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 1)
        lineChartView.legend.extraEntries = [limitLegend, limitLegend2]
        lineChartView.data = chartData
        lineChartView.xAxis.granularityEnabled = true
        lineChartView.xAxis.granularity = 1.0
        lineChartView.zoomToCenter(scaleX: 15, scaleY: 0.5)
        lineChartView.moveViewToX(8.0)
        lineChartView.leftAxis.addLimitLine(limit)

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
