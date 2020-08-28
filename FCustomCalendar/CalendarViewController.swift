//
//  ViewController.swift
//  CustomCalendar
//
//  Created by Faris.
//

import UIKit

protocol CalendarViewControllerDelegate: class {
    func selectedDate(date: String, selected: Date)
}

class CalendarViewController: UIViewController {

    var preDateSelectable: Bool = true
    weak var delegate: CalendarViewControllerDelegate?
    
    var outsideMonthColor = UIColor(hex: 0x584a66)
    var monthColor = UIColor.white
    var selectedMonthColor = UIColor(hex: 0x3a294b)
    var selectedDateViewColor = UIColor(hex: 0x4e3f5d)
    var selectedDateTextColor = UIColor.darkGray
    var selected = Date()
    
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearView: UIView!
    
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var topStackView: UIStackView!
    
    
    let formatter = DateFormatter()
    enum calendarType {
        case weekly,monthly
    }
    var numberOfCalendarRows = 1 // or 6
    
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
        selectedDate.translatesAutoresizingMaskIntoConstraints = false
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
            
            selectedDate.centerYAnchor.constraint(equalTo: self.dateView.centerYAnchor),
            selectedDate.centerXAnchor.constraint(equalTo: self.dateView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: self.dateView.bottomAnchor, constant: 16),
            stackView.widthAnchor.constraint(equalTo: topStackView.widthAnchor, multiplier: 0)
        ])
    }
    
    func setupCalendarView() {
        
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Setup labels
        calendarView.scrollToDate(selected, animateScroll: false)
        calendarView.selectDates([selected])
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        monthLabel.text = "\(month), \(year)"
    }
    
    func setDate(date: Date) {
        let formatters = DateFormatter()
        formatters.dateFormat = "dd MMM yyyy"
        self.selected = date
        selectedDate.text = formatters.string(from: date)
    }
    
    func handleCellTextColor(view: JTACDayCell?, cellState: CellState) {
        guard let validCell = view as? CustomDayCell else { return }
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedDateTextColor
            validCell.selectedView.backgroundColor = selectedDateViewColor
        } else {
   
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
                
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
  
    func handleCellSelected(view: JTACDayCell?, cellState: CellState, date: Date) {
        guard let validCell = view as? CustomDayCell else { return }
        
        if cellState.dateBelongsTo != .thisMonth {
//            dayNotBelongingThisMonthStyle(cell: validCell, cellState: cellState)
            dayBelongToCurrentMonthStyle(view: view, cell: validCell, cellState: cellState)
        } else if date.isSmaller(to: Date()) && !preDateSelectable {
            dayBeforeCurrentDateStyle(cell: validCell, cellState: cellState)
        } else {
            dayBelongToCurrentMonthStyle(view: view, cell: validCell, cellState: cellState)
        }
        
    }
    
    /// Style for day not belonging to current month
    func dayNotBelongingThisMonthStyle(cell: CustomDayCell, cellState: CellState) {
        //validCell.dateLabel.text = ""
        // For showing pre and post month days
        //            validCell.isUserInteractionEnabled = false
        //            validCell.selectedView.isHidden = true
        
        cell.dateLabel.text = cellState.text
        cell.isUserInteractionEnabled = false
        cell.selectedView.isHidden = true
    }
    
    /// Style for day before  current day
    func dayBeforeCurrentDateStyle(cell: CustomDayCell, cellState: CellState) {
        //            validCell.dateLabel.text = "-"
        //            validCell.isUserInteractionEnabled = false
        //            validCell.selectedView.isHidden = true
        
        cell.dateLabel.text = cellState.text
        cell.isUserInteractionEnabled = false
        cell.selectedView.isHidden = true
    }
    
    /// Style for day belong to current month style
    func dayBelongToCurrentMonthStyle(view: JTACDayCell?, cell: CustomDayCell, cellState: CellState) {
        cell.isUserInteractionEnabled = true
        if cellState.isSelected {
            view?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(
                withDuration: 0.5,
                delay: 0, usingSpringWithDamping: 0.3,
                initialSpringVelocity: 0.1,
                options: UIView.AnimationOptions.beginFromCurrentState,
                animations: {
                    view?.transform = CGAffineTransform(scaleX: 1, y: 1)
            },
                completion: { _ in
            })
            
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
        cell.dateLabel.text = cellState.text
    }
    
    
    // MARK: - Actions
       @IBAction func cancelClicked(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
       }
       
       @IBAction func doneClicked(_ sender: Any) {
           
           self.delegate?.selectedDate(date: selectedDate.text!, selected: self.selected)
           self.dismiss(animated: true, completion: nil)
           
       }
}

extension CalendarViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
            formatter.dateFormat = "yyyy MM dd"
            formatter.timeZone = Calendar.current.timeZone
            formatter.locale = Calendar.current.locale
            
            let startDate = Date()
            let endDate = formatter.date(from: "2050 12 31")
            
    //        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate!)
            
            let parameters = ConfigurationParameters(startDate: startDate,
            endDate: endDate!,
            numberOfRows: numberOfCalendarRows,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfRow,
            firstDayOfWeek: .sunday)
            return parameters
        }
        
        
        func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
            handleCellSelected(view: cell, cellState: cellState, date: date)
            handleCellTextColor(view: cell, cellState: cellState)
        }
    // Display Cell
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomDayCell", for: indexPath) as! CustomDayCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
         handleCellSelected(view: cell, cellState: cellState, date: date)
               handleCellTextColor(view: cell, cellState: cellState)
               setDate(date: date)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellSelected(view: cell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
//    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState) {
//        handleCellSelected(view: cell, cellState: cellState, date: date)
//        handleCellTextColor(view: cell, cellState: cellState)
//        setDate(date: date)
//    }
//
//    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState) {
//
//        handleCellSelected(view: cell, cellState: cellState, date: date)
//        handleCellTextColor(view: cell, cellState: cellState)
//    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
}
