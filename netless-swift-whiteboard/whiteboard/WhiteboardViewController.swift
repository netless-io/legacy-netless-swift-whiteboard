//
//  testViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/13.
//  Copyright © 2019 伍双. All rights reserved.
//
import UIKit
import FileBrowser

//import ImagePicker
import Pickle

class Tools{
    let index: Int
    let isActive: Bool
    let iconView: UIImage
    let hasColor: Bool
    let hasStroke: Bool
    init(index: Int, iconView: UIImage, hasColor: Bool, hasStroke: Bool, isActive: Bool) {
        self.index = index
        self.iconView = iconView
        self.hasColor = hasColor
        self.hasStroke = hasStroke
        self.isActive = isActive
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

protocol WhiteboardViewControllerDelegate: NSObject {
    func fireReplay(uuid: String) -> Void
}

class WhiteboardViewController: UIViewController, WhiteRoomCallbackDelegate {
    
    public weak var delegate: WhiteboardViewControllerDelegate?
    
    var toolArray = ["selector", "pencil", "text", "upload", "eraser", "ellipse", "rectangle"]
    var toolDic: Dictionary<ToolType, Tools> = [
        ToolType.selector: Tools.init(index: 1, iconView: UIImage(named: ToolType.selector.rawValue)!, hasColor: false, hasStroke: false, isActive: false),
        ToolType.pencil: Tools.init(index: 2, iconView: UIImage(named: ToolType.pencil.rawValue)!, hasColor: true, hasStroke: true, isActive: false),
        ToolType.text: Tools.init(index: 3, iconView: UIImage(named: ToolType.text.rawValue)!, hasColor: true, hasStroke: false, isActive: false),
        ToolType.eraser: Tools.init(index: 4, iconView: UIImage(named: ToolType.eraser.rawValue)!, hasColor: false, hasStroke: false, isActive: false),
        ToolType.ellipse: Tools.init(index: 5, iconView: UIImage(named: ToolType.ellipse.rawValue)!, hasColor: true, hasStroke: true, isActive: false),
        ToolType.rectangle: Tools.init(index: 6, iconView: UIImage(named: ToolType.rectangle.rawValue)!, hasColor: true, hasStroke: true, isActive: false),
    ]
    
    private var uuid: String = ""
    
    var sdk: WhiteSDK?
    var boardView: WhiteBoardView?
    var room: WhiteRoom?
    var btnArray: [ToolboxButton] = []
    
    var activeMemberState: WhiteMemberState?
    var viewMode: WhiteViewMode = WhiteViewMode.freedom
    
    weak var commonCallbackDelegate: WhiteCommonCallbackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "互动白板"
        self.view.backgroundColor = UIColor.white
        let superview = self.view!
        setUpWhiteboardView()
        setupReplayButton()
        setUpBoardControllerBox(superview: superview)
        setUpShare(superview: superview)
        setUpGoBackBtn(superview: superview)
        setUpUploadBtn(superview: superview)
        setUpMenuBtn(superview: superview)
        ApiMiddleWare.createRoom(name: "test", limit: 100, room: RoomType.historied, callBack: onRoomCreated)
    }
    
    @objc func fireRoomStateChanged(_ state: WhiteRoomState) -> Void {
        
        if let broadcastState = state.broadcastState {
            self.viewMode = broadcastState.viewMode;
        }
    }
    
    func setUpWhiteboardView() -> Void {
        self.boardView = WhiteBoardView()
        self.view.addSubview(self.boardView!)
        self.boardView!.snp.makeConstraints({(make) -> Void in
             make.edges.equalTo(self.view)
        })
        initSDK()
    }
    
    func initSDK() -> Void {
        let config: WhiteSdkConfiguration = WhiteSdkConfiguration.defaultConfig()
        config.debug = true
        self.sdk = WhiteSDK(whiteBoardView: self.boardView!, config: config, commonCallbackDelegate: self.commonCallbackDelegate)
    }

    func onRoomCreated(uuid: String, roomToken: String) -> Void {
        let roomConfig = WhiteRoomConfig(uuid: uuid, roomToken: roomToken)
        self.uuid = uuid
        self.sdk!.joinRoom(with: roomConfig, callbacks: self, completionHandler:onReceiveJoinRoomResult)
    }
    
    func onReceiveJoinRoomResult(success: Bool, room: WhiteRoom?, error: Error?) -> Void {
        if (success) {
            self.room = room
            room?.getMemberState(result: { (state: WhiteMemberState) in
                self.activeMemberState = state
                self.setUpToolBox()
            })
            room?.getBroadcastState(result: { (state: WhiteBroadcastState) in
                self.viewMode = state.viewMode
            })
        }
    }
    
    func setupReplayButton() -> Void {
        let replayButton = ButtonPrimary(type: UIButton.ButtonType.custom)
        let replayIcon = UIImage(named: "add")
        replayButton.setImage(replayIcon, for: .normal)
        replayButton.addTarget(self, action: #selector(clickReplay), for: .touchUpInside)
        self.view.addSubview(replayButton)
        replayButton.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.topMargin.equalTo(28)
            make.rightMargin.equalTo(-100)
        })
    }
    
