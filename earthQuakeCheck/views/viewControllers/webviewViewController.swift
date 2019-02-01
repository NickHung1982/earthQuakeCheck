//
//  webviewViewController.swift
//  earthQuakeCheck
//
//  Created by Nick on 1/20/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import UIKit
import WebKit

class webviewViewController: UIViewController {
    var webView: WKWebView!
    var weburl:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //weburl = URL(string: "https://www.google.com")
        webView.load(URLRequest(url: weburl))
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
        
        
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension webviewViewController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
