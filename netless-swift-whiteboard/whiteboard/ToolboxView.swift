//
//  ToolboxView.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/21.
//  Copyright © 2019 伍双. All rights reserved.
//

extension WhiteboardViewController {
    
    func setUpToolBox() -> Void {
        let toolBox = UIView()
        toolBox.layer.cornerRadius = 4
        toolBox.layer.borderWidth = 1
        toolBox.layer.borderColor = Theme.mainGrayLight.cgColor
        toolBox.clipsToBounds = true
        self.view.addSubview(toolBox)
        toolBox.snp.makeConstraints({(make) -> Void in
            make.size.equalTo(CGSize(width: 216, height: 36))
            make.bottomMargin.equalTo(-28)
            make.centerX.equalTo(self.view)
        })
        setUpToolBoxCell(cellBox: toolBox)
    }
    
    func setUpToolBoxCell(cellBox: UIView) -> Void {
        let activeTool: String = self.activeMemberState!.jsonDict()["currentApplianceName"] as! String;
        for tool in toolDic {
            let offsetX = (tool.value.index - 1) * 36
            let button = ToolboxButton(type: UIButton.ButtonType.custom)
            button.toolType = tool.key
            var toolIcon = tool.value.iconView
            let colorArray = self.activeMemberState?.jsonDict()["strokeColor"] as! [CGFloat]
            let newColor = UIColor(colorArray[0], colorArray[1], colorArray[2])
            if (activeTool == tool.key.rawValue) {
                toolIcon = toolIcon.maskWithColor(color: newColor)
            }
            button.setImage(toolIcon, for: .normal)
            button.frame = CGRect(x: offsetX, y: 0, width: 36, height: 36)
            button.addTarget(self, action: #selector(switchTools(tool:)), for: .touchUpInside)
            self.btnArray.append(button)
            cellBox.addSubview(button)
        }
    }
    @objc func switchTools(tool: ToolboxButton) -> Void {
        let memberState: WhiteMemberState = WhiteMemberState()
        memberState.currentApplianceName = tool.toolType!.rawValue
        let colorArray = self.activeMemberState?.jsonDict()["strokeColor"] as! [CGFloat]
        let newColor = UIColor(colorArray[0], colorArray[1], colorArray[2])
        room?.setMemberState(memberState)
        for btn in self.btnArray {
            if (btn.toolType!.rawValue == tool.toolType!.rawValue) {
                if (btn.toolType!.rawValue == ToolType.selector.rawValue || btn.toolType!.rawValue == ToolType.eraser.rawValue) {
                    let icon = btn.imageView?.image?.maskWithColor(color: UIColor.black)
                    btn.setImage(icon, for: .normal)
                } else {
                    let icon = btn.imageView?.image?.maskWithColor(color: newColor)
                    btn.setImage(icon, for: .normal)
                }
            } else {
                let icon = btn.imageView?.image?.maskWithColor(color: Theme.mainGray)
                btn.setImage(icon, for: .normal)
            }
        }
    }
}

extension UIImage {
    
    public func maskWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
    
}

extension UIColor {
    
    //使用rgb方式生成自定义颜色
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    //使用rgba方式生成自定义颜色
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
}
