//
//  ViewController.swift
//  HBElasticView
//
//  Created by Beans on 16/8/18.
//  Copyright © 2016年 iceWorks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Vars

    private let shapeLayer = CAShapeLayer()
    private let minimalHeight: CGFloat = 50.0
    private let maxWaveHeight: CGFloat = 100.0
    // control points
    private let left3_ControlPoint = UIView()
    private let left2_ControlPoint = UIView()
    private let left1_ControlPoint = UIView()
    private let center_ControlPoint = UIView()
    private let right1_ControlPoint = UIView()
    private let right2_ControlPoint = UIView()
    private let right3_ControlPoint = UIView()
    // timer
    private var displayLink: CADisplayLink!
    // anim
    private var animating = false {
        didSet {
            view.userInteractionEnabled = !animating
            displayLink.paused = !animating
        }
    }

    // MARK: -

    override func loadView() {
        super.loadView()

        // setup shape layer
        shapeLayer.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: minimalHeight)
        shapeLayer.fillColor = UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0).CGColor
        shapeLayer.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
        view.layer.addSublayer(shapeLayer)

        // gesture
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panGestureDidMove:"))

        // control points
        left3_ControlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        left2_ControlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        left1_ControlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        center_ControlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        right1_ControlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        right2_ControlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        right3_ControlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)

        left3_ControlPoint.backgroundColor = .redColor()
        left2_ControlPoint.backgroundColor = .redColor()
        left1_ControlPoint.backgroundColor = .redColor()
        center_ControlPoint.backgroundColor = .redColor()
        right1_ControlPoint.backgroundColor = .redColor()
        right2_ControlPoint.backgroundColor = .redColor()
        right3_ControlPoint.backgroundColor = .redColor()

        view.addSubview(left3_ControlPoint)
        view.addSubview(left2_ControlPoint)
        view.addSubview(left1_ControlPoint)
        view.addSubview(center_ControlPoint)
        view.addSubview(right1_ControlPoint)  
        view.addSubview(right2_ControlPoint)  
        view.addSubview(right3_ControlPoint)

        // initial position of shape layer
        layoutControlPoints(baseHeight: minimalHeight, waveHeight: 0.0, locationX: view.bounds.width / 2.0)
        updateShapeLayer()

        // update shape layer with time interval
        displayLink = CADisplayLink(target: self, selector: Selector("updateShapeLayer"))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink.paused = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Methods

    // pan gesture action
    func panGestureDidMove(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Ended || gesture.state == .Failed || gesture.state == .Cancelled {
            let centerY = minimalHeight

            animating = true
            UIView.animateWithDuration(0.9, delay: 0.0, usingSpringWithDamping: 0.57, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
                self.left3_ControlPoint.center.y = centerY
                self.left2_ControlPoint.center.y = centerY
                self.left1_ControlPoint.center.y = centerY
                self.center_ControlPoint.center.y = centerY
                self.right1_ControlPoint.center.y = centerY
                self.right2_ControlPoint.center.y = centerY
                self.right3_ControlPoint.center.y = centerY
                }, completion: { _ in
                    self.animating = false
            })

        } else {
            let additionalHeight = max(gesture.translationInView(view).y, 0)

            let waveHeight = min(additionalHeight * 0.6, maxWaveHeight)
            let baseHeight = minimalHeight + additionalHeight - waveHeight

            let locationX = gesture.locationInView(gesture.view).x
            
            layoutControlPoints(baseHeight: baseHeight, waveHeight: waveHeight, locationX: locationX)
            updateShapeLayer()
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // shape layer path
    func updateShapeLayer() {
        shapeLayer.path = currentPath()
    }

    private func currentPath() -> CGPath {
        let width = view.bounds.width

        let bezierPath = UIBezierPath()

        bezierPath.moveToPoint(CGPoint(x: 0.0, y: 0.0))
        bezierPath.addLineToPoint(CGPoint(x: 0.0, y: left3_ControlPoint.hb_center(animating).y))
        bezierPath.addCurveToPoint(left1_ControlPoint.hb_center(animating), controlPoint1: left3_ControlPoint.hb_center(animating), controlPoint2: left2_ControlPoint.hb_center(animating))
        bezierPath.addCurveToPoint(right1_ControlPoint.hb_center(animating), controlPoint1: center_ControlPoint.hb_center(animating), controlPoint2: right1_ControlPoint.hb_center(animating))
        bezierPath.addCurveToPoint(right3_ControlPoint.hb_center(animating), controlPoint1: right1_ControlPoint.hb_center(animating), controlPoint2: right2_ControlPoint.hb_center(animating))
        bezierPath.addLineToPoint(CGPoint(x: width, y: 0.0))

        bezierPath.closePath()
        
        return bezierPath.CGPath
    }

    // layout control points to update shape layer
    private func layoutControlPoints(baseHeight baseHeight: CGFloat, waveHeight: CGFloat, locationX: CGFloat) {
        let width = view.bounds.width

        let minLeftX = min((locationX - width / 2.0) * 0.28, 0.0)
        let maxRightX = max(width + (locationX - width / 2.0) * 0.28, width)

        let leftPartWidth = locationX - minLeftX
        let rightPartWidth = maxRightX - locationX

        left3_ControlPoint.center = CGPoint(x: minLeftX, y: baseHeight)
        left2_ControlPoint.center = CGPoint(x: minLeftX + leftPartWidth * 0.44, y: baseHeight)
        left1_ControlPoint.center = CGPoint(x: minLeftX + leftPartWidth * 0.71, y: baseHeight + waveHeight * 0.64)
        center_ControlPoint.center = CGPoint(x: locationX , y: baseHeight + waveHeight * 1.36)
        right1_ControlPoint.center = CGPoint(x: maxRightX - rightPartWidth * 0.71, y: baseHeight + waveHeight * 0.64)
        right2_ControlPoint.center = CGPoint(x: maxRightX - (rightPartWidth * 0.44), y: baseHeight)
        right3_ControlPoint.center = CGPoint(x: maxRightX, y: baseHeight)
    }

}

