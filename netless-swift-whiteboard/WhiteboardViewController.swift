//
//  testViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/13.
//  Copyright © 2019 伍双. All rights reserved.
//

import UIKit

class WhiteboardViewController: UIViewController {
    var toolArray = ["selector", "pencil", "text", "upload", "eraser", "ellipse", "rectangle"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "互动白板"
        self.view.backgroundColor = UIColor.white
        let superview = self.view!
        
        let whiteboard = WhiteBoardView()
        superview.addSubview(whiteboard)
        
        setUpGoBackBtn(superview: superview)
        setUpReplayBtn(superview: superview)
        setUpMenuBtn(superview: superview)
        setUpToolBox(superview: superview)
    }
    
    func setUpGoBackBtn(superview: UIView) -> Void {
        let replayBtn = UIButton(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "back")
        replayBtn.setImage(toolIcon, for: .normal)
        replayBtn.layer.borderColor = Theme.mainGrayLight.cgColor
        replayBtn.layer.borderWidth = 1
        replayBtn.layer.cornerRadius = 4
        replayBtn.addTarget(self, action: #selector(goToWhiteboardView), for: .touchUpInside)
        superview.addSubview(replayBtn)
        replayBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.topMargin.equalTo(28)
            make.leftMargin.equalTo(4)
        })
    }
    @objc func goToWhiteboardView() -> Void {
        self.navigationController?.popViewController(animated: true);
    }
    func setUpReplayBtn(superview: UIView) -> Void {
        let replayBtn = UIButton(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "player")
        replayBtn.setImage(toolIcon, for: .normal)
        replayBtn.layer.borderColor = Theme.mainColor.cgColor
        replayBtn.layer.borderWidth = 1
        replayBtn.layer.cornerRadius = 4
        superview.addSubview(replayBtn)
        replayBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottomMargin.equalTo(-28)
            make.leftMargin.equalTo(4)
        })
    }
    
    func setUpMenuBtn(superview: UIView) -> Void {
        let menuBtn = UIButton(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "menu")
        menuBtn.setImage(toolIcon, for: .normal)
        menuBtn.layer.backgroundColor = Theme.mainColor.cgColor
        menuBtn.layer.cornerRadius = 4
        superview.addSubview(menuBtn)
        menuBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottomMargin.equalTo(-28)
            make.rightMargin.equalTo(-4)
        })
    }
    
    func setUpToolBox(superview: UIView) -> Void {
        let toolBox = UIView()
        toolBox.layer.cornerRadius = 4
        toolBox.layer.borderWidth = 1
        toolBox.layer.borderColor = Theme.mainGrayLight.cgColor
        toolBox.clipsToBounds = true
        superview.addSubview(toolBox)
        toolBox.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 252, height: 36))
            make.bottomMargin.equalTo(-28)
            make.centerX.equalTo(superview)
        })
        setUpToolBoxCell(cellBox: toolBox)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setUpToolBoxCell(cellBox: UIView) -> Void {
        for (index, tool) in toolArray.enumerated() {
            let offsetX = index * 36
            let button = UIButton(type: UIButton.ButtonType.custom)
            let toolIcon = UIImage(named: tool)
            button.setImage(toolIcon, for: .normal)
            button.frame = CGRect(x: offsetX, y: 0, width: 36, height: 36)
            cellBox.addSubview(button)
        }
    }
}

