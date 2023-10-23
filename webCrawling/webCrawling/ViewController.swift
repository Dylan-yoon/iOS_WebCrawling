//
//  ViewController.swift
//  webCrawling
//
//  Created by Baem on 10/19/23.
//

import UIKit

class ViewController: UIViewController {
    
    // 기본 셀
    var yagomDatas = [YagomData(name: "Yagom", position: "대장", image: UIImage(named: "yagomlogo")!)]
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBrown
        mainTableView.backgroundColor = .clear
        
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        mainTableView.register(nibName, forCellReuseIdentifier: "CustomCell")
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        NetWork.getHTML { result in
            switch result {
            case .success(let datas):
                self.yagomDatas = datas
                self.mainTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yagomDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? TableViewCell else { return UITableViewCell() }
        
        let data = yagomDatas[indexPath.row]
        
        cell.nameLabel.text = data.name
        cell.positionLabel.text = data.position
        cell.photoImageView.image = data.image
        
        return cell
    }
}
