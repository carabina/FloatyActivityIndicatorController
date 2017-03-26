//
//  ActivityIndicatorView.swift
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

open class ActivityIndicatorView: UIView {
    
    /// The color used to stroke the shape’s path. Animatable.
    @IBInspectable public var strokeColor: UIColor = UIColor.white
    
    /// The line width used when stroking the path. Defaults to 2.5.
    @IBInspectable public var lineWidth: CGFloat = 2.5
    
    /// A Boolean value that controls whether the receiver is hidden when the animation is stopped.
    /// If the value of this property is true (the default), the receiver sets its hidden property (UIView) to true when receiver is not animating.
    /// If the hidesWhenStopped property is false, the receiver is not hidden when animation stops. You stop an animating progress indicator with the stopAnimating method.
    @IBInspectable var hidesWhenStopped: Bool = true
    
    /// Returns whether the receiver is animating.
    /// YES if the receiver is animating, otherwise NO.
    ///
    /// - returns: Returns YES if the receiver is animating, otherwise NO.
    private(set) var isAnimating: Bool = false
    
    /// A Boolean value that determines whether the view is display.
    /// YES if the view is display, otherwise NO.
    ///
    /// - returns: Returns YES if the receiver is animating, otherwise NO.
    private(set) var isShown: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInitialization()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - UINibLoadingAdditions
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInitialization()
    }
    
    //MARK: - Public methods
    
    /// Starts the animation of the progress indicator.
    /// When the progress indicator is animated, the gear spins to indicate indeterminate progress.
    /// The indicator is animated until stopAnimating is called.
    open func startAnimating() {
        if self.isAnimating { return }
        self.isHidden = false
        self.isShown = true
        CATransaction.begin()
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.beginTime = 0.5
        start.fromValue = 0.0
        start.toValue = 1.0
        start.duration = 1.5
        start.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.fromValue = 0.0
        end.toValue = 2.5
        start.duration = 1.5
        end.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.animations = [start, end]
        group.duration = 2.0
        group.repeatCount = Float.infinity
        self.createShapeLayer()?.add(group, forKey: "loopAnimation")
        self.isAnimating = true
        
        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.fromValue = 0
        spinAnimation.toValue = 2 * M_PI
        spinAnimation.duration = 2
        spinAnimation.repeatCount = Float.infinity
        self.layer.add(spinAnimation, forKey: "spinAnimation")
        CATransaction.setCompletionBlock {
            self.isAnimating = false
        }
        CATransaction.commit()
    }
    
    /// Stops the animation of the progress indicator.
    /// Call this method to stop the animation of the progress indicator started with a call to startAnimating.
    /// When animating is stopped, the indicator is hidden, unless isShown is NO.
    open func stopAnimating() {
        if !self.isAnimating { return }
        self.isShown = false
        self.layer.removeAnimation(forKey: "spinAnimation")
        self.shapeLayer?.removeAnimation(forKey: "loopAnimation")
        self.layer.removeAllAnimations()
        self.shapeLayer?.removeAllAnimations()
        self.shapeLayer = nil
        self.isAnimating = false
        self.isHidden = self.hidesWhenStopped;
    }
    
    //MARK: - Private methods
    private func commonInitialization() {
        self.clipsToBounds = false
        NotificationCenter.default.addObserver(self, selector: #selector(ActivityIndicatorView.didReceiveNotification(_:)), name:NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    private var shapeLayer: CAShapeLayer?
    
    private func createShapeLayer() -> CAShapeLayer? {
        if self.shapeLayer == nil {
            let shapeLayer = CAShapeLayer()
            let frame = self.bounds
            frame.insetBy(dx: 4, dy: 4)
            shapeLayer.path = UIBezierPath(ovalIn: frame).cgPath
            shapeLayer.strokeColor = self.strokeColor.cgColor;
            shapeLayer.fillColor = UIColor.clear.cgColor;
            shapeLayer.lineWidth = self.lineWidth
            shapeLayer.shouldRasterize = false
            shapeLayer.contentsScale = UIScreen.main.scale
            self.layer.addSublayer(shapeLayer)
            self.shapeLayer = shapeLayer
        }
        return self.shapeLayer
    }
    
    //MARK: Notification
    @objc private func didReceiveNotification(_ notification:Notification) {
        if notification.name == NSNotification.Name.UIApplicationDidBecomeActive && isAnimating {
            self.stopAnimating()
            self.startAnimating()
        }
    }
}
