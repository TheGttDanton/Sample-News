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
                self?.parseResponse(data: data)
            } else {
                if self?.currentPage == 0 {
                    self?.getOfflineData()
                }
            }

        }
    }
    
    func getPaginatedData() {
        if currentPage * perPage >= totalNews || totalNews == 0{
            return
        }
        getData()
    }
    
    func saveForOffline(data : NewsData?) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "NewsData")
        }
    }
    
    func getOfflineData() {
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "NewsData") as? Data {
            let decoder = JSONDecoder()
            if let articles = try? decoder.decode(NewsData.self, from: data) {
                self.newsData = articles.articles ?? []
            }
        }
    }
    
    func parseResponse(data : NewsData?) {
        if currentPage == 0 {
            saveForOffline(data: data)
        }
        if let newsArticles = data?.articles {
            self.currentPage == 0 ? (self.newsData = newsArticles) : (self.newsData.append(contentsOf: newsArticles))
        }
        self.totalNews = data?.totalResults ?? 0
        self.currentPage = self.currentPage + 1
    }
    
    
    func convertDateString(_ dateString : String?) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
        if let date = dateFormatter.date(from: dateString ?? "") {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
}
