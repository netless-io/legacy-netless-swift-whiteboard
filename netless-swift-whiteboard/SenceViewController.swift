//
//  SenceViewController.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/15.
//  Copyright © 2019 伍双. All rights reserved.
//

import UIKit

class SenceViewController: UIViewController {
    var tableView = UITableView()
    var dataArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部页面"
        let superview = self.view!
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.barTintColor = Theme.mainColor
        nav?.tintColor = UIColor.white
        superview.backgroundColor = Theme.bgGray
        dataArr = ["1","2","3","4","5","6","7","8","9","10"]
        setUpSence(superview: superview)
        setUpLeftBtn(superview: superview)
        
        // 1.创建tableView,并添加的控制器的view
        tableView = UITableView(frame: view.bounds)
        
        // 2.设置数据源代理
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        // 3.添加到控制器的view
        self.view.addSubview(tableView)
        
    }
    
    func setUpLeftBtn(superview: UIView) -> Void {
        let leftBtn = UIBarButtonItem(title: "加一页", style: .plain, target: self, action: nil)
        let rightBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(goToWhiteboard))
        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    @objc func goToWhiteboard() -> Void {
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func addSence() -> Void {
        
    }
    
    func setUpSence(superview: UIView) -> Void {
        let sence = UIView();
        sence.backgroundColor = UIColor.red
        superview.addSubview(sence)
        sence.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 240, height: 160))
            make.centerYWithinMargins.equalTo(120)
            make.centerX.equalTo(superview)
        }
    }
}

extension SenceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell";
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellID)
        cell.textLabel?.text = String(dataArr[indexPath.row] as! String)
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
        return dataArr.count;
    }
    
    
    
    //cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 160
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了\(indexPath.row)")
    }
    
}
