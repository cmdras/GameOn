//
//  SearchGamesViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 12/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit

class SearchGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var searchGamesTable: UITableView!
    
    var games = ["game1", "game2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchGamesTable.dequeueReusableCell(withIdentifier: "searchedGamesCell", for: indexPath)
            as! SearchGameCell
        cell.searchGameTitle.text = games[indexPath.row]
        return cell
    }

    
    
}
