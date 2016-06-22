//
//  ListTableViewCell.swift
//  OnTheMap
//
//  Created by Layne Faler on 6/20/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableCellImage: UIImageView!
    @IBOutlet weak var tableTopLabelName: UILabel!
    @IBOutlet weak var tableBottomLabelLink: UILabel!
    
    // Configure UI
    
    func configureWithStudentLocation(studentLocation: StudentLocation) {
        tableCellImage.image = UIImage(named: "Pin")
        tableTopLabelName.text = studentLocation.student.fullName
        tableBottomLabelLink.text = studentLocation.student.mediaURL
    }
}