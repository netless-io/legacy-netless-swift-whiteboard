//
//  testViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/13.
//  Copyright © 2019 伍双. All rights reserved.
//
import UIKit
import FileBrowser
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
    func fireReplay(uuid: String, roomToken: String) -> Void
}

class WhiteboardViewController: UIViewController, WhiteRoomCallbackDelegate {
    
    public weak var delegate: WhiteboardViewControllerDelegate?
    public var uuid: String?
    private var roomToken: String = ""
    private var spinnerView: UIView?
    
    var toolArray = ["selector", "pencil", "text", "upload", "eraser", "ellipse", "rectangle"]
    var toolDic: Dictionary<ToolType, Tools> = [
        ToolType.selector: Tools.init(index: 1, iconView: UIImage(named: ToolType.selector.rawValue)!, hasColor: false, hasStroke: false, isActive: false),
        ToolType.pencil: Tools.init(index: 2, iconView: UIImage(named: ToolType.pencil.rawValue)!, hasColor: true, hasStroke: true, isActive: false),
        ToolType.text: Tools.init(index: 3, iconView: UIImage(named: ToolType.text.rawValue)!, hasColor: true, hasStroke: false, isActive: false),
        ToolType.eraser: Tools.init(index: 4, iconView: UIImage(named: ToolType.eraser.rawValue)!, hasColor: false, hasStroke: false, isActive: false),
        ToolType.ellipse: Tools.init(index: 5, iconView: UIImage(named: ToolType.ellipse.rawValue)!, hasColor: true, hasStroke: true, isActive: false),
        ToolType.rectangle: Tools.init(index: 6, iconView: UIImage(named: ToolType.rectangle.rawValue)!, hasColor: true, hasStroke: true, isActive: false),
    ]
    
    var sdk: WhiteSDK?
    var boardView: WhiteBoardView?
    var sceneViewController: SenceViewController?
    var pptPreviewViewController: PPTPreviewViewController?
    var room: WhiteRoom?
    var btnArray: [ToolboxButton] = []
    
    var activeMemberState: WhiteMemberState?
    var viewMode: WhiteViewMode = WhiteViewMode.freedom
    
    weak var commonCallbackDelegate: WhiteCommonCallbackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "互动白板"
        self.view.backgroundColor = UIColor.white
        self.sceneViewController = SenceViewController()
        self.pptPreviewViewController = PPTPreviewViewController()
        
        let superview = self.view!
        setUpWhiteboardView()
        setupReplayButton()
        setUpBoardControllerBox(superview: superview)
        setUpShare(superview: superview)
        setUpGoBackBtn(superview: superview)
        setUpUploadBtn(superview: superview)
        setUpMenuBtn(superview: superview)
        setupSceneOperationButtons()
        
