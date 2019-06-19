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
let token = "WHITEcGFydG5lcl9pZD0zZHlaZ1BwWUtwWVN2VDVmNGQ4UGI2M2djVGhncENIOXBBeTcmc2lnPTc1MTBkOWEwNzM1ZjA2MDYwMTMzODBkYjVlNTQ2NDA0OTAzOWU2NjE6YWRtaW5JZD0xNTgmcm9sZT1taW5pJmV4cGlyZV90aW1lPTE1OTAwNzM1NjEmYWs9M2R5WmdQcFlLcFlTdlQ1ZjRkOFBiNjNnY1RoZ3BDSDlwQXk3JmNyZWF0ZV90aW1lPTE1NTg1MTY2MDkmbm9uY2U9MTU1ODUxNjYwODYxNzAw"
let baseUrl = "https://cloudcapiv4.herewhite.com"
let headers: HTTPHeaders = [
    "Accept": "application/json"
]
class ApiMiddleWare {

    static func createRoom(name: String, limit: Int, room: RoomType, callBack: @escaping (_ uuid: String, _ roomToken: String) -> Void) -> Void {
        AF.request("\(baseUrl)/room?token=\(token)", method: .post,
                   parameters: ["name": name, "limit": limit, "mode": room],
                   headers: headers).responseJSON { response in
                    if let result = response.value {
                        let json = JSON(result)
                        print(result)
                        print("room:\(json["msg"]["room"]["uuid"])")
                        let uuid = json["msg"]["room"]["uuid"].string!
                        let roomToken = json["msg"]["roomToken"].string!
                        callBack(uuid, roomToken)
//                        callBack(json["msg"]["room"]["uuid"], json["msg"]["roomToken"])
                    }
//                   print("Result: \(response.result["msg"]["roomToken"])")
        }
        
    }
}
