//
//  RequestGenerator.swift
//  Sample News
//
//  Created by Emtiyaj Ali on 28/07/19.
//  Copyright © 2019 Emtiyaj Ali. All rights reserved.
//

import Foundation
////let url = URL(string: "https://newsapi.org/v2/top-headlines?country=in&apiKey=65b5575751174db590bf9484d621ba8f")!
struct RequestGenerator {
    private let apiKey = "&apiKey=65b5575751174db590bf9484d621ba8f"
    private let url = "https://newsapi.org/v2/top-headlines?country=in"
    
    func getNewsData(currentPage : Int, completionHandler : @escaping (Bool ,NewsData?) -> () ) {
        let urlTohit = url + apiKey + "&page=\(currentPage)"
        NetworkManager.shared.getData(urlToHit: urlTohit, completionHandler: completionHandler)
    }
}
