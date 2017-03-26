//
//  ViewController.swift
//  Example
//
//  Created by Dario Trisciuoglio on 26/03/17.
//  Copyright © 2017 Floaty s.r.l. (http://www.floaty.it/). All rights reserved.
//

import UIKit
import FloatyActivityIndicatorController

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Initialize the activity indicator view
        let origin = CGPoint(x:40, y:40)
        let size = CGSize(width:40, height:40)
        let frame = CGRect(origin:origin, size:size)
        let activityIndicatorView = ActivityIndicatorView(frame: frame)
        
        // Set the line width of the activity indicator view
        activityIndicatorView.lineWidth = 4;
        
        // Set the stroke color of the activity indicator view
        activityIndicatorView.strokeColor = UIColor.red
        
        // Add it as a subview
        self.view.addSubview(activityIndicatorView)
        
        // Start animation
        activityIndicatorView.startAnimating()
        
        // Stop animation
        //activityIndicatorView.stopAnimating();
        
        for _ in 0...100 {
            self.repeatCall()
        }
    }
    
    func repeatCall() {
        
        // Create the URLSessionConfiguration and then create a session with that configuration.
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        // Create the URLRequest using either an URL
        if let url = URL.init(string: "https://httpbin.org/get") {
            let request = URLRequest(url: url)
            
            // Initialize the shared instance activity indicator controller.
            // Show the activity indicator
            ActivityIndicatorController.shared.show()

            // Call the web service
            let dataTask = session.dataTask(with: request, completionHandler: {_,_,_ in
                print(ActivityIndicatorController.shared.count)
                
                // Hide the activity indicator
                ActivityIndicatorController.shared.hide()
            })
            dataTask.resume()
        }
    }
}


