//
//  LoadingView.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/22.
//  Copyright © 2019 伍双. All rights reserved.
//

//import Foundation
//import NVActivityIndicatorView
//
//class LoadingView: UIView {
//    override init(frame: CGRect) {
//        super.init(frame : frame)
//        let iconFrame = CGRect(x: 00, y: 0, width: 42, height: 42)
//        let indicatorType = NVActivityIndicatorType.ballBeat
//        let loadingIcon = NVActivityIndicatorView(frame: iconFrame, type: indicatorType)
//        self.backgroundColor = UIColor.blue
//        self.snp.makeConstraints { (make) -> Void in
//            make.size.equalTo(CGSize(width: 64, height: 64))
//        }
//        self.addSubview(loadingIcon)
//        loadingIcon.snp.makeConstraints { (make) -> Void in
//            make.size.equalTo(CGSize(width: 42, height: 42))
//            make.center.equalTo(self)
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
