//
//  DetailVC.swift
//  WhiteHousePetition
//
//  Created by Olibo moni on 09/02/2022.
//

import UIKit
import WebKit

class DetailVC: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        <p>\(detailItem.signatureCount) </p>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
       
    }
    


}
