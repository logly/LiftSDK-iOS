//
//  DetailViewController.swift
//  LiftSample-swift
//
//  Created by Logly on H28/07/22.
//  Copyright © 平成28年 Logly. All rights reserved.
//

import UIKit
import LoglyLift

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var liftWidget: LGLiftWidget!

    let kLoglySampleAdspotId = NSNumber(longLong: 3777016)
    let kLoglySampleWidgetId = NSNumber(int: 1684)
    let kLoglySampleRef = "http://blog.logly.co.jp/"

    var detailItem: [String: String]? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail["text"]
            }
            if liftWidget != nil {
                liftWidget.requestByURL(detail["url"],
                                    adspotId:kLoglySampleAdspotId,
                                    widgetId:kLoglySampleWidgetId,
                                    ref:kLoglySampleRef)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

