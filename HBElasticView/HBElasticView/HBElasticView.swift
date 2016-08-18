//
//  HBElasticView.swift
//  HBElasticView
//
//  Created by Beans on 16/8/18.
//  Copyright © 2016年 iceWorks. All rights reserved.
//

import UIKit

class HBElasticView: UIView {

    // MARK: - Vars

    private let shapeLayer = CAShapeLayer()
    private let minimalHeight: CGFloat = 64.0   // statusBar + navBar
    private let middleHeight: CGFloat = 100.0
    private let maxWaveHeight: CGFloat = 75.0
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
            self.userInteractionEnabled = !animating
            displayLink.paused = !animating
        }
    }

    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // setup shape layer
        shapeLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: minimalHeight)
        shapeLayer.fillColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0).CGColor
        shapeLayer.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
        layer.addSublayer(shapeLayer)

        // gesture
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panGestureDidMove:"))

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

        addSubview(left3_ControlPoint)
        addSubview(left2_ControlPoint)
        addSubview(left1_ControlPoint)
        addSubview(center_ControlPoint)
        addSubview(right1_ControlPoint)
        addSubview(right2_ControlPoint)
        addSubview(right3_ControlPoint)

        // initial position of shape layer
        layoutControlPoints(baseHeight: minimalHeight, waveHeight: 0.0, locationX: self.bounds.width / 2.0)
        updateShapeLayer()

        // update shape layer with time interval
        displayLink = CADisplayLink(target: self, selector: Selector("updateShapeLayer"))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink.paused = true
    }

    // MARK: - Methods

    // pan gesture action
    func panGestureDidMove(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Ended || gesture.state == .Failed || gesture.state == .Cancelled {
            var centerY = middleHeight

            animating = true
            UIView.animateWithDuration(0.9, delay: 0.0, usingSpringWithDamping: 0.57, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
                // spring and suspended
                self.left3_ControlPoint.center.y = centerY
                self.left2_ControlPoint.center.y = centerY
                self.left1_ControlPoint.center.y = centerY
                self.center_ControlPoint.center.y = centerY
                self.right1_ControlPoint.center.y = centerY
                self.right2_ControlPoint.center.y = centerY
                self.right3_ControlPoint.center.y = centerY
                }, completion: { _ in

                    UIView.animateWithDuration(0.5, delay: 0.5, options: [], animations: {
                        // back to under navBar
                        centerY = self.minimalHeight
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
            })

        } else {
            let locationX = gesture.locationInView(gesture.view).x

            let additionalHeight = max(gesture.translationInView(self).y, 0)    // avoid less than 0
            let waveHeight = min(additionalHeight * 0.5, maxWaveHeight)
            let baseHeight = minimalHeight + additionalHeight * 0.5 - waveHeight    // * 0.5 to make scroll less sensitive

            layoutControlPoints(baseHeight: baseHeight, waveHeight: waveHeight, locationX: locationX)
            updateShapeLayer()
        }
    }

    // shape layer path
    func updateShapeLayer() {
        shapeLayer.path = currentPath()
    }

    private func currentPath() -> CGPath {
        let width = self.bounds.width

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
        let width = self.bounds.width

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
