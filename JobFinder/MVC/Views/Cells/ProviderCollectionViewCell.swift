//
//  ProviderCollectionViewCell.swift
//  JobFinder
//
//  Created by Suliman Mishael on 22/06/2020.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

class ProviderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLb.layer.cornerRadius = 27
        // Initialization code
    }
    
    func setup(title: String, isSelected: Bool) {
        titleLb.text = title
        if isSelected {
            titleLb.backgroundColor = .systemBlue
            titleLb.textColor = .white
        } else {
            titleLb.backgroundColor = UIColor(white: 0.86, alpha: 1.0)
            titleLb.textColor = .black
        }
    }
}
