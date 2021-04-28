//
//  ChartTableViewCell.swift
//  Chart
//
//  Created by Weslley Tavares de Aguiar e Quadros on 05/03/21.
//  Copyright © 2021 Luis Henrique Tavares  Dibrowa Ferreira. All rights reserved.
//

import UIKit
import Charts

protocol ChartTableViewCellDelegate: class {
    func chartValueSelected(idx: Int)
    func chartValueNothingSelected()
}
class ChartTableViewCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    var entries: [PieChartDataEntry] = Array()
    weak var delegate: ChartTableViewCellDelegate?
    
    func setupData(entries: [PieChartDataEntry] = Array(), amount: String, isSelected: Bool) {
        self.entries = entries
        pieChartView.delegate = self
        pieChartView.drawHoleEnabled = true
        pieChartView.legend.enabled = false
        pieChartView.rotationEnabled = false
        
        let centerText = NSMutableAttributedString()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let titlePartOne = NSAttributedString(string: "Total investido",
                                            attributes: [.font: UIFont.systemFont(ofSize: 12), .paragraphStyle: paragraph])
        
        let titlePartTwo = NSAttributedString(string: "\nR$ \(amount)",
                                            attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .paragraphStyle: paragraph])

        centerText.append(titlePartOne)
        centerText.append(titlePartTwo)
        
        pieChartView.centerAttributedText = centerText
        pieChartView.drawEntryLabelsEnabled = false
        
        pieChartView.holeRadiusPercent = 0.90
        pieChartView.holeColor = .white
        
        let dataSet = PieChartDataSet(entries: entries)
        
        let c1 = NSUIColor(hex: 0x41649A)
        let c2 = NSUIColor(hex: 0xF1DF5E)
        let c4 = NSUIColor(hex: 0x56B69C)
        let c5 = NSUIColor(hex: 0xB5C658)
        let c6 = NSUIColor(hex: 0x9A53B0)
        
        dataSet.sliceSpace = 6
        dataSet.selectionShift = 6
        
        dataSet.colors = [c1, c2, c4, c5, c6]
        dataSet.drawValuesEnabled = false
            
        pieChartView.data = PieChartData(dataSet: dataSet)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] {

            let sliceIndex: Int = dataSet.entryIndex( entry: entry)
            percentLabel.text = "\(entries[sliceIndex].value) %"
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.percentLabel.alpha = 1
            })
            print( "Index do Slice selecionado: \( sliceIndex)")
            delegate?.chartValueSelected(idx: sliceIndex)
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.percentLabel.alpha = 0
        })
    }


}
