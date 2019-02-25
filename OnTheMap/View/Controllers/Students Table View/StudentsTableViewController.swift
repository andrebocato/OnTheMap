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
    
    var students = CurrentSessionData.shared.students
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // @TODO: GET request for students
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let students = students else { return 1 }
        if students.count > 0 {
            return students.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        // @TODO: populate the cells with students data retrieved from udacity
        
        
        return configureCell(cell, indexPath)
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let student = students?[indexPath.row] {
            if let studentURL = URL(string: student.mediaURL) {
                UIApplication.shared.open(studentURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func configureCell(_ cell: UITableViewCell,_ indexPath: IndexPath) -> UITableViewCell {
        if let students = students {
            if students.count > 0 {
                let student = students[indexPath.row]
                cell.textLabel?.numberOfLines = 2
                cell.textLabel?.text = student.firstName + student.lastName + "\n" + student.mediaURL
    //            cell.imageView?.image = (udacity pin image goes here)
            }
        }
        return cell
    }
    
    // @TODO: create emptyView (https://medium.com/@mtssonmez/handle-empty-tableview-in-swift-4-ios-11-23635d108409)
    
}
