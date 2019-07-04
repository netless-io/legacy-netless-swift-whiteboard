//
//  SenceViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/15.
//  Copyright © 2019 伍双. All rights reserved.
//

import UIKit

class SenceViewController: UIViewController {
    
    private var tableView = UITableView()
    private var scenes: Array<WhiteScene> = []
    private var sceneIndex: Int = 0
    
    public func updateSceneState(sceneState: WhiteSceneState) -> Void {
        self.scenes = sceneState.scenes
        self.sceneIndex = sceneState.index
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部页面"
        let superview = self.view!
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.barTintColor = Theme.mainColor
        nav?.tintColor = UIColor.white
        superview.backgroundColor = Theme.bgGray
        
        setUpSence()
        setUpLeftBtn(superview: superview)
        
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.view.addSubview(tableView)
    }
    
    func setUpLeftBtn(superview: UIView) -> Void {
        let leftBtn = UIBarButtonItem(title: "加一页", style: .plain, target: self, action: #selector(addSence))
        let rightBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(goToWhiteboard))
        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    @objc func goToWhiteboard() -> Void {
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func addSence() -> Void {
        
    }
    
    func setUpSence() -> Void {
        let sence = UIView();
        sence.backgroundColor = UIColor.red
        self.view.addSubview(sence)
        sence.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 240, height: 160))
            make.centerYWithinMargins.equalTo(120)
            make.centerX.equalTo(self.view)
        }
    }
}

extension SenceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell_" + String(indexPath.row);
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellID)
        cell.textLabel?.text = String(String(indexPath.row))
        cell.backgroundColor = Theme.bgGray
        setUpCellInner(cell: cell)
        return cell
    }
    
    func setUpCellInner(cell: UITableViewCell) -> Void {
        let scene = UIView()
        scene.backgroundColor = UIColor.white
        cell.addSubview(scene)
        scene.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 192, height: 108))
            make.center.equalTo(cell)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scenes.count;
    }
    
    //cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 160
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
