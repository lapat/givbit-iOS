//
//  BottomNotificationView.swift
//  GivBit
//
//  Created by Tallal Javed on 7/17/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class BottomNotificationView: UIView {
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationExplainationLabel: UILabel!
    //var contentView: UIView?
    @IBOutlet weak var view: UIView!
    
    //var topConstraint, bottomConstraint, ,: NSLayoutConstraint!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth,
                                 UIViewAutoresizing.flexibleHeight]
        
        addSubview(view)
        
        // Add our border here and every custom setup
//        view.layer.borderWidth = 2
//        view.layer.borderColor = UIColor.white.cgColor
//        view.titleLabel!.font = UIFont.systemFont(ofSize: 40)
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        // associate the buttons
        
        
        return view
    }
    
}
