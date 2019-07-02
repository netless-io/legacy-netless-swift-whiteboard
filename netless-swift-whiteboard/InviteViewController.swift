//
//  InviteViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/15.
//  Copyright © 2019 伍双. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    
    private var sharedURL: String = ""
    
    public func setSharedURL(_ sharedURL: String) {
        self.sharedURL = sharedURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "邀请加入"
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.barTintColor = Theme.mainColor
        nav?.tintColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        setUpLeftBtn()
        setUpQRCode()
        setUpShareUrl()
    }
    
    func setUpShareUrl() -> Void {
        let shareBox = UIView()
        shareBox.layer.cornerRadius = 4
        shareBox.layer.borderColor = Theme.mainColor.cgColor
        shareBox.layer.borderWidth = 1
        shareBox.clipsToBounds = true
        setUpInput(shareBox: shareBox)
        setUpSBtn(shareBox: shareBox)
        self.view.addSubview(shareBox)
        shareBox.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 280, height: 42))
            make.centerX.equalTo(self.view)
            make.centerYWithinMargins.equalTo(40)
        }
    }
    
    func setUpInput(shareBox: UIView) -> Void {
        let urlInput = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 42))
        urlInput.text = sharedURL
        urlInput.font = UIFont.systemFont(ofSize: 18)
        urlInput.isEditable = false
        shareBox.addSubview(urlInput)
    }
    
    func setUpSBtn(shareBox: UIView) -> Void {
        let urlBtn = UIButton(frame: CGRect(x: 200, y: 0, width: 80, height: 42))
        urlBtn.setTitle("复制", for: .selected)
        urlBtn.setTitle("复制", for: .normal)
        urlBtn.setTitleColor(UIColor.white, for: .normal)
        urlBtn.addTarget(self, action: #selector(clickCopyButton), for: .touchUpInside)
        urlBtn.backgroundColor = Theme.mainColor
        shareBox.addSubview(urlBtn)
    }
    
    @objc func clickCopyButton() -> Void {
        UIPasteboard.general.string = self.sharedURL
    }
    
    func setUpQRCode() -> Void {
        let QRImage = UIImageView()
        QRCodeUtil.setQRCodeToImageView(QRImage, sharedURL, nil)
        self.view.addSubview(QRImage)
        QRImage.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 160, height: 160))
            make.centerX.equalTo(self.view)
            make.centerYWithinMargins.equalTo(-120)
        }
    }
    
    func setUpLeftBtn() -> Void {
        let rightBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(goToWhiteboard))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    @objc func goToWhiteboard() -> Void {
        self.dismiss(animated: true, completion: nil);
    }
}
