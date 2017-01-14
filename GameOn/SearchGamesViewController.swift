//
//  SearchGamesViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 12/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var searchGamesTable: UITableView!
    
    @IBOutlet weak var searchField: UITextField!
    
    let headers: HTTPHeaders = [
        "X-Mashape-Key": "ScI6t1sfIcmshy2tuxkm47C7jsQkp1iyIg1jsns01j23R4XUJ1",
        "Accept": "application/json"
    ]
    
    var gameTitles = Array<String>()
    var gameDates = Array<String>()
    var gameImages = Array<String>()
    var searchResults = Array<Game>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchGamesTable.dequeueReusableCell(withIdentifier: "searchedGamesCell", for: indexPath)
            as! SearchGameCell
        
        cell.searchGameTitle.text = gameTitles[indexPath.row]
       
        cell.searchGameRelease.text = gameDates[indexPath.row]
        
        if (gameImages[indexPath.row] != "") {
            let url = URL(string: gameImages[indexPath.row])
            cell.searchGameImage.af_setImage(withURL: url!)
        } else {
            cell.searchGameImage.image = #imageLiteral(resourceName: "stock")
        }
        
        return cell
    }

    @IBAction func searchButtonTouched(_ sender: Any) {
        if ((self.searchField.text?.characters.count)! < 3) {
            let alertController = UIAlertController(title: "Oops", message: "Please enter at least 3 characters", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            dataRequest(searchTerm: self.searchField.text!)
        }
    }
    
    func dataRequest (searchTerm: String) -> Void {
        Alamofire.request("https://igdbcom-internet-game-database-v1.p.mashape.com/games/?search=\(searchTerm)&fields=*", headers: headers)
            .responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let json = responseData.result.value as! NSArray
                    for i in stride(from: 0, to: 10, by: 1) {
                        let currentGame = Game()
                        let gameData = json[i] as! NSDictionary
                        if (gameData["cover"] != nil) {
                            let coverData = gameData["cover"] as! NSDictionary
                            self.gameImages.append("https:\(coverData["url"]!)")
                            //currentGame.coverUrl = "https:\(coverData["url"])"
                        } else {
                            self.gameDates.append("")
                        }
                        if (gameData["name"] != nil) {
                            //currentGame.title = gameData["name"] as? String
                            self.gameTitles.append((gameData["name"] as? String)!)
                        }
                        if (gameData["release_dates"] != nil) {
                            let releaseDateArray = gameData["release_dates"] as! NSArray
                            let firstDateData = releaseDateArray[0] as! NSDictionary
                            let releaseDate = firstDateData["human"] as! String
                            self.gameDates.append(releaseDate)
                            //currentGame.releaseDate = releaseDate
                        }
                        
                        //self.searchResults.append(currentGame)
                    }
                    self.searchGamesTable.reloadData()
                }
        }
        
    }
    
}
