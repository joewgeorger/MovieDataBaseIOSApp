//
//  Spinner.swift
//  joewgeorger-Lab4
//
//  Created by Joe Georger on 10/31/21.
//sets up loading spinner
// adapted from: https://www.youtube.com/watch?v=twgb5IPwR4I 

import UIKit

fileprivate var sView: UIView?

extension UIViewController {
    func showSpinner() {
        sView = UIView( frame: self.view.bounds)
        sView?.backgroundColor = .gray
        
        let s = UIActivityIndicatorView(style: .large)
        s.center = sView!.center
        s.startAnimating()
        sView?.addSubview(s)
        self.view.addSubview(sView!)
        
        Timer.scheduledTimer(withTimeInterval: 20, repeats: false) { (t) in self.removeSpin()}
    }
    
    func removeSpin() {
        sView?.removeFromSuperview()
        sView = nil
    }
}

