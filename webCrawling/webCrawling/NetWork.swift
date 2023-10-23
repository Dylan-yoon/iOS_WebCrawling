//
//  NetWork.swift
//  webCrawling
//
//  Created by Dylan_Y on 2023/10/23.
//

import Foundation

class NetWork {
    
    static func getHTML(comletion: @escaping (Result<[YagomData], NetWorkError>) -> Void) {
        
        let url = URL(string: "https://www.yagom-academy.kr/about")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                print("URLSession ERRRO : ", error!)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                
                return
            }
            print("URLSession Response Status Code", response.statusCode)
            
            // Data
            // print(String(data: data, encoding: .utf8)!)
            
        }
        
        dataTask.resume()
    }
}

enum NetWorkError: Error {
    case networkError
}
