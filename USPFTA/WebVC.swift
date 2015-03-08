//
//  WebVC.swift
//  USPFTA
//
//  Created by Mollie on 3/8/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class WebVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
        webView.scalesPageToFit = true
        
    }

}
