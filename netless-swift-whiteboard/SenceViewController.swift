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
    private var scenePreviews: Array<UIImage?> = []
    private var sceneIndex: Int = 0
    private var sceneDirectory: String = ""
    private var isVisible: Bool = false
    private var didRejectUpdate: Bool = false
    
    public func updateSceneState(sceneState: WhiteSceneState) -> Void {
        let originSelectedIndex = self.tableView.indexPathForSelectedRow?.row
        let cells = sceneState.scenePath.split(separator: "/")
        
        self.scenes = sceneState.scenes
        self.sceneIndex = sceneState.index
        
        if cells.count > 1 {
            let dirCells = cells[0...(cells.count - 2)]
            self.sceneDirectory = "/" + dirCells.joined(separator: "/")
        } else {
            self.sceneDirectory = "/"
        }
        if (self.isVisible) {
            self.refreshPreviews(originSelectedIndex: originSelectedIndex)
        } else {
            self.didRejectUpdate = true
        }
    }
    
    private func refreshPreviews(originSelectedIndex: Int?) {
        if originSelectedIndex == nil || self.sceneIndex != originSelectedIndex {
            if self.sceneIndex < self.tableView.numberOfRows(inSection: 0) {
                self.tableView.selectRow(
                    at: IndexPath(row: self.sceneIndex, section: 0),
                    animated: false,
                    scrollPosition: UITableView.ScrollPosition.middle
                )
            }
        }
        self.scenePreviews = Array(repeating: nil, count: self.scenes.count)

        for i in 0...(self.scenes.count - 1) {
            let scenePath = self.scenePath(index: i)
            self.room?.getScenePreviewImage(scenePath, completion: {(image) in
                self.scenePreviews[i] = image
                self.tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .none)
            })
        }
        self.tableView.reloadData()
    }
    
    public func setVisible(_ isVisible: Bool) {
        if (self.isVisible != isVisible) {
            self.isVisible = isVisible
            if (isVisible) {
                if (self.didRejectUpdate) {
                    self.refreshPreviews(originSelectedIndex: nil)
                }
            } else {
                self.didRejectUpdate = false
            }
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
        self.setVisible(false)
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
        let scenePath = self.scenePath(index: indexPath.row)
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: scenePath)
        cell.textLabel?.text = String(String(indexPath.row + 1))
        cell.backgroundColor = Theme.bgGray
        self.setupCellInner(cell: cell, index: indexPath.row, isHighligh: indexPath.row == self.sceneIndex)
        return cell
    }
    
    func setupCellInner(cell: UITableViewCell, index: Int, isHighligh: Bool) -> Void {
        let subviewTag = 100
        var sceneImage: UIImageView? = cell.viewWithTag(subviewTag) as? UIImageView
        
        if sceneImage == nil {
            sceneImage = UIImageView()
            cell.addSubview(sceneImage!)
            sceneImage!.backgroundColor = UIColor.white
            sceneImage!.contentMode = .scaleAspectFit
            sceneImage!.tag = subviewTag
            sceneImage!.snp.makeConstraints { (make) -> Void in
                make.size.equalTo(CGSize(width: 192, height: 108))
                make.center.equalTo(cell)
            }
        }
        sceneImage!.image = self.scenePreviews[index]
        cell.backgroundColor = isHighligh ? Theme.mainGrayLight : Theme.bgGray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scenes.count;
    }
    
    //cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 160
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.room?.setScenePath(self.scenePath(index: indexPath.row))
    }
    
    func scenePath(index: Int) -> String {
        let pattern = #"/$"#
        let sceneName = self.scenes[index].name
        
        if self.sceneDirectory.range(of: pattern, options: .regularExpression) != nil {
            return self.sceneDirectory + sceneName
        } else {
            return self.sceneDirectory + "/" + sceneName
        }
    }
}
