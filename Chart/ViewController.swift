//
//  ViewController.swift
//  Chart
//
//  Created by Luis Henrique Tavares  Dibrowa Ferreira on 02/03/21.
//  Copyright © 2021 Luis Henrique Tavares  Dibrowa Ferreira. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var btnHide: UIButton!
    @IBOutlet var tableView: UITableView! = UITableView()
    private var entries: [PieChartDataEntry] = Array()
    private var listCell = [CellComponentDTO]()
    public var isSelected = false
    public var indexSlice = Int()
    private var amountHidden = false
    private var amount = "500.000,00"
    private let colors = [0x41649A, 0xF1DF5E, 0x56B69C, 0xB5C658, 0x9A53B0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellChartTableViewCell.self)
        tableView.register(ChartTableViewCell.self)
        tableView.tableFooterView = UIView()
   
        setupChart()
        setupTableView()
    }
    
    @IBAction func showHideAmoutAction(_ sender: Any) {
        amountHidden = !amountHidden
        amountHidden ? hideAmount() : showAmount()
    }
}

private extension ViewController {
    func setupChart() {
        entries.removeAll()
        entries.append(PieChartDataEntry(value: 50.0, label: "Renda Fixa"))
        entries.append(PieChartDataEntry(value: 30.0, label: "Fundos"))
        entries.append(PieChartDataEntry(value: 40.0, label: "Renda Variável"))
        entries.append(PieChartDataEntry(value: 20.0, label: "Tesouro Direto"))
        entries.append(PieChartDataEntry(value: 10.0, label: "Previdência privada"))
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        
        for (indexEntries, entries) in entries.enumerated() {
            for (indexColor, color) in colors.enumerated() {
                if indexEntries == indexColor {
                    listCell.append(CellComponentDTO(collor: color, title: entries.label ?? "", value: entries.value))
                }
                
            }
        }
        tableView.reloadData()
    }
    
    private func showAmount() {
        self.amountHidden = false
        btnHide.setTitle("OCULTAR", for: .normal)
        DispatchQueue.main.async {
            self.amount = "500.000,00"
            self.tableView.reloadData()
        }
    }
    
    private func hideAmount() {
        self.amountHidden = true
        btnHide.setTitle("EXIBIR", for: .normal)
        DispatchQueue.main.async {
            self.amount = "*******"
            self.tableView.reloadData()
        }
    }
}

extension NSUIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid red component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
}

extension ViewController: ChartTableViewCellDelegate {
    func chartValueSelected(idx: Int) {
        DispatchQueue.main.async{
            self.isSelected = true
            self.indexSlice = idx
            self.tableView.reloadData()
        }
    }
    
    func chartValueNothingSelected() {
        DispatchQueue.main.async{
            self.isSelected = false
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCell.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell: ChartTableViewCell = ChartTableViewCell.createCell(tableView: tableView, indexPath: indexPath)
            cell.selectionStyle = .none
            cell.setupData(entries: self.entries, amount: self.amount, isSelected: isSelected)
            cell.delegate = self
            return cell
        }
        else {
            let cell: CellChartTableViewCell = CellChartTableViewCell.createCell(tableView: tableView, indexPath: indexPath)
            cell.selectionStyle = .none
            cell.fill(dto: listCell[indexPath.row - 1], hideAmount: amountHidden)

            if isSelected {
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    if indexPath.row - 1  == self.indexSlice {
                        cell.normalCell()
                    } else {
                        cell.clearCell()
                    }
                })
                
            } else {
                cell.normalCell()
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 258
        } else {
            return 50
        }
    }
}


extension UIView {
    class func initFromNib<T: UIView>() -> T {
        Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T ?? T()
    }

    func fillWithSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        let views = ["view": subview]
        
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                metrics: nil,
                                                                views: views)
        
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: nil,
                                                                  views: views)
        
        addConstraints(verticalConstraint)
        addConstraints(horizontalConstraint)
        updateConstraints()
        
        subview.setNeedsDisplay()
        layoutIfNeeded()
    }
    
    func setRounded() {
        let radius = self.frame.size.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_ : T.Type) {
        let identifier = String(describing: T.self)
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
}

extension UITableViewCell {
    class func createCell<T: UITableViewCell>(tableView: UITableView, indexPath: IndexPath) -> T {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T ?? T()
    }
}
