//
//  SenceViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/15.
//  Copyright © 2019 伍双. All rights reserved.
//
import UIKit

class SenceViewController: UIViewController {
    
    public var room: WhiteRoom?
    
    private var tableView = UITableView()

    private var scenes: Array<WhiteScene> = []
    private var sceneIndex: Int = 0
    private var sceneDirectory: String = ""
    
    public func updateSceneState(sceneState: WhiteSceneState) -> Void {
        let originSelectedIndex = self.tableView.indexPathForSelectedRow?.row
        
        self.scenes = sceneState.scenes
        self.sceneIndex = sceneState.index
        self.tableView.reloadData()
        
        if originSelectedIndex == nil || self.sceneIndex != originSelectedIndex {
            self.tableView.selectRow(
                at: IndexPath(row: self.sceneIndex, section: 0),
                animated: false,
                scrollPosition: UITableView.ScrollPosition.middle
            )
        }
        let cells = sceneState.scenePath.split(separator: "/")
        
        if cells.count > 1 {
            let dirCells = cells[0...(cells.count - 2)]
            self.sceneDirectory = "/" + dirCells.joined(separator: "/")
        } else {
            self.sceneDirectory = "/"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部页面"
        let nav = self.navigationController?.navigationBar
        
        nav?.barStyle = UIBarStyle.black
        nav?.barTintColor = Theme.mainColor
        nav?.tintColor = UIColor.white
        self.view.backgroundColor = Theme.bgGray
        
        setUpSence()
        setupButtons()
        
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.view.addSubview(tableView)
    }
    
    func setupButtons() -> Void {
        let leftBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(goToWhiteboard))
        let rightBtn = UIBarButtonItem(title: "加一页", style: .plain, target: self, action: #selector(addSence))
        
        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    @objc func goToWhiteboard() -> Void {
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func addSence() -> Void {
        self.room?.putScenes(self.sceneDirectory, scenes: [WhiteScene()], index: UInt(self.sceneIndex + 1))
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
        cell.textLabel?.text = String(String(indexPath.row + 1))
        cell.backgroundColor = Theme.bgGray
        setupCellInner(cell: cell, isHighligh: indexPath.row == self.sceneIndex)
        return cell
    }
    
    func setupCellInner(cell: UITableViewCell, isHighligh: Bool) -> Void {
        let scene = UIView()
        scene.backgroundColor = UIColor.white
        
        cell.addSubview(scene)
        cell.backgroundColor = isHighligh ? Theme.mainGrayLight : Theme.bgGray
        
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
        let sceneName = self.scenes[indexPath.row].name
        let scenePath = self.sceneDirectory + "/" + sceneName
        
        self.room?.setScenePath(scenePath)
    }
}
