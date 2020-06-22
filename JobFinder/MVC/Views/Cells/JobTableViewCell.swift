//
//  JobTableViewCell.swift
//  JobFinder
//
//  Created by Suliman Mishael on 22/06/2020.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit
import SDWebImage

class JobTableViewCell: UITableViewCell {

    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var jobTitleLb: UILabel!
    @IBOutlet weak var companyNameLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    @IBOutlet weak var creationDateLb: UILabel!
    private let defaultLogo = #imageLiteral(resourceName: "ic_company_placeholder")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        // Initialization code
    }

    func setup(model: JobModel) {
        if let logoUrl = model.companyLogo, let url = URL(string: logoUrl) {
            companyLogo.sd_setImage(with: url, placeholderImage: defaultLogo, options: .scaleDownLargeImages, context: nil)
        } else {
            companyLogo.image = defaultLogo
        }
        
        jobTitleLb.text = "Job Title: " + model.jobTitle
        companyNameLb.text = "Company: " + model.company
        locationLb.text = "Location: " + model.location
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        creationDateLb.text = "Created At: " + formatter.string(from: model.creationDate)
        
    }
}
