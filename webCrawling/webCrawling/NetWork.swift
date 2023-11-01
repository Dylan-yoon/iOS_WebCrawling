//
//  NetWork.swift
//  webCrawling
//
//  Created by Dylan_Y on 2023/10/23.
//

import Foundation
import SwiftSoup
import UIKit

class NetWork {
    
    func getHTML(completion: @escaping (Result<[YagomData], NetWorkError>) -> Void) {
        
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
            let html = String(data: data, encoding: .utf8)!
            
            completion(.success(self.webCrawlingData(html)))
        }
        
        dataTask.resume()
    }
    
    private func webCrawlingData(_ html: String) -> [YagomData] {
        var yagomDatas = [YagomData]()
        
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let firstDivergingPoint: Elements = try doc.select("div.css-1r6553s")
            let secondDivergingPoint: Elements = try firstDivergingPoint.select("div.css-lwlrzb")
            
            //MARK: Name 가져오기
            let nameElements: Elements = try secondDivergingPoint.select("div > h4 > span")
            
            for (index, nameElement) in nameElements.enumerated() {
                print(index, terminator: " ")
                print(try nameElement.text())
                yagomDatas.append(YagomData(name: try nameElement.text(), position: ""))
            }
            
            //MARK: Position 가져오기
//            let positionElements: Elements = try secondDivergingPoint.select("div > span") 더 다양한 데이터들이 들어옴
            
            let positionElements: Elements = try secondDivergingPoint.select("div.css-gbfsct").select("div > span")
            var positionData = [String]()
            for (index, positionElement) in positionElements.enumerated() {
                print(index, terminator: " ")
                positionData.append(try positionElement.text())
                print(try positionElement.text())
            }
            
            // 불필요한 데이터 삭제 -> [5, 7, 9, 16, 17, 34, 35, 43]
            for i in [5, 7, 9, 16, 17, 34, 35, 43].reversed() {
                positionData.remove(at: i)
            }
            
            // yagomDatas에 추가
            for (index, value) in positionData.enumerated() {
                yagomDatas[index].position = value
            }
            
            //MARK: ImageLink 가져오기
            let imageElements: Elements = try firstDivergingPoint.select("div.css-1ts4rwa > div > div > div > div > div > div > div").select("img")
            for (index, elementValue) in imageElements.enumerated() {
                print(index, terminator: " ")
                print(try elementValue.attr("src".description))
                yagomDatas[index].imageLink = try elementValue.attr("src".description)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return yagomDatas
    }
    
    static func getImage(_ url: String, completion: @escaping (Result<UIImage, NetWorkError>) -> Void) {
        
        let url = URL(string: url)
        
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
            let image = UIImage(data: data)!
            
            completion(.success(image))
        }
        
        dataTask.resume()
    }
}

enum NetWorkError: Error {
    case networkError
}
