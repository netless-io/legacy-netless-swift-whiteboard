//
//  InviteViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/15.
//  Copyright © 2019 伍双. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "邀请加入"
        let superview = self.view!
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.barTintColor = Theme.mainColor
        nav?.tintColor = UIColor.white
        superview.backgroundColor = UIColor.white
        setUpLeftBtn(superview: superview)
        setUpQRCode(superview: superview)
        setUpShareUrl(superview: superview)
    }
    
    func setUpShareUrl(superview: UIView) -> Void {
        let shareBox = UIView()
        shareBox.layer.cornerRadius = 4
        shareBox.layer.borderColor = Theme.mainColor.cgColor
        shareBox.layer.borderWidth = 1
        shareBox.clipsToBounds = true
        setUpInput(shareBox: shareBox)
        setUpSBtn(shareBox: shareBox)
        superview.addSubview(shareBox)
        shareBox.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 280, height: 42))
            make.centerX.equalTo(superview)
            make.centerYWithinMargins.equalTo(40)
        }
    }
    
    func setUpInput(shareBox: UIView) -> Void {
        let urlInput = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 42))
        urlInput.text = "https://www.netless.link/"
        urlInput.font = UIFont.systemFont(ofSize: 18)
        urlInput.isEditable = false
        shareBox.addSubview(urlInput)
    }
    
    func setUpSBtn(shareBox: UIView) -> Void {
        let urlBtn = UIButton(frame: CGRect(x: 200, y: 0, width: 80, height: 42))
        urlBtn.setTitle("复制", for: .selected)
        urlBtn.setTitle("复制", for: .normal)
        urlBtn.setTitleColor(UIColor.white, for: .normal)
        urlBtn.backgroundColor = Theme.mainColor
        shareBox.addSubview(urlBtn)
    }
    
    func setUpQRCode(superview: UIView) -> Void {
        let QRImage = UIImageView()
//        QRImage.image = UIImage(named: "head_image")
        QRCodeUtil.setQRCodeToImageView(QRImage, "www.netless.link", nil)
        superview.addSubview(QRImage)
        QRImage.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 160, height: 160))
            make.centerX.equalTo(superview)
            make.centerYWithinMargins.equalTo(-120)
        }
    }
    
    func setUpLeftBtn(superview: UIView) -> Void {
        let rightBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(goToWhiteboard))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    @objc func goToWhiteboard() -> Void {
        self.dismiss(animated: true, completion: nil);
    }
}
