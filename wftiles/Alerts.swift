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
    
    private let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    private let label: UILabel = UILabel()
    private let blurEffect = UIBlurEffect(style: .dark)
    private let vibrancyView: UIVisualEffectView
    private var sinceShown = Date()
    private var hideCalled = false
    private var height: CGFloat = 50
    private let width = CGFloat(160)
    private let activityIndicatorSize: CGFloat = 40
    
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
        updateFrames()
    }
    
    private func updateFrames() {
        DispatchQueue.main.async(execute: {
            if let superview = self.superview {
                self.frame = CGRect(x: superview.frame.size.width / 2 - self.width / 2,
                                    y: superview.frame.height / 2 - self.height / 2,
                                    width: self.width,
                                    height: self.height)
                self.vibrancyView.frame = self.bounds
                
                self.activityIndictor.frame = CGRect(x: 5,
                                                     y: self.height / 2 - self.activityIndicatorSize / 2,
                                                     width: self.activityIndicatorSize,
                                                     height: self.activityIndicatorSize)
                self.activityIndictor.color = UIColor.lightText
                self.layer.cornerRadius = 8.0
                self.layer.masksToBounds = true
                self.label.textAlignment = NSTextAlignment.center
                self.label.frame = CGRect(x: self.activityIndicatorSize + 5,
                                          y: 0,
                                          width: self.width - self.activityIndicatorSize - 15,
                                          height: self.height)
                self.label.textColor = UIColor.lightText
            }
        })
    }
    
    func show(text: String) {
        DispatchQueue.main.async(execute: {
            self.label.text = text
            self.height = 50
            self.label.numberOfLines = 1
            let maxLabelWidth = self.width - self.activityIndicatorSize - 25
            var maxFontSize = Texts.shared.getMaxFontSize(text: text, maxWidth: maxLabelWidth)
            while maxFontSize < 12 {
                self.height += 20
                self.label.numberOfLines += 1
                maxFontSize = Texts.shared.getMaxFontSize(text: text, maxWidth: maxLabelWidth * CGFloat(self.label.numberOfLines))
            }
            self.label.font = UIFont.systemFont(ofSize: maxFontSize)
            self.hideCalled = false
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if (!self.hideCalled) {
                self.sinceShown = Date()
                if !self.activityIndictor.isAnimating {
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    let holdingView = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!.view!
                    holdingView.addSubview(self)
                    self.activityIndictor.startAnimating()
                    self.isHidden = false
                } else {
                    self.updateFrames()
                }
            }
        }
        
    }
    
    func hide() {
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
            
            refreshAlert.addAction(UIAlertAction(title: Texts.shared.getText(key: "ok"), style: .default, handler: { (action: UIAlertAction!) in
                //"Handle Ok logic here"
            }))
            
            view.present(refreshAlert, animated: true, completion: nil)
        })
        
    }
    
}
