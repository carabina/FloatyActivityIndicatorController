//
//  ActivityIndicatorController.swift
//
//
//  Created by Dario Trisciuoglio on 26/03/17.
//  Copyright © 2017 Floaty s.r.l. (http://www.floaty.it/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/// Completion handler.
///
/// - parameter finished: A Boolean value indicates whether or not the animations actually finished before the completion handler was called.
typealias ActivityIndicatorCompletionBlock = ((Bool) -> Void)

/// The level for an activity indicator.
public let UIWindowLevelActivityIndicator: UIWindowLevel = 1500

open class ActivityIndicatorController: UIViewController {
    
    //MARK: - Properties
    
    /// Use an activity indicator to show that a task is in progress. An activity indicator appears as a “gear” that is either spinning or stopped.
    @IBOutlet weak var activityIndicatorView: ActivityIndicatorView?
    
    /// The number of times it has been invoked show. When it invoked hide the counter viewn decremented by one.
    public private (set) var count: Int = 0
    
    /// A Boolean value that determines whether the view is display.
    /// YES if the view is display, otherwise NO.
    ///
    /// - returns: Returns YES if the receiver is animating, otherwise NO.
    public private(set) var isShown: Bool = false
    
    //MARK: - Shared instance
    
    /// - returns: shared instance activity indicator controller.
    public static let shared: ActivityIndicatorController = {
        return ActivityIndicatorWindow.shared.activityIndicatorController
    }()
    
    //MARK: - UIViewController
    override open func viewDidLoad() {
        super.viewDidLoad()
        let view = self.activityIndicatorView?.superview
        view?.layer.cornerRadius = 8.0
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicatorView?.startAnimating()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.activityIndicatorView?.stopAnimating()
    }
    
    /// Displays the receiver using animation.
    open func show() {
        if Thread.isMainThread {
            self.privateShow()
        } else {
            DispatchQueue.main.async {
                self.privateShow()
            }
        }
    }
    
    private func privateShow() {
        if self.count <= 0 {
            ActivityIndicatorWindow.shared.show()
            self.isShown = true
            self.count = 0
        }
        self.count += 1
    }
    
    /// Hidden the receiver using animation with the specified completion handler.
    ///
    /// - parameter completion: A block object to be executed when the animation sequence ends.
    ///
    /// This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. 
    /// If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle. This parameter may be NULL.
    open func hide(withCompletion completion: ((Bool) -> Void)? = nil) {
        if Thread.isMainThread {
            self.privateHide(withCompletion: completion)
        } else {
            DispatchQueue.main.async {
                self.privateHide(withCompletion: completion)
            }
        }
    }
    
    private func privateHide(withCompletion completion: ((Bool) -> Void)? = nil) {
        self.count -= 1
        if self.count <= 0 {
            ActivityIndicatorWindow.shared.hide(withCompletion: completion)
            self.isShown = false
            self.count = 0
        }
    }
}

private class ActivityIndicatorWindow: UIWindow {
    
    let activityIndicatorController: ActivityIndicatorController = {
        let podBundle = Bundle(for: ActivityIndicatorController.self)
        let bundleURL = podBundle.url(forResource: "ActivityIndicatorController", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        let storyboard = UIStoryboard(name: "ActivityIndicatorController", bundle: bundle)
        return (storyboard.instantiateInitialViewController() as? ActivityIndicatorController)!
    }()
    
    public static let shared: ActivityIndicatorWindow = {
        let window = ActivityIndicatorWindow(frame: UIScreen.main.bounds)
        window.tintColor = UIApplication.shared.delegate?.window??.tintColor
        window.windowLevel = UIWindowLevelActivityIndicator
        return window
    }()
    
    public func show() {
        self.isHidden = false
        self.alpha = 0
        self.activityIndicatorController.view.alpha = 0
        self.activityIndicatorController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.rootViewController = activityIndicatorController
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.alpha = 1
            self?.activityIndicatorController.view.alpha = 1
            self?.activityIndicatorController.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    public func hide(withCompletion completion: ((Bool) -> Void)? = nil) {
        self.activityIndicatorController.view.alpha = 1
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            self?.activityIndicatorController.view.alpha = 0
            self?.activityIndicatorController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self?.alpha = 0
        }) { [weak self] (finished) in
            self?.rootViewController = nil
            self?.isHidden = true
            completion?(finished)
        }
    }
}
