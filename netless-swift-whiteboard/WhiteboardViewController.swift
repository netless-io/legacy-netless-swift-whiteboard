//
//  testViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/13.
//  Copyright © 2019 伍双. All rights reserved.
//

import UIKit
class Tools{
    let index: Int
    let iconView: UIImage
    let hasColor: Bool
    let hasStroke: Bool
    init(index: Int, iconView: UIImage, hasColor: Bool, hasStroke: Bool) {
        self.index = index
        self.iconView = iconView
        self.hasColor = hasColor
        self.hasStroke = hasStroke
    }
}

enum ToolType: String {
    case selector = "selector"
    case pencil = "pencil"
    case text = "text"
    case upload = "upload"
    case eraser = "eraser"
    case ellipse = "ellipse"
    case rectangle = "rectangle"
}

class WhiteboardViewController: UIViewController {
    var toolArray = ["selector", "pencil", "text", "upload", "eraser", "ellipse", "rectangle"]
    var toolDic: Dictionary<ToolType, Tools> = [
        ToolType.selector: Tools.init(index: 1, iconView: UIImage(named: ToolType.selector.rawValue)!, hasColor: false, hasStroke: false),
        ToolType.pencil: Tools.init(index: 2, iconView: UIImage(named: ToolType.pencil.rawValue)!, hasColor: true, hasStroke: true),
        ToolType.text: Tools.init(index: 3, iconView: UIImage(named: ToolType.text.rawValue)!, hasColor: true, hasStroke: false),
        ToolType.upload: Tools.init(index: 4, iconView: UIImage(named: ToolType.upload.rawValue)!, hasColor: false, hasStroke: false),
        ToolType.eraser: Tools.init(index: 5, iconView: UIImage(named: ToolType.eraser.rawValue)!, hasColor: false, hasStroke: false),
        ToolType.ellipse: Tools.init(index: 6, iconView: UIImage(named: ToolType.ellipse.rawValue)!, hasColor: true, hasStroke: true),
        ToolType.rectangle: Tools.init(index: 7, iconView: UIImage(named: ToolType.rectangle.rawValue)!, hasColor: true, hasStroke: true),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "互动白板"
        self.view.backgroundColor = UIColor.white
        let superview = self.view!
        let whiteboard = WhiteBoardView()
        superview.addSubview(whiteboard)
        setUpBoardControllerBox(superview: superview)
        setUpSetBox(superview: superview)
        setUpShare(superview: superview)
        setUpGoBackBtn(superview: superview)
//        setUpReplayBtn(superview: superview)
        setUpMenuBtn(superview: superview)
        setUpToolBox(superview: superview)
    }
    
    func setUpTestBox(superview: UIView) -> Void {
        
    }
    
    func setUpBoardControllerBox(superview: UIView) -> Void {
        let boardControllerBtn = UIButton(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "board")
        boardControllerBtn.setImage(toolIcon, for: .normal)
        boardControllerBtn.layer.backgroundColor = Theme.mainColor.cgColor
        boardControllerBtn.clipsToBounds = true
        boardControllerBtn.layer.cornerRadius = 18
        boardControllerBtn.addTarget(self, action: #selector(goCreateRoomView), for: .touchUpInside)
        superview.addSubview(boardControllerBtn)
        boardControllerBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.topMargin.equalTo(28)
            make.rightMargin.equalTo(-100)
        })
    }
    
    func setUpShare(superview: UIView) -> Void {
        let shareBtn = UIButton(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "add")
        shareBtn.setImage(toolIcon, for: .normal)
        shareBtn.layer.backgroundColor = Theme.mainColor.cgColor
        shareBtn.layer.cornerRadius = 18
        shareBtn.addTarget(self, action: #selector(goShareView), for: .touchUpInside)
        superview.addSubview(shareBtn)
        shareBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.topMargin.equalTo(28)
            make.rightMargin.equalTo(-52)
        })
    }
    
    @objc func goShareView() -> Void {
        let nav = UINavigationController(rootViewController: InviteViewController())
        self.navigationController?.present(nav, animated: true, completion: nil);
    }
    
    func setUpSetBox(superview: UIView) -> Void {
        let setBtn = UIButton(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "more")
        setBtn.setImage(toolIcon, for: .normal)
        setBtn.layer.backgroundColor = Theme.mainColor.cgColor
        setBtn.clipsToBounds = true
        setBtn.layer.cornerRadius = 18
        setBtn.addTarget(self, action: #selector(goSetView), for: .touchUpInside)
        superview.addSubview(setBtn)
        setBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.topMargin.equalTo(28)
            make.rightMargin.equalTo(-4)
        })
    }
    
    @objc func goSetView() -> Void {
        let nav = UINavigationController(rootViewController: SetViewController())
        self.navigationController?.present(nav, animated: true, completion: nil);
    }
    
    
    func setUpGoBackBtn(superview: UIView) -> Void {
        let goBackBtn = UIButton(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "back")
        goBackBtn.setImage(toolIcon, for: .normal)
        goBackBtn.layer.borderColor = Theme.mainGrayLight.cgColor
        goBackBtn.layer.borderWidth = 1
        goBackBtn.layer.cornerRadius = 18
        goBackBtn.addTarget(self, action: #selector(goCreateRoomView), for: .touchUpInside)
        superview.addSubview(goBackBtn)
        goBackBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.topMargin.equalTo(28)
            make.leftMargin.equalTo(4)
        })
    }
    @objc func goCreateRoomView() -> Void {
        self.navigationController?.popViewController(animated: true);
    }
//    func setUpReplayBtn(superview: UIView) -> Void {
//        let replayBtn = UIButton(type: UIButton.ButtonType.custom)
//        let toolIcon = UIImage(named: "player")
//        replayBtn.setImage(toolIcon, for: .normal)
//        replayBtn.layer.borderColor = Theme.mainColor.cgColor
//        replayBtn.layer.borderWidth = 1
//        replayBtn.layer.cornerRadius = 18
//        superview.addSubview(replayBtn)
//        replayBtn.snp.makeConstraints({(make) -> Void in
//            make.size.equalTo(CGSize(width: 36, height: 36))
//            make.bottomMargin.equalTo(-28)
//            make.leftMargin.equalTo(4)
//        })
//    }
    
    func setUpMenuBtn(superview: UIView) -> Void {
        let menuBtn = UIButton(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "menu")
        menuBtn.setImage(toolIcon, for: .normal)
        menuBtn.layer.backgroundColor = Theme.mainColor.cgColor
        menuBtn.layer.cornerRadius = 18
        menuBtn.addTarget(self, action: #selector(goSenceView), for: .touchUpInside)
        superview.addSubview(menuBtn)
        menuBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottomMargin.equalTo(-28)
            make.rightMargin.equalTo(-4)
        })
    }
    
    @objc func goSenceView() -> Void {
        let nav = UINavigationController(rootViewController: SenceViewController())
        self.navigationController?.present(nav, animated: true, completion: nil);
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
        for tool in toolDic {
            let offsetX = (tool.value.index - 1) * 36
            let button = UIButton(type: UIButton.ButtonType.custom)
            let toolIcon = tool.value.iconView
            button.setImage(toolIcon, for: .normal)
            button.frame = CGRect(x: offsetX, y: 0, width: 36, height: 36)
            cellBox.addSubview(button)
        }
    }
}

