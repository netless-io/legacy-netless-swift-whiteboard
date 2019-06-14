//
//  ViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/13.
//  Copyright © 2019 伍双. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建白板"
        // Do any additional setup after loading the view.
        
       
        let superview = self.view!
        setUpLogoImage(superview: superview)
        setUpCreateButton(superview: superview)
        setUpJoinButton(superview: superview)
    }
    
    func setUpCreateButton(superview: UIView) -> Void {
        let createButton = UIButton(type: UIButton.ButtonType.custom)
        createButton.setTitle("创建白板", for: .selected)
        createButton.setTitle("创建白板", for: .normal)
        createButton.setTitleColor(UIColor.white, for: .normal)
        createButton.backgroundColor = Theme.mainColor
        createButton.addTarget(self, action: #selector(goToWhiteboardView), for: .touchUpInside)
        createButton.layer.cornerRadius = 8
        superview.addSubview(createButton)
        createButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 240, height: 48))
            make.centerYWithinMargins.equalTo(120)
            make.centerX.equalTo(superview)
        }
    }
    
    func setUpJoinButton(superview: UIView) -> Void {
        let joinButton = UIButton(type: UIButton.ButtonType.custom)
        joinButton.setTitle("加入白板", for: .selected)
        joinButton.setTitle("加入白板", for: .normal)
        joinButton.setTitleColor(Theme.mainColor, for: .normal)
        joinButton.backgroundColor = UIColor.white
        joinButton.addTarget(self, action: #selector(scanQRCode), for: .touchUpInside)
        joinButton.layer.cornerRadius = 8
        joinButton.layer.borderColor = Theme.mainColor.cgColor
        joinButton.layer.borderWidth = 1
        superview.addSubview(joinButton)
        joinButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 240, height: 48))
            make.centerYWithinMargins.equalTo(200)
            make.centerX.equalTo(superview)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    func setUpLogoImage(superview: UIView) -> Void {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "netless_black")
        superview.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 116, height: 24))
            make.centerYWithinMargins.equalTo(-180)
            make.centerX.equalTo(superview)
        }
    }
    
    @objc func goToWhiteboardView() -> Void {
        self.navigationController?.pushViewController(CreateRoomViewController(), animated: true);
    }
    
    @objc func scanQRCode() -> Void {
        self.navigationController?.pushViewController(QRScannerViewController(), animated: true);
    }
}

