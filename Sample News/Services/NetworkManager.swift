//
//  NetworkManager.swift
//  Sample News
//
//  Created by Emtiyaj Ali on 26/07/19.
//  Copyright © 2019 Emtiyaj Ali. All rights reserved.
//

import Foundation
class NetworkManager {
    static let shared = NetworkManager()
    private init() {
    }
    
    private let session : URLSession  = {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfig)
        return session
    }()
    
    func getData<T : Codable>(urlToHit : String , completionHandler : (success : Bool , response : T)) {
        //let url = URL(string: "https://newsapi.org/v2/top-headlines?country=in&apiKey=65b5575751174db590bf9484d621ba8f")!
        guard let url = URL(string: urlToHit) else {
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            print(data , response , error)
            if let _ = error  {
                print("Error is \(error)")
                return
            }
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(T.self, from: data!)
                print(json)
            } catch {
                print("Failed to load: \(error)")
            }
        }
        dataTask.resume()
    }
}
