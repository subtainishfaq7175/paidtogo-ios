//
//  WebViewViewController.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 07/08/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: MenuContentViewController {

//    var webView : WKWebView?
    public var url :String?
    public var controllerTitle :String?
    public var hasNavBar = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = controllerTitle
        initLayout()
    
        webView = WKWebView()

        webView?.navigationDelegate = self
       
        view = webView
        
        if hasNavBar {
            addDoneBarButton()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let nsurl = URL(string: url!)
        let request = URLRequest(url: nsurl!)
        webView?.load(request)
      
        showProgressHud()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLayout() {
//        setNavigationBarVisible(visible: true)
        customizeNavigationBarWithMenu()
    }
    
    func addDoneBarButton() {
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(WebViewViewController.done));
        self.navigationItem.leftBarButtonItem = done
    }
    
    @objc func done() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        dismissProgressHud()
    }
}
