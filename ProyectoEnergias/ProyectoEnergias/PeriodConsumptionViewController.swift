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
    var realPeriods = ["Ene2018","Feb2018","Mar2018","Abr2018","May2018","Jun2018","Jul2018","Ago2018","Sep2018","Oct2018","Nov2018","Dic2018","Ene2019","Feb2019","Mar2019","Abr2019","May2019","Jun2019","Jul2019","Ago2019","Sep2019","Oct2019","Nov2019","Dic2019"]
    let defaults = UserDefaults.standard
    var limitTar = 300.0
    var isHighConsum = false
    var consumptionByMonth:[Double] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    var userDataReceipts = [[String:String]]()
    @IBOutlet weak var lineChartView: LineChartView! //cambia el nombre del view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataReceipts = defaults.array(forKey: "userDataReceipts") as! [[String : String]]
        for receipt in userDataReceipts{
            var monthYearInitial = ""
            var monthYearFinal = ""
            monthYearInitial += receipt["PeriodoInicial"] ?? "Ene"
            monthYearInitial += receipt["añoInicial"] ?? "2019"
            monthYearFinal += receipt["PeriodoFinal"] ?? "Ene"
            monthYearFinal += receipt["añoFinal"] ?? "2019"
            var tarifType = receipt["Tarifa"] ?? "1A"
            tarifType = tarifType.uppercased()
            if(tarifType == "1"){
                limitTar = 250
            }
            else if(tarifType == "1B"){
                limitTar = 400
            }
            else if(tarifType == "1C"){
                limitTar = 850
            }
            else if(tarifType == "1D"){
                limitTar = 1000
            }
            else if(tarifType == "1E"){
                limitTar = 2000
            }
            else if(tarifType == "1F"){
                limitTar = 2500
            }
            else if(tarifType == "DAC"){
                var consum = receipt["ConstumoTotal"] ?? "500.0"
                limitTar = Double(consum) ?? 500.0
                isHighConsum = true
            }
            else{
                limitTar = 300
            }
            monthYearInitial = monthYearInitial.lowercased()
            monthYearFinal = monthYearFinal.lowercased()
            var thisPeriodsConsumption = receipt["ConsumoTotal"] ?? "0.0"
            var indexInitial = 0
            var indexFinal = 0
            var forloopounter = 0
            for mes in realPeriods {
                if monthYearInitial == mes.lowercased() {
                    indexInitial = forloopounter
                }
                if monthYearFinal == mes.lowercased(){
                    indexFinal = forloopounter
                }
                forloopounter = forloopounter + 1
            }
            
            for x in indexInitial...indexFinal {
                consumptionByMonth[x] = Double(thisPeriodsConsumption) ?? 0.0
            }
            
        }
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
        
        var limitDataEntry : [ChartDataEntry] = []
        limitDataEntry.append(ChartDataEntry(x: 0.0,y: limitTar))
        
        lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Consumo total por mes (kWh)")
        let chartDataSetLimit = LineChartDataSet(values: limitDataEntry, label: "")
        
        let chartData = LineChartData()
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        //barChartView.leftAxis.drawGridLinesEnabled = false
        chartDataSet.lineWidth = 4.0
        chartDataSet.colors = [UIColor(red: 24/255, green: 150/255, blue: 30/255, alpha: 1)]
        chartDataSet.circleHoleColor = UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1)

        chartDataSet.circleColors = [UIColor(red: 14/255, green: 69/255, blue: 124/255, alpha: 1)]
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInCubic)
        var limit = ChartLimitLine(limit: limitTar,label: "")
        var limitTarif = "Límite de tarifa para alto consumo"
        var limitX = "Te encuentras en una tarifa de alto consumo"
        
        var limitLegend = LegendEntry.init(label: limitTarif, form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor(red: 230/255, green: 0/255, blue: 0/255, alpha: 1))
        if(isHighConsum){
            limitLegend = LegendEntry.init(label: limitX, form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor(red: 230/255, green: 0/255, blue: 0/255, alpha: 1))
        }

        lineChartView.legend.extraEntries = [limitLegend]
        if(isHighConsum){
            limit = ChartLimitLine(limit: limitTar,label: "")
        }
        chartDataSetLimit.drawIconsEnabled = false
        chartDataSetLimit.drawCirclesEnabled = false
        chartDataSetLimit.drawCircleHoleEnabled = false
        chartData.addDataSet(chartDataSet)
        chartDataSetLimit.colors = [UIColor(red: 24/255, green: 150/255, blue: 30/255, alpha: 1)]
        chartData.addDataSet(chartDataSetLimit)
        lineChartView.data = chartData
        limit.lineColor = UIColor(red: 230/255, green: 0/255, blue: 0/255, alpha: 1)
        lineChartView.leftAxis.addLimitLine(limit)
        lineChartView.xAxis.granularityEnabled = true
        lineChartView.xAxis.granularity = 1.0
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
