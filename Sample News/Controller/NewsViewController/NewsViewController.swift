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
    let transition = PopAnimator()
    let viewModel = NewsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpViewModel()
        setNavigationTitle()
        setUpAnimation()
    }
    func setUpAnimation() {
        transition.dismissCompletion = { [weak self] in
            guard
                let selectedIndexPathCell = self?.tableView.indexPathForSelectedRow,
                let selectedCell = self?.tableView.cellForRow(at: selectedIndexPathCell)
                    as? NewsTableViewCell
                else {
                    return
            }
            selectedCell.newsImage.isHidden = false
        }
    }
    func setNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "HEADLINE"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.barTintColor = UIColor.black
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailController = storyBoard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        let article = viewModel.newsData[indexPath.row]
        detailController.newsTitle = article.title
        detailController.source = article.source?.name
        detailController.date = viewModel.convertDateString(article.publishedAt)
        detailController.content = article.content
        if let imageUrl = article.urlToImage {
            ImageDownloader.handler.addTask(imageUrlString: imageUrl) { (image, imageUrlString) in
                DispatchQueue.main.async {
                    if imageUrl == imageUrlString {
                        detailController.image = image
                    }
                }
            }
        }
        detailController.transitioningDelegate = self
        self.present(detailController, animated: true, completion: nil)
    }
}
extension NewsViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            guard
                let selectedIndexPathCell = tableView.indexPathForSelectedRow,
                let selectedCell = tableView.cellForRow(at: selectedIndexPathCell)
                    as? NewsTableViewCell,
                let selectedCellSuperview = selectedCell.superview
                else {
                    return nil
            }
            transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
            transition.originFrame = CGRect(
                x: transition.originFrame.origin.x + 20,
                y: transition.originFrame.origin.y + 20,
                width: transition.originFrame.size.width - 40,
                height: transition.originFrame.size.height - 40
            )

            transition.presenting = true
            selectedCell.newsImage.isHidden = true
            return transition
    }
    
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            transition.presenting = false
            return transition
            
    }
}
