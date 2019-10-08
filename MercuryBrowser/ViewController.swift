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
    var itemList = MercuryList(mercuryItemsList: [])
    
    struct MercuryList: Codable {
        let mercuryItemsList: [MercuryItem]
    }
    
    func parseFromUrl (urlString: String) {
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            let temporaryItemList = try! JSONDecoder().decode (MercuryList.self, from: data!)
            self.itemList = temporaryItemList
            
        }
        
        task.resume()
    }
    
    
    
    
    override func viewDidLoad() {
        tableView.dataSource = self
        super.viewDidLoad()
        parseFromUrl(urlString: self.urlString)
        // Do any additional setup after loading the view.
    }
    
}



extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.mercuryItemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = itemList.mercuryItemsList[indexPath.item].name
        print(name + ";;")
        let cell = tableView.dequeueReusableCell(withIdentifier: "MercuryCell")!
        if let mercuryCell = cell as? MercuryCell {
            mercuryCell.mercuryLabel.text = "\(name)"
        }
        return cell
    }
    
    
}
 

