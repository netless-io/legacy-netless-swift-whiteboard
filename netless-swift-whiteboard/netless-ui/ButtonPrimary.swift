//
//  ButtonPrimary.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/21.
//  Copyright © 2019 伍双. All rights reserved.
//


class ButtonPrimary: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    private func setup() {
        self.layer.backgroundColor = Theme.mainColor.cgColor
        self.layer.cornerRadius = 18
    }
}
