//
//  Alerts.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 01/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation
import UIKit

class Alerts: UIVisualEffectView {
    
    static let shared = Alerts()
    
    private let holdingView = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!.view!
    private let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    private let label: UILabel = UILabel()
    private let blurEffect = UIBlurEffect(style: .dark)
    private let vibrancyView: UIVisualEffectView
    private var sinceShown = Date()
    private var hideCalled = false
    
    private init() {
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        DispatchQueue.main.async(execute: {
            self.contentView.addSubview(self.vibrancyView)
            self.contentView.addSubview(self.activityIndictor)
            self.contentView.addSubview(self.label)
        })
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async(execute: {
            if let superview = self.superview {
                let width = superview.frame.size.width / 2.3
                let height: CGFloat = 50.0
                self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                    y: superview.frame.height / 2 - height / 2,
                                    width: width,
                                    height: height)
                self.vibrancyView.frame = self.bounds
                
                let activityIndicatorSize: CGFloat = 40
                self.activityIndictor.frame = CGRect(x: 5,
                                                     y: height / 2 - activityIndicatorSize / 2,
                                                     width: activityIndicatorSize,
                                                     height: activityIndicatorSize)
                self.activityIndictor.color = UIColor.lightText
                self.layer.cornerRadius = 8.0
                self.layer.masksToBounds = true
                self.label.textAlignment = NSTextAlignment.center
                self.label.frame = CGRect(x: activityIndicatorSize + 5,
                                          y: 0,
                                          width: width - activityIndicatorSize - 15,
                                          height: height)
                self.label.textColor = UIColor.lightText
                self.label.font = UIFont.boldSystemFont(ofSize: 16)
            }
        })
    }
    
    func show(text: String) {
        self.hideCalled = false
        self.label.text = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if (!self.hideCalled) {
                self.sinceShown = Date()
                if !self.activityIndictor.isAnimating {
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    self.holdingView.addSubview(self)
                    self.activityIndictor.startAnimating()
                    self.isHidden = false
                }
            }
        }
    }
    
    func hide() {
        //DispatchQueue.main.asyncAfter(deadline: .now() + shownSecs) {
        self.hideCalled = true
        let shownSecs = max(0.0, 0.5 - (Date().timeIntervalSince(self.sinceShown)))
        DispatchQueue.main.asyncAfter(deadline: .now() + shownSecs) {
            if !self.isHidden {
                self.activityIndictor.stopAnimating()
                self.isHidden = true
                self.removeFromSuperview()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
    func alert(view: UIViewController, title: String, errorString: String) {
        DispatchQueue.main.async(execute:{
            self.hide()
            
            let refreshAlert = UIAlertController(title: title, message: errorString, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                //"Handle Ok logic here"
            }))
            
            view.present(refreshAlert, animated: true, completion: nil)
        })
        
    }
    
}
