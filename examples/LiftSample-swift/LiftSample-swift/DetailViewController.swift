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
    var isDebugMode = false;

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var liftWidget: LGLiftWidget!

    let kLoglySampleAdspotId = NSNumber(longLong: 4228263)
    let kLoglySampleWidgetId = NSNumber(int: 3624)
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
                let gesture = UILongPressGestureRecognizer(target: self, action: #selector(DetailViewController.longpressed(_:)))
                label.addGestureRecognizer(gesture)
                label.userInteractionEnabled = true
            }
            if liftWidget != nil {
                liftWidget.requestByURL(detail["url"],
                                    adspotId:kLoglySampleAdspotId,
                                    widgetId:kLoglySampleWidgetId,
                                    ref:kLoglySampleRef)
                
                liftWidget.onWigetItemClickCallback = {(widget, url, item) -> Bool in
                    if self.isDebugMode {
                        let alert = UIAlertController(title: "Debug Mode", message: url, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler:nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return true;
                    }
                    return false;
                }
            }
        }
    }
    
    func longpressed(gesture:UIGestureRecognizer) {
        if gesture.state != UIGestureRecognizerState.Ended {
            return
        }
        self.isDebugMode = true

        let alert = UIAlertController(title: "Debug Mode", message: "Debug Mode Enabled", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler:nil))
        self.presentViewController(alert, animated: true, completion: nil)
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

