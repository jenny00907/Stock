//
//  CalculatorTableVC.swift
//  Stock-Calculator
//
//  Created by Jenny Lee on 4/10/22.
//

import UIKit
import Combine


class CalculatorTableVC: UITableViewController {
    
    
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var annualReturnLabel: UILabel!
    @IBOutlet weak var initialAmountTextField: UITextField!
    @IBOutlet weak var monthlyAmountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var currencyAmountLabel: UILabel!
    @IBOutlet weak var dateSlider: UISlider!
    
    var asset: Asset?
    @Published private var dateIndex: Int?
    @Published private var initialAmount: Int?
    @Published private var monthlyAmount: Int?
    
    private var subscribers = Set<AnyCancellable>()
    private let dcaService = DCAService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpTextField()
        setUpDateSlider()
        observeForm()
    }
    
    private
    func setUpViews() {
        symbolLabel.text = asset?.searchResult.symbol
        assetNameLabel.text = asset?.searchResult.name
        currencyAmountLabel.text = asset!.searchResult.currency
        currencyLabels.forEach { (label) in
            let currency = asset!.searchResult.currency
            label.text = currency.addBrackets()
        }
    }
    
    private
    func setUpTextField() {
        initialAmountTextField.addDoneButton()
        monthlyAmountTextField.addDoneButton()
        
        dateTextField.delegate = self
        
    }
    
    private
    func setUpDateSlider() {
        if let count = asset?.monthlyAdjusted.getMonthlyInfo().count {
            let floatCount = (count - 1).asFloat
            dateSlider.maximumValue = floatCount
        }
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDateSelection",
            let vc = segue.destination as? DateSelectionTableVC,
            let monthlyAdjusted = sender as? MonthlyAdjusted {
            vc.monthlyAdjusted = monthlyAdjusted
            vc.selectedIndex = dateIndex
            
            vc.didSelectDate = { [weak self] index in
                self?.handleDateSelection(at: index)
            }
        }
    }
    
    private
    func handleDateSelection(at index: Int) {
        
        guard navigationController?.visibleViewController is DateSelectionTableVC else { return }
        navigationController?.popViewController(animated: true)
        
        if let monthInfos = asset?.monthlyAdjusted.getMonthlyInfo() {
            dateIndex = index
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.MMYYFormat
            
            dateTextField.text = dateString
        }
    }
    
    @IBAction func dateSliderDidChange(_ sender: UISlider) {
        dateIndex = Int(sender.value)
        
    }
    private
    func observeForm() {
        $dateIndex.sink { [weak self] (index) in
            guard let index = index else { return }
            self?.dateSlider.value = index.asFloat
            
            if let dateString = self?.asset?.monthlyAdjusted.getMonthlyInfo()[index].date.MMYYFormat {
                self?.dateTextField.text = dateString
            }
        }.store(in: &subscribers)
    
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialAmountTextField)
            .compactMap({
                ($0.object as? UITextField)?.text
            }).sink { [weak self] (text) in
                //print("InitialInvestmentTextField: \(text)")
                self?.initialAmount = Int(text) ?? 0
    
            }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyAmountTextField)
            .compactMap({
                ($0.object as? UITextField)?.text
            }).sink { [weak self] (text) in
//                print("monthlyAmountTextField: \(text)")
                self?.monthlyAmount = Int(text) ?? 0
                
            }.store(in: &subscribers)
        
        Publishers.CombineLatest3($initialAmount, $monthlyAmount, $dateIndex).sink {
            
            guard let initialAmount = $0, let monthlyAmount = $1, let dateIndex = $2, let asset = self.asset else { return }

            
            let result = self.dcaService.calculateAmount(asset: asset,initial: initialAmount.asDouble,
                                                         monthly: monthlyAmount.asDouble, dateIndex: dateIndex)
            self.currentLabel.backgroundColor = result.isProfitable == true ? .sGreen : .sRed
            self.currentLabel.text = result.current.toTwoDecimal
            self.amountLabel.text = result.amount.asCurrency
            self.gainLabel.text = result.gain.asCurrency
            self.yieldLabel.text = result.yield.asString
            self.annualReturnLabel.text = result.annualReturn.asString
            
        }.store(in: &subscribers)
        
    }
}

extension CalculatorTableVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dateTextField {
            performSegue(withIdentifier: "showDateSelection", sender: asset?.monthlyAdjusted)
            return false
        }
        return true
    }
}

