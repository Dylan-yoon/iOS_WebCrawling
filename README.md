# iOS_WebCrawling



## Swift 에서 사용 할 수 있는 HTML Library
| Library | Installation |
| -- | -- |
| [SwiftSoup](https://github.com/scinfu/SwiftSoup#try-out-the-simple-online-css-selectors-site) | ![Static Badge](https://img.shields.io/badge/CocoaPods-red) ![Static Badge](https://img.shields.io/badge/SPM-blue) ![Static Badge](https://img.shields.io/badge/Carthago-purple) |
| [Kanna](https://github.com/tid-kijyun/Kanna) | ![Static Badge](https://img.shields.io/badge/CocoaPods-red) ![Static Badge](https://img.shields.io/badge/SPM-blue) ![Static Badge](https://img.shields.io/badge/Carthago-purple) |
| [JI](https://github.com/honghaoz/Ji) | ![Static Badge](https://img.shields.io/badge/CocoaPods-red) ![Static Badge](https://img.shields.io/badge/SPM-blue) ![Static Badge](https://img.shields.io/badge/Carthago-purple) |
| [HTMLKit](https://github.com/iabudiab/HTMLKit) | ![Static Badge](https://img.shields.io/badge/CocoaPods-red) ![Static Badge](https://img.shields.io/badge/SPM-blue) ![Static Badge](https://img.shields.io/badge/Carthago-purple) |
| [Fuzi](https://github.com/cezheng/Fuzi) | ![Static Badge](https://img.shields.io/badge/CocoaPods-red) ![Static Badge](https://img.shields.io/badge/SPM-blue) ![Static Badge](https://img.shields.io/badge/Carthago-purple) |
| [Hpple](https://github.com/topfunky/hpple) | - |
| [NDHpple](https://github.com/ndavon/NDHpple) | - |

### HTML의 이해
#### 가이드 라인 
[HTML Guideline](https://developer.mozilla.org/ko/docs/Learn/HTML/Introduction_to_HTML/Getting_started#html_요소element의_구조)<br>
Web에서 가져온 HTML 을 사용하기 위해서 Element가 어떤 것인지, <br>
Attribute가 어떤 것인지 정도만 알면 된다.<br>

<img width="859" alt="HTMLElement" src="https://github.com/Dylan-yoon/iOS_WebCrawling/assets/77507952/e99425ee-6a75-4481-8ecf-f6cc07f23d69"><br>
Element : `여는 Tag` + `Content` + `닫는 Tag` <br>
Tag로 둘러쌓인 내부 : `Content`

<img width="861" alt="AttributeExample" src="https://github.com/Dylan-yoon/iOS_WebCrawling/assets/77507952/958b7357-005f-4910-a573-aafd3c4055ee"><br>
- Tag : `p` 
- Attribute : `class="editor-mode"` 


## SwiftSoup 사용
![](https://raw.githubusercontent.com/scinfu/SwiftSoup/master/swiftsoup.png)

사실 데이터를 가져오는 것은 쉽다.

1. Install SwiftSoup
    - ![Static Badge](https://img.shields.io/badge/SPM-blue) 
    - ![Static Badge](https://img.shields.io/badge/CocoaPods-red)
    - ![Static Badge](https://img.shields.io/badge/Carthago-purple)
1. Import SwiftSoup
1. HTML 가져오기
1. SwiftSoup 에게 Parse 를 맡김
1. 필요한 경로 넣어줌
1. 데이터 가공

### 1. HTML 가져오기 

URLSession을 사용해서 HTML을 가져온다.
```swift
func getHTML() {
        //MARK: 필요한 웹페이지의 URL 붙여넣는다.
        let url = URL(string: "https://URL 붙여넣기")
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
            
            //MARK: HTML 가져옴
            let html = String(data: data, encoding: .utf8)!
        }
        
        dataTask.resume()
    }
```

### 2. Parse HTML
SwiftSoup 사용
```swift
private func getDataUsingSwiftSoup(_ html: String){
        do {
            //MARK: 1. 먼저 document를 만들어야 하는데 SwiftSoup의 parse메서드에 가져온 html을 넣어준다.
            let doc: Document = try SwiftSoup.parse(html)

            //MARK: 2. SwiftSoup로 parse 한 doc를 select메서드를 사용해 경로를 넣어준다.
            let firstElement: Elements = try doc.select("div.css-1r6553s")
            let secondElement: Elements = try firstElement.select("div.css-lwlrzb")
            let nameElements: Elements = try secondElement.select("div > h4 > span")
            
            for (index, nameElement) in nameElements.enumerated() {
                print(index, terminator: " ")
                print(try nameElement.text())
            }
            
            let positionElements: Elements = try secondDivergingPoint.select("div.css-gbfsct").select("div > span")
            var positionData = [String]()
            for (index, positionElement) in positionElements.enumerated() {
                print(index, terminator: " ")
                positionData.append(try positionElement.text())
                print(try positionElement.text())
            }
            
            // 불필요한 데이터가 들어 올 수 있기 때문에 확인해야 한다.
            // 불필요한 데이터 삭제
            for i in [5, 7, 9, 16, 17, 34, 35, 43].reversed() {
                positionData.remove(at: i)
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
    }
```
