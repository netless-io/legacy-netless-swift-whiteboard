//
//  PPTPreviewViewController.swift
//  netless-swift-whiteboard
//
//  Created by TaoZeyu on 2019/7/9.
//  Copyright © 2019 伍双. All rights reserved.
//
import UIKit

struct PPTData {
    let id: Int
    let preview: String
}

let PPTDatas: Array<PPTData> = [
    PPTData(id: 1, preview: "img_ppt1"),
    PPTData(id: 2, preview: "img_ppt2"),
    PPTData(id: 3, preview: "img_ppt3"),
    PPTData(id: 4, preview: "img_ppt4"),
    PPTData(id: 5, preview: "img_ppt5")
]

class PPTPreviewViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    public var room: WhiteRoom?
    private var tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "演示文档"
        
        if let nav = self.navigationController?.navigationBar {
            nav.barStyle = UIBarStyle.black
            nav.barTintColor = Theme.mainColor
            nav.tintColor = UIColor.white
        }
        self.view.backgroundColor = Theme.bgGray
        
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let leftBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(clickGoBack))
        
        self.navigationItem.leftBarButtonItem = leftBtn
        self.view.addSubview(tableView)
    }
    
    @objc func clickGoBack() {
        self.dismiss(animated: true, completion: nil);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subviewTag = 100
        let data = PPTDatas[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: String(indexPath.row))
        cell.backgroundColor = Theme.bgGray
        
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
        sceneImage!.image = UIImage(named: data.preview)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PPTDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 160
    }
}
