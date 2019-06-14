//
//  CreateRoomViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/14.
//  Copyright © 2019 伍双. All rights reserved.
//

import UIKit

class CreateRoomViewController: UIViewController {
   override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建白板"
        let superview = self.view!
        superview.backgroundColor = UIColor.white
        setUpInPut(superview: superview)
        // Do any additional setup after loading the view.
    }
    
    func setUpInPut(superview: UIView) -> Void {
        let inputBox = UITextView()
        inputBox.layer.borderColor = Theme.mainColor.cgColor
        inputBox.layer.borderWidth = 1
        inputBox.layer.cornerRadius = 4
        inputBox.textContainer.maximumNumberOfLines = 1;
        superview.addSubview(inputBox)
        inputBox.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 320, height: 48))
            make.topMargin.equalTo(80)
            make.centerX.equalTo(superview)
        }
    }
}
