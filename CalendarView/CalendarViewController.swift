//
//  CalendarViewController.swift
//  CalendarView
//
//  Created by Joseph Lin on 5/11/16.
//  Copyright © 2016 Joseph Lin. All rights reserved.
//

import UIKit

enum CalendarMode {
    case Week
    case Day
}

class CalendarViewController: UIViewController {
    
    @IBOutlet var gridView: GridView!
    
    lazy var hours: [String] = {
        
        var hours = ["12 AM"]
        for h in 1...11 {
            hours.append(String(h) + " AM")
        }
        hours.append("12 PM")
        for h in 1...11 {
            hours.append(String(h) + " PM")
        }
        hours.append("12 AM")
        
        return hours
    }()
    
    var mode = CalendarMode.Week
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gridView.layout.edgeInsets = UIEdgeInsets(top: 40, left: 60, bottom: 20, right: 20)
        self.updateMode()
    }
    
    func updateMode() {
        
        switch mode {
        case .Week:
            let columns: [String?] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            self.gridView.columnLabels  = columns
            self.gridView.layout.numberOfColumns = columns.count
            
            
            var rows = [String?]()
            for (index, h) in self.hours.enumerate() {
                rows.append(h)
                if index != self.hours.count - 1 {
                    rows.append(nil)
                }
            }
            gridView.rowLabels = rows
            gridView.layout.numberOfRows = rows.count - 1

        case .Day:
            self.gridView.columnLabels  = nil
            self.gridView.layout.numberOfColumns = 1
            
            
            var rows = [String?]()
            for (index, h) in self.hours.enumerate() {
                rows.append(h)
                if index != self.hours.count - 1 {
                    rows.append(nil)
                    rows.append(nil)
                }
            }
            gridView.rowLabels = rows
            gridView.layout.numberOfRows = rows.count - 1
        }
    }
}
