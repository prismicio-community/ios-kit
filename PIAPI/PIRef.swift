//
//  Ref.swift
//  PIAPI
//
//  Created by Erwan Loisant on 24/11/14.
//  Copyright (c) 2014 Zengularity. All rights reserved.
//

import Foundation

struct PIRef {
    let id: String
    let ref: String
    let label: String
    let isMasterRef: Bool
    let scheduledAt: NSDate?
    
    init(id: String, ref: String, label: String, isMasterRef: Bool, scheduledAt: NSDate?) {
        self.id = id
        self.ref = ref
        self.label = label
        self.isMasterRef = isMasterRef
        self.scheduledAt = scheduledAt
    }
    
    static func parseJson(json: JSON) -> PIRef {
        return PIRef(
            id: json["id"].stringValue!,
            ref: json["ref"].stringValue!,
            label: json["label"].stringValue!,
            isMasterRef: json["isMasterRef"].boolValue ?? false,
            scheduledAt: json["scheduledAt"].dateValue?
        )
    }
    
}