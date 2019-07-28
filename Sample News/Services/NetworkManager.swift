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
    
    func getData<T : Codable>(urlToHit : String , completionHandler : @escaping (Bool , T?) -> ()) {
        guard let url = URL(string: urlToHit) else {
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            print(data , response , error)
            if let _ = error  {
                print("Error is \(error)")
                completionHandler(false,nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(T.self, from: data!)
                completionHandler(true,json)
            } catch {
                print("Failed to load: \(error)")
                completionHandler(false,nil)
            }
        }
        dataTask.resume()
    }
}
