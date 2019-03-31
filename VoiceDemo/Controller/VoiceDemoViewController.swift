//
//  ViewController.swift
//  VoiceDemo
//
//  Created by Yura on 2019/3/12.
//  Copyright © 2019 St4rg4z3r. All rights reserved.
//

import UIKit

class VoiceDemoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

