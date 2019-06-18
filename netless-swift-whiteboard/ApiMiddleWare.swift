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
let token = "WHITEcGFydG5lcl9pZD02OXZiZmNBNGlZcHJTUThZU3VieTBwYjJFV0hRSER6UmpOYnomc2lnPTU0YWI3NWVjOGI1NTkyYzZmZDU2YjE1YjUzNjZlYTcyMGIyZTc0OGE6YWRtaW5JZD0xMzYmcm9sZT1taW5pJmV4cGlyZV90aW1lPTE1OTI0MTgzMjAmYWs9Njl2YmZjQTRpWXByU1E4WVN1YnkwcGIyRVdIUUhEelJqTmJ6JmNyZWF0ZV90aW1lPTE1NjA4NjEzNjgmbm9uY2U9MTU2MDg2MTM2Nzc4OTAw"
let baseUrl = "https://edgecloudcapiv4.herewhite.com"
let headers: HTTPHeaders = [
    "token": token,
    "Accept": "application/json"
]
class ApiMiddleWare {

    static func createRoom(name: String, limit: Int, room: RoomType, callBack: @escaping (_ uuid: String, _ roomToken: String) -> Void) -> Void {
        AF.request("\(baseUrl)/room", method: .post,
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
