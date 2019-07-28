//
//  NewsTableViewCell.swift
//  Sample News
//
//  Created by Emtiyaj Ali on 28/07/19.
//  Copyright © 2019 Emtiyaj Ali. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