        if self.uuid != nil {
            ApiMiddleWare.joinRoom(uuid: self.uuid!, callback: onRoomJoined)
        } else {
            ApiMiddleWare.createRoom(name: "test", limit: 100, room: RoomType.historied, callBack: onRoomCreated)
        }
        self.showSpinner()
    }
    
    @objc func fireRoomStateChanged(_ state: WhiteRoomState) -> Void {
        
        if let broadcastState = state.broadcastState {
            self.viewMode = broadcastState.viewMode;
        }
        if let sceneState = state.sceneState {
            self.sceneViewController?.updateSceneState(sceneState: sceneState)
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
        self.sdk = WhiteSDK(whiteBoardView: self.boardView!, config: config, commonCallbackDelegate: self.commonCallbackDelegate)
    }

    func onRoomCreated(uuid: String, roomToken: String) -> Void {
        let roomConfig = WhiteRoomConfig(uuid: uuid, roomToken: roomToken)
        self.uuid = uuid
        self.roomToken = roomToken
        self.sdk!.joinRoom(with: roomConfig, callbacks: self, completionHandler:onReceiveJoinRoomResult)
    }
    
    func onRoomJoined(roomToken: String) -> Void {
        let roomConfig = WhiteRoomConfig(uuid: self.uuid!, roomToken: roomToken)
        self.roomToken = roomToken
        self.sdk!.joinRoom(with: roomConfig, callbacks: self, completionHandler:onReceiveJoinRoomResult)
    }
    
    func onReceiveJoinRoomResult(success: Bool, room: WhiteRoom?, error: Error?) -> Void {
        if (success) {
            self.room = room
            self.sceneViewController?.room = room
            self.pptPreviewViewController?.room = room
            self.removeSpinner()
            
            room?.getMemberState(result: { (state: WhiteMemberState) in
                self.activeMemberState = state
                self.setUpToolBox()
            })
            room?.getBroadcastState(result: { (state: WhiteBroadcastState) in
                self.viewMode = state.viewMode
            })
            room?.getSceneState(result: { (state) in
                self.sceneViewController?.updateSceneState(sceneState: state)
            })
            room?.moveCamera(toContainer: WhiteRectangleConfig(
                originX: -480, originY: -270, width: 960, height: 540, animation: .immediately
            ))
        }
    }
    
    func setupReplayButton() -> Void {
        let replayButton = ButtonPrimary(type: UIButton.ButtonType.custom)
        let replayIcon = UIImage(named: "player")?.maskWithColor(color: UIColor.white)
        
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
        self.delegate?.fireReplay(uuid: self.uuid!, roomToken: self.roomToken)
        var viewControllers = self.navigationController?.viewControllers
        let index = viewControllers!.firstIndex(of: self)!
        viewControllers!.remove(at: index)
        self.navigationController?.viewControllers = viewControllers!
        self.room?.disconnect({})
    }
    
    @objc func goShareView() -> Void {
        let viewController =  InviteViewController()
        viewController.setSharedURL("https://demo.herewhite.com/#/zh-CN/whiteboard/" + self.uuid! + "/")
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
        uploadBtn.addTarget(self, action: #selector(clickUploadButton), for: .touchUpInside)
        superview.addSubview(uploadBtn)
        uploadBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottomMargin.equalTo(-28)
            make.leftMargin.equalTo(4)
        })
    }
    
    @objc func clickUploadButton() -> Void {
        let nav = UINavigationController(rootViewController: self.pptPreviewViewController!)
        self.navigationController?.present(nav, animated: true, completion: nil);
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
    
    func setupSceneOperationButtons() -> Void {
        let previousButton = UIButton(type: .custom)
        let nextButton = UIButton(type: .custom)
        
        self.view.addSubview(previousButton)
        self.view.addSubview(nextButton)
        
        previousButton.setImage(UIImage(named: "up")!.maskWithColor(color: .white), for: .normal)
        previousButton.layer.backgroundColor = Theme.mainColor.cgColor
        previousButton.layer.cornerRadius = 18
        
        nextButton.setImage(UIImage(named: "down")!.maskWithColor(color: .white), for: .normal)
        nextButton.layer.backgroundColor = Theme.mainColor.cgColor
        nextButton.layer.cornerRadius = 18
        
        previousButton.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottomMargin.equalTo(-116)
            make.rightMargin.equalTo(-4)
        })
        nextButton.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottomMargin.equalTo(-72)
            make.rightMargin.equalTo(-4)
        })
        previousButton.addTarget(self, action: #selector(clickPreviousButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(clickNextButton), for: .touchUpInside)
    }
    
    @objc func goSenceView() -> Void {
        self.sceneViewController!.setVisible(true)
        let nav = UINavigationController(rootViewController: self.sceneViewController!)
        self.navigationController?.present(nav, animated: true, completion: nil);
    }
    
    @objc func clickPreviousButton() -> Void {
        self.room?.pptPreviousStep()
    }
    
    @objc func clickNextButton() -> Void {
        self.room?.pptNextStep()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func showSpinner() {
        self.spinnerView = UIView(frame: self.view.bounds)
        self.spinnerView!.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = self.spinnerView!.center
        self.spinnerView!.addSubview(ai)
        self.view.addSubview(self.spinnerView!)
    }
    
    private func removeSpinner() {
        self.spinnerView?.removeFromSuperview()
    }
}
