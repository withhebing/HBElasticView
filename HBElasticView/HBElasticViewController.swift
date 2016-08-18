//
//  ViewController.swift
//  HBElasticView
//
//  Created by Beans on 16/8/18.
//  Copyright © 2016年 iceWorks. All rights reserved.
//

import UIKit

class HBElasticViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Elastic bounce effect"
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(elasticView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: - lazy load
    private lazy var elasticView: HBElasticView = {
        let view: HBElasticView = HBElasticView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        return view
    }()
}

