//
//  SearchGamesViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 12/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//  
//  Keyboard hiding code adapted from: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
//  Image download code adapted from: https://www.youtube.com/watch?v=1m-VLnoixz8

import UIKit
import Alamofire
import AlamofireImage
import Firebase

class SearchGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    let headers: HTTPHeaders = [
        "X-Mashape-Key": "ScI6t1sfIcmshy2tuxkm47C7jsQkp1iyIg1jsns01j23R4XUJ1",
        "Accept": "application/json"
    ]
    var gameTitles = Array<String>()
    var gameDates = Array<String>()
    var gameImages = Array<String>()
    var searchResults = Array<Game>()
    var selectedGame: Game?
    
    // MARK: - Outlets
    @IBOutlet weak var searchGamesTable: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Games" 
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchGamesViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false 
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Helper Functions
    /// Retrieve data from IGDB API
    func dataRequest (searchTerm: String) -> Void {
        let noSpaceUrl = searchTerm.replacingOccurrences(of: " ", with: "+")
        Alamofire.request("https://igdbcom-internet-game-database-v1.p.mashape.com/games/?search=\(noSpaceUrl)&fields=*", headers: headers)
            .responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let json = responseData.result.value as! NSArray
                    for i in stride(from: 0, to: json.count, by: 1) {
                        let game = Game()
                        let gameData = json[i] as! NSDictionary
                        
                        if let nameKey = gameData["name"] {
                            game.title = nameKey as? String
                        } else {
                            // If no name is found, skip this game
                            // To prevent empty cells
                            continue
                        }
                        if  let coverKey = gameData["cover"] {
                            let coverData = coverKey as! NSDictionary
                            game.coverUrl = "https:\(coverData["url"]!)"
                        } else {
                            game.coverUrl = ""
                        }
                        
                        if let dateKey = gameData["release_dates"] {
                            let releaseDateArray = dateKey as! NSArray
                            let firstDateData = releaseDateArray[0] as! NSDictionary
                            let releaseDate = firstDateData["human"] as! String
                            self.gameDates.append(releaseDate)
                            game.releaseDate = releaseDate
                        } else {
                            game.releaseDate = "Release date unknown"
                        }
                        if let summaryKey = gameData["summary"] {
                            game.summary = summaryKey as? String
                        } else {
                            game.summary = "No summary found"
                        }
                        self.searchResults.append(game)
                    }
                    self.searchGamesTable.reloadData()
                } else {
                    self.searchGamesTable.reloadData()
                }
        }
        
    }
    
    // MARK: - Table View Handler
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchGamesTable.dequeueReusableCell(withIdentifier: "searchedGamesCell", for: indexPath)
            as! SearchGameCell
        
        cell.searchGameTitle.text = searchResults[indexPath.row].title!
        cell.searchGameRelease.text = searchResults[indexPath.row].releaseDate!
        if (searchResults[indexPath.row].coverUrl! != "") {
            let url = URL(string: searchResults[indexPath.row].coverUrl!)
            cell.searchGameImage.af_setImage(withURL: url!, placeholderImage: #imageLiteral(resourceName: "stock"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
        } else {
            cell.searchGameImage.image = #imageLiteral(resourceName: "stock")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchGamesTable.deselectRow(at: indexPath, animated: true)
        self.selectedGame = searchResults[indexPath.row]
        self.searchField.text = ""
        performSegue(withIdentifier: "gameSearchInfoSegue", sender: nil)
    }
    
    // MARK: - IBAction functions
    @IBAction func searchButtonTouched(_ sender: Any) {
        if ((self.searchField.text?.characters.count)! < 3) {
            let alertController = UIAlertController(title: "Oops", message: "Please enter at least 3 characters", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.searchResults.removeAll()
            dataRequest(searchTerm: self.searchField.text!)
        }
        
        view.endEditing(true)
    }
    
    // MARK: - Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let infoVC = segue.destination as? GameInfoViewController {
            infoVC.selectedGame = self.selectedGame
        }
    }
    
    
    
}
