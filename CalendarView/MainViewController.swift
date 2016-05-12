//
//  MainViewController.swift
//  CalendarView
//
//  Created by Joseph Lin on 5/11/16.
//  Copyright © 2016 Joseph Lin. All rights reserved.
//

import UIKit


class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let controller = segue.destinationViewController as! CalendarViewController

        if segue.identifier == "ShowWeek" {
            controller.mode = .Week
        }
        else if segue.identifier == "ShowDay" {
            controller.mode = .Day
        }
    }
}