    func setUpBoardControllerBox(superview: UIView) -> Void {
        let boardControllerBtn = ButtonPrimary(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "board")
        boardControllerBtn.setImage(toolIcon, for: .normal)
        boardControllerBtn.addTarget(self, action: #selector(clickBroadControllerButton), for: .touchUpInside)
        superview.addSubview(boardControllerBtn)
        boardControllerBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.topMargin.equalTo(28)
            make.rightMargin.equalTo(-52)
        })
    }
    
    func setUpShare(superview: UIView) -> Void {
        let shareBtn = ButtonPrimary(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "add")
        shareBtn.setImage(toolIcon, for: .normal)
        shareBtn.addTarget(self, action: #selector(goShareView), for: .touchUpInside)
        superview.addSubview(shareBtn)
        shareBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.topMargin.equalTo(28)
            make.rightMargin.equalTo(-4)
        })
    }
    
    @objc func clickReplay() -> Void {
        self.goBackAndLeaveRoom()
        self.delegate?.fireReplay(uuid: self.uuid)
    }
    
    @objc func goShareView() -> Void {
        let viewController =  InviteViewController()
        viewController.setSharedURL("https://demo.herewhite.com/#/zh-CN/whiteboard/" + self.uuid + "/")
        let nav = UINavigationController(rootViewController: viewController)
        self.navigationController?.present(nav, animated: true, completion: nil);
    }
    
    @objc func clickBroadControllerButton() -> Void {
        if self.viewMode == WhiteViewMode.broadcaster {
            self.room?.setViewMode(WhiteViewMode.freedom)
        } else {
            self.room?.setViewMode(WhiteViewMode.broadcaster)
        }
    }
    
    func setUpGoBackBtn(superview: UIView) -> Void {
        let goBackBtn = UIButton(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "back")
        goBackBtn.setImage(toolIcon, for: .normal)
        goBackBtn.layer.borderColor = Theme.mainGrayLight.cgColor
        goBackBtn.layer.borderWidth = 1
        goBackBtn.layer.cornerRadius = 18
        goBackBtn.addTarget(self, action: #selector(goBackAndLeaveRoom), for: .touchUpInside)
        superview.addSubview(goBackBtn)
        goBackBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.topMargin.equalTo(28)
            make.leftMargin.equalTo(4)
        })
    }
    
    @objc func goBackAndLeaveRoom() -> Void {
        self.navigationController?.popViewController(animated: true);
        self.room?.disconnect({})
    }
    
    func setUpUploadBtn(superview: UIView) -> Void {
        let uploadBtn = ButtonPrimary(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "upload")
        uploadBtn.setImage(toolIcon, for: .normal)
        uploadBtn.addTarget(self, action: #selector(alertFileView), for: .touchUpInside)
        superview.addSubview(uploadBtn)
        uploadBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottomMargin.equalTo(-28)
            make.leftMargin.equalTo(4)
        })
    }
    
    @objc func alertFileView() -> Void {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let names = ["图片", "浏览"]
        for name in names {
            let action = UIAlertAction(title: name, style: .default) { (action) in
                if (action.title == "图片") {
                    let picker = ImagePickerController()
                    picker.delegate = self as? ImagePickerControllerDelegate
                    self.present(picker, animated: true, completion: nil)
                } else {
                    let baseUrl = self.getiCloudDocumentURL()
                    let manager = FileManager.default
                    
                    let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
                    
                    let url = urlForDocument[0] as URL
                    
                    if (baseUrl == nil) {
                        let fileBrowser = FileBrowser(initialPath: url, allowEditing: true)
                        self.present(fileBrowser, animated: true, completion: nil)
                    } else {
                        let fileBrowser = FileBrowser(initialPath: baseUrl, allowEditing: true)
                        self.present(fileBrowser, animated: true, completion: nil)
                    }
                }
            }
            controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func getiCloudDocumentURL() -> URL? {
        if let url = FileManager.default.url(forUbiquityContainerIdentifier: nil) {
            return url.appendingPathComponent("Documents") as URL
        }
        return nil
    }
    
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
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}
