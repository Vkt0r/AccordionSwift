//
//  CountryTableViewCell.swift
//  Example
//
//  Created by Victor Sigler Lopez on 7/6/18.
//  Copyright © 2018 Victor Sigler. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var contryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
