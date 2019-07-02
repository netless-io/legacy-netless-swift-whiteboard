//
//  ReplayViewController.swift
//  netless-swift-whiteboard
//
//  Created by TaoZeyu on 2019/7/2.
//  Copyright © 2019 伍双. All rights reserved.
//
import UIKit

class ReplayViewController: ViewController, WhitePlayerEventDelegate {
    
    public var uuid: String?
    public var roomToken: String?
    
    private var boardView: WhiteBoardView?
    private var player: WhitePlayer?
    
    override func viewDidLoad() {
        self.title = "白板回放"
        self.view.backgroundColor = UIColor.white
        
        self.setupBoardView()
        self.setupPlayButton()
        self.setupPlayer()
    }
    
    private func setupBoardView() -> Void {
        self.boardView = WhiteBoardView()
        self.view.addSubview(self.boardView!)
        self.boardView!.snp.makeConstraints({(make) -> Void in
            make.edges.equalTo(self.view)
        })
    }
    
    func setupPlayButton() -> Void {
        let playButton = ButtonPrimary(type: UIButton.ButtonType.custom)
        let playIcon = UIImage(named: "player")?.maskWithColor(color: UIColor.white)
        playButton.setImage(playIcon, for: .normal)
        playButton.addTarget(self, action: #selector(onClickPlayButton), for: .touchUpInside)
        self.view.addSubview(playButton)
        playButton.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottomMargin.equalTo(-28)
            make.leftMargin.equalTo(4)
        })
    }
    
    private func setupPlayer() -> Void {
        let sdkConfig: WhiteSdkConfiguration = WhiteSdkConfiguration.defaultConfig()
        sdkConfig.debug = true
        let sdk = WhiteSDK(whiteBoardView: self.boardView!, config: sdkConfig, commonCallbackDelegate:nil)
        let replayerConfig = WhitePlayerConfig(room: self.uuid!, roomToken: self.roomToken!)
        
        sdk.createReplayer(with: replayerConfig, callbacks: self, completionHandler: {
            (success: Bool, player: WhitePlayer?, error: Error?) in
            
            if (success) {
                self.player = player
                self.player!.seek(toScheduleTime: 0)
//                self.player!.play()
                print("success", player)
            }
        });
    }
    
    func scheduleTimeChanged(_ time: TimeInterval) {
        print("progress", time)
    }
    
    func stoppedWithError(_ error: Error) {
        print("error", error)
    }
    
    func phaseChanged(_ phase: WhitePlayerPhase) {
        print(phase)
    }
    
    @objc private func onClickPlayButton() {
        print("play")
    	self.player?.play()
    }
}
