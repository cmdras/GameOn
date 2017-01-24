//
//  GameVideosVC.swift
//  GameOn
//
//  Created by Christopher Ras on 24/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit

class GameVideosVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var game: Game?
    var gameTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        makeSearchQuery(game: game!)
    }
    
    func makeSearchQuery(game: Game) {
        let searchTitle = game.title!.replacingOccurrences(of: " ", with: "+")
        if let url = URL(string: "https://m.youtube.com/results?q=\(searchTitle)") {
            print(url)
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

}
