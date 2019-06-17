//
//  SetViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/15.
//  Copyright © 2019 伍双. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部设置"
        let nav = self.navigationController?.navigationBar
        let superview = self.view!
        nav?.barStyle = UIBarStyle.black
        nav?.barTintColor = Theme.mainColor
        nav?.tintColor = UIColor.white
        superview.backgroundColor = UIColor.white
        setUpLeftBtn(superview: superview)
    }
    
    func setUpLeftBtn(superview: UIView) -> Void {
        let rightBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(goToWhiteboard))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    @objc func goToWhiteboard() -> Void {
        self.dismiss(animated: true, completion: nil);
    }
}
