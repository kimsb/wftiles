//
//  ProgressHUD.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 01/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation
import UIKit

class ProgressHUD: UIVisualEffectView {
    
    static let hud = ProgressHUD()
    
    private let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    private let label: UILabel = UILabel()
    private let blurEffect = UIBlurEffect(style: .dark)
    private let vibrancyView: UIVisualEffectView
    
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
        DispatchQueue.main.async(execute: {
            self.label.text = text
            if !self.activityIndictor.isAnimating {
                UIApplication.shared.beginIgnoringInteractionEvents()
                let appDel = UIApplication.shared.delegate as! AppDelegate
                let holdingView = appDel.window!.rootViewController!.view!
                holdingView.addSubview(self)
                self.activityIndictor.startAnimating()
                self.isHidden = false
            }
        })
    }
    
    func hide() {
        DispatchQueue.main.async(execute: {
            self.activityIndictor.stopAnimating()
            self.isHidden = true
            self.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        })
    }
}
