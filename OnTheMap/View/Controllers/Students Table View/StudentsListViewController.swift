//
//  PeopleTableViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit

class StudentsListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var studentsTableView: UITableView!
    
    // MARK: - Properties
    
    private var downloadedStudents: [Student]? {
        guard let students = StudentsDataManager.shared.students else { return [] }
        return students
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStudents()
    }

    // MARK: - Helper Functions
    
    private func logError(_ error: Error,
                              description: String? = nil) {
        
        if let description = description {
            print(description + "\nError:\n\(error)")
        } else {
            print("An unknown error occurred. Error:\n\(error)")
        }
    }
    
    private func fetchStudents() {
        
        // GET request for students
        ParseClient.getStudentsRequest(limit: 100, skip: 100, order: "-updatedAt", success: { [weak self] (getStudentsResponse) in
            guard let students = getStudentsResponse?.results else { return }
            StudentsDataManager.shared.save(studentsArray: students)
            self?.studentsTableView.reloadData()
        }, failure: { [weak self] (optionalError) in
                guard let self = self,
                    let error = optionalError else { return }
            
            Alerthelper.showErrorAlert(inController: self, withMessage: "Failed to download students data.")
                self.logError(error, description: "Failed to GET students.")
        }) // end of GET students request
        
    }
    
}

 // MARK: - Extensions

extension StudentsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedStudents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as? StudentCell else { return UITableViewCell() }
        cell.configureWithStudent(downloadedStudents?[indexPath.row])
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let student = downloadedStudents?[indexPath.row], let studentURL = URL(string: student.mediaURL ?? "") else { return }
        UIApplication.shared.open(studentURL, options: [:], completionHandler: nil)
    }
    
    
    
}
extension StudentsListViewController: DataRefreshable {
    
    func refreshData() {
        guard let students = downloadedStudents, !students.isEmpty else {
            fetchStudents()
            return
        }
        
        studentsTableView.reloadData()
    }
    
}
