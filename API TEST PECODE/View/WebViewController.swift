//
//  WebViewController.swift
//  API TEST PECODE
//
//  Created by alekseienko on 15.10.2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - PROPERTIES
    var urlString: String?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: urlString ?? "") else {return}
        webView.load(URLRequest(url:url))
        webView.allowsBackForwardNavigationGestures = true
    }
}


