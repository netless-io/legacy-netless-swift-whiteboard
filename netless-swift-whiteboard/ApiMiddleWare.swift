//
//  ApiMiddleWare.swift
//  netless-swift-whiteboard
//
//  Created by 伍双 on 2019/6/18.
//  Copyright © 2019 伍双. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum RoomType: String {
    case transitory = "transitory"
    case persisten = "persisten"
    case historied = "historied"
}
let token = "WHITEcGFydG5lcl9pZD1OZ3pwQWNBdlhiemJERW9NY0E0Z0V3RTUwbVZxM0NIbDJYV0Ymc2lnPWNiZWExOTMwNzc1NmQyNmU3N2U3M2Q0NWZjNTZiOGIwMWE2ZjU4NDI6YWRtaW5JZD0yMTYmcm9sZT1hZG1pbiZleHBpcmVfdGltZT0xNTg5ODMzNTQxJmFrPU5nenBBY0F2WGJ6YkRFb01jQTRnRXdFNTBtVnEzQ0hsMlhXRiZjcmVhdGVfdGltZT0xNTU4Mjc2NTg5Jm5vbmNlPTE1NTgyNzY1ODg4NDQwMA"
let baseUrl = "https://cloudcapiv4.herewhite.com"
let headers: HTTPHeaders = [
    "Accept": "application/json"
]
class ApiMiddleWare {

    static func createRoom(name: String, limit: Int, room: RoomType, callBack: @escaping (_ uuid: String, _ roomToken: String) -> Void) -> Void {
    
        let url = "\(baseUrl)/room?token=\(token)"
        let parameters: [String: Any] = ["name": name, "limit": limit, "mode": room]
        let request = AF.request(url, method: .post, parameters:parameters , headers: headers)
        
        request.responseJSON { response in
            if let result = response.value {
                let json = JSON(result)
                let uuid = json["msg"]["room"]["uuid"].string!
                let roomToken = json["msg"]["roomToken"].string!
                callBack(uuid, roomToken)
            }
        }
    }
    
    static func joinRoom(uuid: String, callback: @escaping (_ roomToken: String) -> Void) -> Void {
        let url = "\(baseUrl)/room/join?uuid=\(uuid)&token=\(token)"
        let request = AF.request(url, method: .post, parameters:nil , headers: headers)
        
        request.responseJSON { response in
            if let result = response.value {
                let json = JSON(result)
                let roomToken = json["msg"]["roomToken"].string!
                callback(roomToken)
            }
        }
    }
}
