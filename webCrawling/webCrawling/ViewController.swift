//
//  ViewController.swift
//  webCrawling
//
//  Created by Baem on 10/19/23.
//

import UIKit

class ViewController: UIViewController {
    
    var yagomDatas = [YagomData(name: "Yagom", position: "대장")]
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBrown
        mainTableView.backgroundColor = .clear
        
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        mainTableView.register(nibName, forCellReuseIdentifier: "CustomCell")
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        let network = NetWork()
        network.getHTML { result in
            switch result {
            case .success(let datas):
                self.yagomDatas = datas
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                    self.imageSetting()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func imageSetting() {
        for (index, value) in yagomDatas.enumerated() {
            NetWork.getImage(value.imageLink!) { result in
                switch result {
                case .success(let image):
                    self.yagomDatas[index].image = image
                    DispatchQueue.main.async {
                        self.mainTableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
