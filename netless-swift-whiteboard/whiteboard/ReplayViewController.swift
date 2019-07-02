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
    private var playButton: UIButton?
    private var slider: UISlider?
    
    private var player: WhitePlayer?
    private var timeDuration: TimeInterval?
    
    override func viewDidLoad() {
        self.title = "白板回放"
        self.view.backgroundColor = UIColor.white
        
        self.setupBoardView()
        self.setupGoBackBtn()
        self.setupPlayButton()
        self.setupSlider()
        self.setupPlayer()
    }
    
    private func setupBoardView() -> Void {
        self.boardView = WhiteBoardView()
        self.view.addSubview(self.boardView!)
        self.boardView!.snp.makeConstraints({(make) -> Void in
            make.edges.equalTo(self.view)
        })
    }
    
    func setupGoBackBtn() -> Void {
        let goBackBtn = UIButton(type: UIButton.ButtonType.custom)
        let toolIcon = UIImage(named: "back")
        goBackBtn.setImage(toolIcon, for: .normal)
        goBackBtn.layer.borderColor = Theme.mainGrayLight.cgColor
        goBackBtn.layer.borderWidth = 1
        goBackBtn.layer.cornerRadius = 18
        goBackBtn.addTarget(self, action: #selector(clickGoBack), for: .touchUpInside)
        self.view.addSubview(goBackBtn)
        goBackBtn.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.topMargin.equalTo(28)
            make.leftMargin.equalTo(4)
        })
    }
    
    func setupPlayButton() -> Void {
        let playButton = ButtonPrimary(type: UIButton.ButtonType.custom)
        let playIcon = UIImage(named: "player")?.maskWithColor(color: UIColor.white)
        playButton.setImage(playIcon, for: .normal)
        playButton.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
        self.view.addSubview(playButton)
        playButton.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottomMargin.equalTo(-28)
            make.leftMargin.equalTo(4)
        })
        self.playButton = playButton
    }
    
    func setupSlider() -> Void {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        self.view.addSubview(slider)
        slider.snp.makeConstraints {(make) in
            make.centerY.equalTo(self.playButton!)
            make.leftMargin.equalTo(44)
            make.rightMargin.equalTo(-4)
        }
        self.slider = slider
    }
    
    private func setupPlayer() -> Void {
        let sdkConfig: WhiteSdkConfiguration = WhiteSdkConfiguration.defaultConfig()
        let sdk = WhiteSDK(whiteBoardView: self.boardView!, config: sdkConfig, commonCallbackDelegate:nil)
        let replayerConfig = WhitePlayerConfig(room: self.uuid!, roomToken: self.roomToken!)
        
        sdk.createReplayer(with: replayerConfig, callbacks: self, completionHandler: {
            (success: Bool, player: WhitePlayer?, error: Error?) in
            
            if (success) {
                self.player = player
                self.player!.seek(toScheduleTime: 0)
//                self.player!.play()
                player?.getTimeInfo(result: {(info) in
                    self.timeDuration = info.timeDuration
                })
            }
        });
    }
    
    func scheduleTimeChanged(_ time: TimeInterval) {
        if let timeDuration = self.timeDuration {
            self.slider?.value = Float(time / timeDuration)
        }
    }
    
    func stoppedWithError(_ error: Error) {
        print("error", error)
    }
    
    func phaseChanged(_ phase: WhitePlayerPhase) {
        print(phase)
    }
    
    @objc private func clickPlayButton() {
    	self.player?.play()
    }
    
    @objc func clickGoBack() -> Void {
        self.navigationController?.popViewController(animated: true);
        self.player?.stop()
    }
}
