//
//  Form.swift
//  PIAPI
//
//  Created by Erwan Loisant on 24/11/14.
//  Copyright (c) 2014 Zengularity. All rights reserved.
//

import Foundation


struct PIField {
    let type: String
    let multiple: Bool
    let defaultValue: String?

    init(type: String, multiple: Bool, defaultValue: String?) {
        self.type = type
        self.multiple = multiple
        self.defaultValue = defaultValue
    }
    
    static func parseJson(json: JSON) -> PIField {
        return PIField(type: json["type"].stringValue!, multiple: json["type"].boolValue, defaultValue: json["default"].stringValue)
    }
}


struct PIForm {
    let name: String?
    let method: String
    let rel: String?
    let enctype: String
    let action: String
    let fields: Dictionary<String, PIField>

    init(name: String?, method: String, rel: String?, enctype: String, action: String, fields: Dictionary<String, PIField>) {
        self.name = name
        self.method = method
        self.rel = rel
        self.enctype = enctype
        self.action = action
        self.fields = fields
    }
    
    func defaultData() -> Dictionary<String, Array<String>> {
        return fields.filter { (name: String, field: PIField) -> Bool in field.defaultValue != nil }
              .mapValues { [$0.defaultValue!] }
    }

    static func parseJson(json: JSON) -> PIForm {
        return PIForm(
            name: json["name"].stringValue?,
            method: json["method"].stringValue!,
            rel: json["rel"].stringValue?,
            enctype: json["enctype"].stringValue!,
            action: json["action"].stringValue!,
            fields: json["fields"].dictionaryValue?.mapValues{PIField.parseJson($0)} ?? Dictionary<String, PIField>()
        )
    }
    
}

