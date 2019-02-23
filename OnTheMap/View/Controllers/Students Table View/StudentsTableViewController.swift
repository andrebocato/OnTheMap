//
//  PeopleTableViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit

class StudentsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var studentsArray = [Student]()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        // @TODO: populate the cells with students data retrieved from udacity
        return configureCell(cell, indexPath)
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentsArray[indexPath.row]
//        if let studentUrl = URL(string: student.mediaURL) {
//            UIApplication.shared.open(studentUrl, options: [:], completionHandler: nil)   // to be tested with real data
//        }
    }
    
    // MARK: - Helper Functions
    
    func configureCell(_ cell: UITableViewCell,_ indexPath: IndexPath) -> UITableViewCell {
        if studentsArray.count > 0 {
            let student = studentsArray[indexPath.row]
            cell.textLabel?.numberOfLines = 2
//            cell.textLabel?.attributedText = FunctionsHelper.setUpAttributedText(student: student)
//            cell.imageView?.image = image
        }
        return cell
    }

}
