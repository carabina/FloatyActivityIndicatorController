# ActivityIndicatorController


`ActivityIndicatorController` is an iOS class that displays an indicator while work is being done in a background thread.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

**ActivityIndicatorView**

``` swift
// Initialize the activity indicator view
let origin = CGPoint(x:40, y:40)
let size = CGSize(width:40, height:40)
let frame = CGRect(origin:origin, size:size)
let activityIndicatorView = ActivityIndicatorView(frame: frame)
    
// Set the line width of the activity indicator view
activityIndicatorView.lineWidth = 4
    
// Set the stroke color of the activity indicator view
activityIndicatorView.strokeColor = UIColor.red
    
// Add it as a subview
self.view.addSubview(activityIndicatorView)
    
// Start animation
activityIndicatorView.startAnimating()
    
// Stop animation
//activityIndicatorView.stopAnimating()

```

**ActivityIndicatorController**

``` swift
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

```

Also support xib and storyboard

The `lineWidth` and `strokeColor` properties can even be set after animating has been started, which you can observe in the included example project.

## Requirements

* iOS 8.0+
* Xcode 8.2

## Installation
**CocoaPods**

You can use [CocoaPods](http://cocoapods.org) to install FloatyActivityIndicatorController by adding it to your Podfile:

```
   
   platform :ios, '8.0'
   use_frameworks!
   pod "FloatyActivityIndicatorController"
   
```

## Author

Dario Trisciuoglio, trisci.dario@gmail.com

## License

FloatyActivityIndicatorController is available under the MIT license. See the LICENSE file for more info.
