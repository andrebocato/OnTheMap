//
//  PeopleTableViewCell.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {

    func configureWithStudent(_ student: Student?) {
        guard let student = student else { return }
        textLabel?.numberOfLines = 2
        textLabel?.text = student.firstName + student.lastName + "\n" + student.mediaURL
    }

}
