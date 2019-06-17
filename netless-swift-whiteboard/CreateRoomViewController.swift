//
//  CreateRoomViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/14.
//  Copyright © 2019 伍双. All rights reserved.
//

import UIKit
import Alamofire

class CreateRoomViewController: UIViewController {
    
    var textV: UITextView?
    
   override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建白板"
        let superview = self.view!
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.barTintColor = Theme.mainColor
        nav?.tintColor = UIColor.white
        superview.backgroundColor = UIColor.white
        setUpInPut(superview: superview)
        setUpCreateBtn(superview: superview)
        // Do any additional setup after loading the view.
    }
    
    func setUpCreateBtn(superview: UIView) -> Void {
        let createButton = UIButton(type: UIButton.ButtonType.custom)
        createButton.setTitle("创建白板", for: .selected)
        createButton.setTitle("创建白板", for: .normal)
        createButton.setTitleColor(UIColor.white, for: .normal)
        createButton.backgroundColor = Theme.mainColor
        createButton.addTarget(self, action: #selector(goToWhiteboardView), for: .touchUpInside)
        createButton.layer.cornerRadius = 4
        superview.addSubview(createButton)
        createButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 320, height: 48))
            make.topMargin.equalTo(160)
            make.centerX.equalTo(superview)
        }
    }
    
    
    @objc func funCreateRoom() -> Void {
//        AF.request("https://cloudcapiv4.herewhite.com", method: .post, parameters: [
//            "name": "白板名称",
//            "limit": 100,
//            "mode": "persistent"
//        ]).responseJSON{ response in
//            debugPrint(response)
//        }
//        WhiteUtils.createRoom(result: <#T##(Bool, Any?, Error?) -> Void#>)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.textV?.becomeFirstResponder()
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    @objc func goToWhiteboardView() -> Void {
        self.navigationController?.pushViewController(WhiteboardViewController(), animated: true)
    }
    
    func setUpInPut(superview: UIView) -> Void {
        let inputBox = UITextView()
        inputBox.layer.borderColor = Theme.mainColor.cgColor
        inputBox.layer.borderWidth = 1
        inputBox.layer.cornerRadius = 4
        inputBox.textContainer.maximumNumberOfLines = 1;
//        inputBox.place = "输入昵称"
        inputBox.font = UIFont.systemFont(ofSize: 18)
        superview.addSubview(inputBox)
        inputBox.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 320, height: 48))
            make.topMargin.equalTo(80)
            make.centerX.equalTo(superview)
        }
        
        self.textV = inputBox
        
    }
}
