//
//  GameVideosVC.swift
//  GameOn
//
//  Created by Christopher Ras on 24/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
// This View shows the users a list of videos on Youtube of a specific game in a . The user can then continue to watch the videos in the web

import UIKit

class GameVideosVC: UIViewController, UIWebViewDelegate {
    // MARK: - Properties
    var game: Game?
    var gameTitle: String?
    
    // MARK: - Outlets
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        makeSearchQuery(game: game!)
    }
    
    // MARK: - Helper Functions
    func makeSearchQuery(game: Game) {
        let searchTitle = game.title!.replacingOccurrences(of: " ", with: "+")
        if let url = URL(string: "https://m.youtube.com/results?q=\(searchTitle)") {
            print(url)
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

}
