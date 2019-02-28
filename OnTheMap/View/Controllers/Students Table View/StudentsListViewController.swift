//
//  PeopleTableViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit

class StudentsListViewController: UIViewController, DataRefreshable {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    // MARK: - Properties
    
    private var students: [Student]? {
        didSet {
            studentsTableView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchStudents()
    
    }

    // MARK: - Helper Functions
    
    // repeated code
    private func displayError(_ error: Error,
                              description: String? = nil) {
        
        if let description = description {
            print(description + "\nError:\n\(error)")
        } else {
            print("An unknown error occurred. Error:\n\(error)")
        }
    }
    
    // repeated code
    private func fetchStudents() {
        
        // GET request for students
        ParseClient.getStudentsRequest(limit: 100, skip: 100, order: "-updatedAt", success: { (getStudentsResponse) in
            if let studentsArrayFromResponse = getStudentsResponse?.results {
                self.students = studentsArrayFromResponse
            }
        }) { (optionalError) in
            if let error = optionalError {
                self.displayError(error, description: "Failed to GET students.")
            }
        } // end of GET students request
        
    }
    
    func refreshData() {
        fetchStudents()
    }
    
}

 // MARK: - Extensions

extension StudentsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let students = students {
            guard students.count > 0 else { return 0 }
            return students.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        return configureCell(cell, indexPath)
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let student = students?[indexPath.row] {
            if let studentURL = URL(string: student.mediaURL) {
                UIApplication.shared.open(studentURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func configureCell(_ cell: UITableViewCell,_ indexPath: IndexPath) -> UITableViewCell {
        if let students = students {
            if students.count > 0 {
                let student = students[indexPath.row]
                cell.textLabel?.numberOfLines = 2
                cell.textLabel?.text = student.firstName + student.lastName + "\n" + student.mediaURL
//                cell.imageView?.image = (udacity pin image goes here)
            }
        }
        return cell
    }
    
    // @TODO: create emptyView (https://medium.com/@mtssonmez/handle-empty-tableview-in-swift-4-ios-11-23635d108409)
    
}
