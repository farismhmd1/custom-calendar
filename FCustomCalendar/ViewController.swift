//
//  ViewController.swift
//  FCustomCalendar
//
//  Created by Faris on 8/1/20.
//  Copyright © 2020 faris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var calendarContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var calendarViewController: CalendarViewController?
    let calendarContainerViewWeeklyHeight: CGFloat = 170
    let calendarContainerViewMonthlyHeight: CGFloat = 300
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.switchCalendar()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CalendarViewController {
            vc.delegate = self
            // Setup calendar style externaly
            vc.outsideMonthColor = .black
            vc.monthColor = .white
            vc.selectedMonthColor = .black
            vc.selectedDateViewColor = .red
            vc.selectedDateTextColor = .white
            calendarViewController = vc
        }
    }

    // MARK: - Methods
    
    // MARK: - Actions
    @IBAction func didTapSegmentedControll(_ sender: UISegmentedControl) {
        
        UIView.animate(withDuration: 0.25) {
            self.switchCalendar()
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    /// Switch calendar monthly and weekly
    func switchCalendar() {
        if segmentedControl.selectedSegmentIndex == 0 {
            // weekly calendar
            self.calendarContainerViewHeightConstraint.constant = self.calendarContainerViewWeeklyHeight
            
            self.calendarViewController?.switchCalendar(to: .weekly)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            // monthly calendar
            self.calendarContainerViewHeightConstraint.constant = self.calendarContainerViewMonthlyHeight
            self.calendarViewController?.switchCalendar(to: .monthly)
        }
    }
}

// MARK: - Extensions
// MARK: - Calendar Delegates
extension ViewController: CalendarViewControllerDelegate {
    func selectedDate(date: String, selected: Date) {
        print("selected Date \(date) \(selected)")
    }
    
    func selectedMonthFirstDate(date: String, firstDate: Date) {
        print("selected Month \(date) \(firstDate)")
    }
}

