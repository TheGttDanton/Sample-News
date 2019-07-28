//
//  NewsViewModel.swift
//  Sample News
//
//  Created by Emtiyaj Ali on 27/07/19.
//  Copyright © 2019 Emtiyaj Ali. All rights reserved.
//

import Foundation
// MARK: - Welcome
class NewsViewModel {
    var newsData : [Article] = [] {
        didSet {
            tableReloadClosure?()
        }
    }
    private var currentPage = 0
    private var totalNews = 0
    private var perPage = 20
    private let requestGenerator = RequestGenerator()
    
    var tableReloadClosure : (() -> ())?
    
    func getData() {
        requestGenerator.getNewsData(currentPage: currentPage) {[weak self] (success, data) in
            if success {
                if let newsArticles = data?.articles {
                    self?.currentPage == 0 ? (self?.newsData = newsArticles) : (self?.newsData.append(contentsOf: newsArticles))
                }
                self?.totalNews = data?.totalResults ?? 0
                self?.currentPage = self?.currentPage ?? 0 + 1
            }

        }
    }
}
