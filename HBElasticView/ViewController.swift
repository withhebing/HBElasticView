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
    private let l3ControlPointView = UIView()
    private let l2ControlPointView = UIView()
    private let l1ControlPointView = UIView()
    private let cControlPointView = UIView()
    private let r1ControlPointView = UIView()
    private let r2ControlPointView = UIView()
    private let r3ControlPointView = UIView()

    // MARK: -

    override func loadView() {
        super.loadView()

        // shape layer
        shapeLayer.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: minimalHeight)
        shapeLayer.backgroundColor = UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0).CGColor
        shapeLayer.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
        view.layer.addSublayer(shapeLayer)

        // gesture
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panGestureDidMove:"))

        // control points
        l3ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        l2ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        l1ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        cControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        r1ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        r2ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        r3ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)

        l3ControlPointView.backgroundColor = .redColor()
        l2ControlPointView.backgroundColor = .redColor()
        l1ControlPointView.backgroundColor = .redColor()
        cControlPointView.backgroundColor = .redColor()
        r1ControlPointView.backgroundColor = .redColor()
        r2ControlPointView.backgroundColor = .redColor()
        r3ControlPointView.backgroundColor = .redColor()

        view.addSubview(l3ControlPointView)
        view.addSubview(l2ControlPointView)
        view.addSubview(l1ControlPointView)
        view.addSubview(cControlPointView)
        view.addSubview(r1ControlPointView)  
        view.addSubview(r2ControlPointView)  
        view.addSubview(r3ControlPointView)
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

    func panGestureDidMove(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Ended || gesture.state == .Failed || gesture.state == .Cancelled {

        } else {
            shapeLayer.frame.size.height = minimalHeight + max(gesture.translationInView(view).y, 0)
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

