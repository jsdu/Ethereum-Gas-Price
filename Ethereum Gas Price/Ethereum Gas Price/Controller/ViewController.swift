//
//  ViewController.swift
//  EthGasPrice
//
//  Created by Jing Song Du on 2020-01-15.
//  Copyright © 2020 Jing Song Du. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var lineChartView: LineChartView!

    @IBOutlet weak var headerTime: UILabel!
    @IBOutlet weak var headerCost: UILabel!
    @IBOutlet weak var headerGwei: UILabel!
    @IBOutlet weak var headerLabel: UILabel!

    @IBOutlet weak var loadingLabel: UILabel!

    @IBOutlet weak var fastLabel: UILabel!
    @IBOutlet weak var fastCost: UILabel!
    @IBOutlet weak var fastTime: UILabel!
    @IBOutlet weak var fastGwei: UILabel!

    @IBOutlet weak var standardLabel: UILabel!
    @IBOutlet weak var standardCost: UILabel!
    @IBOutlet weak var standardTime: UILabel!
    @IBOutlet weak var standardGwei: UILabel!

    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var lowTime: UILabel!
    @IBOutlet weak var lowGwei: UILabel!
    @IBOutlet weak var lowCost: UILabel!

    var ethGasCost: Double!
    var ethGasModel: ETHGasModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.isHidden = true
        getData()
    }

    func getData() {
        let client = EGPNetwork()
        client.getAPIData { (data) in
            client.getGasData { (ethGasModel) in
                DispatchQueue.main.async {
                    self.ethGasCost = data.current_price
                    self.ethGasModel = ethGasModel
                    self.setupChart()
                    self.setupUI()
                }
            }
        }
    }

    func setupChart() {

        lineChartView.delegate = self

        var chartEntries: [ChartDataEntry] = []
        var duplicateY: [Double: Bool] = [:]

        for (key, value) in ethGasModel.gasPriceRange {
            if Double(key)! >= ethGasModel.safeLow && duplicateY[value] == nil {
                duplicateY[value] = true
                let chartDataEntry = ChartDataEntry(x: Double(key)!, y: value)
                chartEntries.append(chartDataEntry)
            }
        }
        chartEntries.sort {
            $0.x < $1.x
        }

        let dataSet = LineChartDataSet(entries: chartEntries)
        dataSet.mode = .horizontalBezier
        dataSet.drawCirclesEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.lineWidth = 5
        dataSet.highlightLineWidth = 2

        lineChartView.data = LineChartData(dataSet: dataSet)

        setupChartViewOptions(lineChartView)

        lineChartView.highlightValue(x: ethGasModel.average, y: Double.nan, dataSetIndex: 0, callDelegate: true)
    }

    func setupChartViewOptions(_ lineChartView: LineChartView) {
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.data?.setDrawValues(false)
        lineChartView.isHidden = false
    }

    func setupUI() {
        loadingLabel.isHidden = true
        headerLabel.text = "/ Transfer"

        lowLabel.text = "Safe Low"
        lowTime.text = formatTime(ethGasModel.safeLowWait)
        lowCost.text = "$\(formatCost(ethGasModel.safeLow)) / Transfer"
        lowGwei.text = formatGwei((ethGasModel.safeLow))

        standardLabel.text = "Standard"
        standardTime.text = formatTime(ethGasModel.avgWait)
        standardCost.text = "$\(formatCost(ethGasModel.average)) / Transfer"
        standardGwei.text = formatGwei((ethGasModel.average))

        fastLabel.text = "Fast"
        fastTime.text = formatTime(ethGasModel.fastestWait)
        fastCost.text = "$\(formatCost(ethGasModel.fastest)) / Transfer"
        fastGwei.text = formatGwei((ethGasModel.fastest))
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        headerTime.text = formatTime(entry.y)
        headerCost.text = "$\(formatCost(entry.x))"
        headerGwei.text = formatGwei(entry.x)
    }

    func formatTime(_ min: Double) -> String {
        if min < 1 {
            return "\(Int(min * 60))s"
        } else {
            return "\(Int(min))m"
        }
    }

    func formatCost(_ gwei: Double) -> String {
        return String(format: "%.3f", (gwei/10) * ethGasModel.averageTransfer * ethGasCost * pow(10, -9))
    }

    func formatGwei(_ returnedGwei: Double) -> String {
        return "\(returnedGwei/10) GWEI"
    }
}
