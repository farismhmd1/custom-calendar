//
//  ViewController.swift
//  CustomCalendar
//
//  Created by Faris.
//

import UIKit

protocol CalendarViewControllerDelegate: class {
    func selectedDate(date: String, selected: Date)
    func selectedMonthFirstDate(date: String, firstDate: Date)
}

class CalendarViewController: UIViewController {
    
    
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearView: UIView!
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var topStackView: UIStackView!
    
    
    var preDateSelectable: Bool = true
    weak var delegate: CalendarViewControllerDelegate?
    
    var prevDayColor = UIColor(hex: 0x584a66)
    var outsideMonthColor = UIColor(hex: 0x584a66)
    var monthColor = UIColor.white
    var selectedMonthColor = UIColor(hex: 0x3a294b)
    var selectedDateViewColor = UIColor(hex: 0x4e3f5d)
    var selectedDateTextColor = UIColor.darkGray
    var selectedRangeColor = UIColor.red.withAlphaComponent(0.5)
    var selectedMonthFirstDate = Date()
    
    /// Calendar start date
    var calendarStartDate = "2020 01 01"
    /// Calendar end date
    var calendarEndDate = "2020 12 31"
    
    let formatter = DateFormatter()
    enum calendarType {
        case weekly,monthly
    }
    enum selectionMode {
        case single, multiple
    }
    var calendarSelectionMode = selectionMode.multiple
    
    var numberOfCalendarRows = 1 // or 6
    
