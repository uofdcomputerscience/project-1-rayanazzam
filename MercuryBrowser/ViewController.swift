//
//  ViewController.swift
//  MercuryBrowser
//
//  Created by Russell Mirabelli on 9/29/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let urlString = "https://raw.githubusercontent.com/rmirabelli/mercuryserver/master/mercury.json"
    var itemList = MercuryList(mercury: [])
    
    struct MercuryList: Codable {
        let mercury: [MercuryItem]
    }
    
    func parseFromUrl (urlString: String) {
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            let temporaryItemList = try! JSONDecoder().decode (MercuryList.self, from: data!)
            self.itemList = temporaryItemList
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        task.resume()
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        super.viewDidLoad()
        parseFromUrl(urlString: self.urlString)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.mercury.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = itemList.mercury[indexPath.item].name
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "MercuryCell")!
        
        if let mercuryCell = cell as? MercuryCell {
            mercuryCell.mercuryLabel.text = "\(name)"
            postImage(mercuryCell: mercuryCell,
                      urlString: itemList.mercury[indexPath.item].url)
        }
        return cell
    }
    
    func postImage(mercuryCell: MercuryCell, urlString: String) -> Void {
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: URL(string: urlString)!) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        mercuryCell.mercuryImage.image = image
                    }
                }
            }
            task.resume()
    }
}
 


