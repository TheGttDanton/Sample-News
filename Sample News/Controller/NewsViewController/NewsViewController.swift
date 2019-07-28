//
//  NewsViewController.swift
//  Sample News
//
//  Created by Emtiyaj Ali on 28/07/19.
//  Copyright © 2019 Emtiyaj Ali. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = NewsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpViewModel()
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0)
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: NewsTableViewCell.identifier, bundle: .main), forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setUpViewModel() {
        viewModel.tableReloadClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.getData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension NewsViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as? NewsTableViewCell else {
            fatalError("Not able to load cell")
        }
        let article = viewModel.newsData[indexPath.row]
        if let imageUrl = article.urlToImage {
            ImageDownloader.handler.addTask(imageUrlString: imageUrl) { (image, imageUrlString) in
                DispatchQueue.main.async {
                    if imageUrl == imageUrlString {
                        cell.newsImage.image = image
                    }
                }
            }
        }
        cell.titleLabel.text = article.title
        cell.sourceLabel.text = article.source?.name
        cell.dateLabel.text = viewModel.convertDateString(article.publishedAt)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.newsData.count - 1 {
            viewModel.getPaginatedData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