    // date range selection
    var firstDate: Date?
    var lastDate: Date?
    var rangeSelectedDates: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupCalendarView()
        setupTopStackView()
        setupLabels()
        //        setupButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Methods
    func setupTopStackView() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            topStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            topStackView.widthAnchor.constraint(equalToConstant: 315),
            topStackView.heightAnchor.constraint(equalToConstant: 433)
        ])
    }
    
    
    /// For changing calenda style to weekly and monthly
    /// - Parameter to: calendar type
    func switchCalendar(to: calendarType) {
        if to == .weekly {
            numberOfCalendarRows = 1
        } else {
            numberOfCalendarRows = 6
        }
        calendarView.reloadData()
        // If Selected date belongs to same month when switching types
        // scroll to that selected date
        calendarView.scrollToDate(selectedMonthFirstDate, animateScroll: false)
    }
    //    func setupButtons() {
    //        doneButton.translatesAutoresizingMaskIntoConstraints = false
    //        cancelButton.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //
    //            doneButton.bottomAnchor.constraint(equalTo: self.topStackView.bottomAnchor, constant: -8),
    //            doneButton.trailingAnchor.constraint(equalTo: self.topStackView.trailingAnchor, constant: -24),
    //
    //            cancelButton.bottomAnchor.constraint(equalTo: self.topStackView.bottomAnchor, constant: -8),
    //            cancelButton.trailingAnchor.constraint(equalTo: self.doneButton.leadingAnchor, constant: -24)
    //        ])
    //    }
    
    func setupLabels() {
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        yearView.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        selectedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            yearView.topAnchor.constraint(equalTo: self.topStackView.topAnchor),
            yearView.heightAnchor.constraint(equalToConstant: 50),
            yearView.widthAnchor.constraint(equalTo: topStackView.widthAnchor, multiplier: 0),
            
            monthLabel.centerYAnchor.constraint(equalTo: self.yearView.centerYAnchor),
            monthLabel.centerXAnchor.constraint(equalTo: self.yearView.centerXAnchor),
            
            dateView.topAnchor.constraint(equalTo: self.yearView.bottomAnchor, constant: 8),
            dateView.widthAnchor.constraint(equalTo: topStackView.widthAnchor, multiplier: 0),
            
            selectedDateLabel.centerYAnchor.constraint(equalTo: self.dateView.centerYAnchor),
            selectedDateLabel.centerXAnchor.constraint(equalTo: self.dateView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: self.dateView.bottomAnchor, constant: 16),
            stackView.widthAnchor.constraint(equalTo: topStackView.widthAnchor, multiplier: 0)
        ])
    }
    
    
    func setupCalendarView() {
        
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Setup labels
        if firstDate != nil {
            calendarView.scrollToDate(firstDate!, animateScroll: false)
            calendarView.selectDates([firstDate!])
        }
        
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        
        if calendarSelectionMode == .multiple {
            calendarView.allowsMultipleSelection = true
            calendarView.rangeSelectionMode = .continuous
            calendarView.allowsRangedSelection = true
            
//            let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
//            panGensture.minimumPressDuration = 0.5
//            calendarView.addGestureRecognizer(panGensture)
        }
    }
    
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        self.selectedMonthFirstDate = date
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        monthLabel.text = "\(month), \(year)"
        
        self.delegate?.selectedMonthFirstDate(date: monthLabel.text ?? "", firstDate: date)
    }
    
    func setDateInfoDetailsUI() {
        let formatters = DateFormatter()
        formatters.dateFormat = "dd MMM yyyy"
        
        if firstDate != nil && lastDate != nil && firstDate != lastDate {
            selectedDateLabel.text = "\(formatters.string(from: firstDate!)) to \(formatters.string(from: lastDate!))"
        } else if firstDate != nil && lastDate != nil {
            selectedDateLabel.text = "\(formatters.string(from: firstDate!))"
        } else {
            selectedDateLabel.text = ""
        }
        
        
        
    }
    
    func setUpRangeSelection(){
        self.calendarView.allowsMultipleSelection = true
        self.calendarView.allowsRangedSelection = true
    //        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
    //        panGensture.minimumPressDuration = 0.2
    //        self.calendarView.addGestureRecognizer(panGensture)
        }
    func handleCellTextColor(view: JTACDayCell?, cellState: CellState) {
            guard let validCell = view as? CustomDayCell else { return }
        
            validCell.isHidden = false
            let todaysDate = Date()
            formatter.dateFormat = "yyyy MM dd"
            let todayDateString = formatter.string(from: todaysDate)
            let monthsDateString = formatter.string(from: cellState.date)
            if todayDateString == monthsDateString && cellState.dateBelongsTo == .thisMonth {
                // current selected day label color
                validCell.dateLabel.textColor = selectedDateTextColor
            } else if cellState.date < todaysDate && cellState.dateBelongsTo == .thisMonth{
                validCell.dateLabel.textColor = prevDayColor
            }else {
                if cellState.isSelected {
                    if cellState.dateBelongsTo == .thisMonth {
                        validCell.dateLabel.textColor = self.selectedMonthColor
                    }
                } else {
                    if cellState.dateBelongsTo == .thisMonth {
                        validCell.dateLabel.textColor = self.monthColor
                    }
                }
            }
            if cellState.dateBelongsTo != .thisMonth {
                validCell.isHidden = true
            }
        }
    func handleCellSelected(view: JTACDayCell?, cellState: CellState) {
            guard let validCell = view as? CustomDayCell else { return }
            
            if cellState.isSelected && cellState.dateBelongsTo == .thisMonth {
    //            if cellState.dateBelongsTo != .thisMonth {
    //                validCell.selectedView.isHidden = true
    //                validCell.leftView.isHidden = true
    //                validCell.rightView.isHidden = true
    //                validCell.backgroundColor = UIColor.clear
    //            } else {
    //                validCell.selectedView.isHidden = false
    //            }
                validCell.selectedView.isHidden = false
            } else {
                validCell.selectedView.isHidden = true
                validCell.leftView.isHidden = true
                validCell.rightView.isHidden = true
                validCell.backgroundColor = UIColor.clear
                validCell.dateLabel.isHidden = false

            }
        }
    func handleDateRangeSelection(view: JTACDayCell?, cellState: CellState) {
            guard let cell = view as? CustomDayCell else { return }
            cell.leftView.backgroundColor = selectedRangeColor
            cell.rightView.backgroundColor = selectedRangeColor
            if calendarView.allowsMultipleSelection {
                if cellState.isSelected {
//                    if cellState.dateBelongsTo == .thisMonth {
//                        cell.selectedView.isHidden = false
//                    } else {
//                        cell.selectedView.isHidden = true
//                    }
//                    cell.selectedView.isHidden = false
                    switch cellState.selectedPosition() {
                        
                    case .full:
                        cell.dateLabel.isHidden = false
                        cell.backgroundColor = UIColor.clear
                        cell.selectedView.backgroundColor = self.selectedDateViewColor
                        cell.leftView.isHidden = true
                        cell.rightView.isHidden = true
                    case .right:
                        //cell.selectedView.isHidden = false
//                        if cellState.dateBelongsTo != .thisMonth {
//                            cell.leftView.isHidden = true
//                        } else {
//                            cell.leftView.isHidden = false
//                        }
                        cell.leftView.isHidden = false
                        cell.rightView.isHidden = true
                        cell.backgroundColor = UIColor.clear
                        cell.selectedView.backgroundColor = self.selectedDateViewColor
                    case .left:
                        //cell.selectedView.isHidden = false
//                        if cellState.dateBelongsTo != .thisMonth {
//                            cell.rightView.isHidden = true
//                        } else {
//                            cell.rightView.isHidden = false
//                        }
                        cell.leftView.isHidden = true
                        cell.rightView.isHidden = false
                        cell.backgroundColor = UIColor.clear
                        cell.selectedView.backgroundColor = self.selectedDateViewColor
                    case .middle:
//                        if cellState.dateBelongsTo != .thisMonth {
//                            cell.dateLabel.isHidden = true
//                        } else {
//                            cell.dateLabel.isHidden = false
//                        }
                        cell.dateLabel.isHidden = false
                        cell.backgroundColor = .clear
                        cell.leftView.isHidden = false
                        cell.rightView.isHidden = false
                        cell.selectedView.backgroundColor = self.selectedRangeColor // Or what ever you want for your dates that land in the middle
                    default:
                        cell.backgroundColor = UIColor.clear
                        cell.dateLabel.isHidden = false
                        cell.leftView.isHidden = true
                        cell.rightView.isHidden = true
                        cell.selectedView.isHidden = true
                        cell.selectedView.backgroundColor = nil // Have no selection when a cell is not selected
                    }
                }
                
            }
        }
    
    // MARK: - Actions
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        
//        self.delegate?.selectedDate(date: selectedDateLabel.text!, selected: self.selectedDate!)
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension CalendarViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: calendarStartDate)//Date()
        let endDate = formatter.date(from: calendarEndDate)
        
        //        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate!)
        
        let parameters = ConfigurationParameters(startDate: startDate!,
                                                 endDate: endDate!,
                                                 numberOfRows: numberOfCalendarRows,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
    
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleDateRangeSelection(view: cell, cellState: cellState)
        cell.layoutIfNeeded()
    }
    // Display Cell
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomDayCell", for: indexPath) as! CustomDayCell
        cell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleDateRangeSelection(view: cell, cellState: cellState)
        
        //        if cellState.dateBelongsTo != .thisMonth {
        //            cell.isHidden = true
        //        } else {
        //            cell.isHidden = false
        //        }
        cell.layoutIfNeeded()
        return cell
    }
    
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleDateRangeSelection(view: cell, cellState: cellState)

        if firstDate != nil {
            if date < self.firstDate! {
                self.firstDate = date
            } else {
                self.lastDate = date
            }
            calendarView.selectDates(from: firstDate!, to: self.lastDate!,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            firstDate = date
            self.lastDate = date
        }
        
        setDateInfoDetailsUI()
        //self.rangingStarted(cellState: cellState)
        cell?.bounce()
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleDateRangeSelection(view: cell, cellState: cellState)
        if firstDate != nil && lastDate != nil {
            self.calendarView.deselectDates(from: self.firstDate!, to: self.lastDate!, triggerSelectionDelegate: false)
        }
        
        if date != self.firstDate && date != self.lastDate {
            if date < self.firstDate! {
                self.firstDate = date
            } else {
                self.lastDate = date
            }
            calendarView.selectDates(from: firstDate!, to: self.lastDate!,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            cell?.bounce()
        } else {
            self.firstDate = nil
            self.lastDate = nil
        }
        
        setDateInfoDetailsUI()
    }
    
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
}

extension UIView {
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.1,
                       options: UIView.AnimationOptions.beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}
