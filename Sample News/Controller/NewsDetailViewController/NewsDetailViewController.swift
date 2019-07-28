//
//  NewsDetailViewController.swift
//  Sample News
//
//  Created by Emtiyaj Ali on 28/07/19.
//  Copyright © 2019 Emtiyaj Ali. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController {
    var newsTitle : String?
    var source : String?
    var date : String?
    var image : UIImage? {
        didSet {
            self.newsImageView.image = image
        }
    }
    var content : String?
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    func setUpUI() {
        sourceLabel.text = source
        titleLabel.text = newsTitle
        dateLabel.text = date
        contentTextView.text = content
    }
    
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
