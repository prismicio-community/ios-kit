//
//  Experiments.swift
//  PIAPI
//
//  Created by Erwan Loisant on 24/11/14.
//  Copyright (c) 2014 Zengularity. All rights reserved.
//

import Foundation

struct PIVariation {
    let id: String
    let ref: String
    let label: String
    
    init(id: String, ref: String, label: String) {
        self.id = id
        self.ref = ref
        self.label = label
    }
    
    static func parseJson(json: JSON) -> PIVariation {
        return PIVariation(id: json["id"].stringValue!, ref: json["ref"].stringValue!, label: json["label"].stringValue!)
    }
    
}

struct PIExperiment {
    let id: String
    let googleId: String
    let name: String
    let variations: Array<PIVariation>

    init(id: String, googleId: String, name: String, variations: Array<PIVariation>) {
        self.id = id
        self.googleId = googleId
        self.name = name
        self.variations = variations
    }

    static func parseJson(json: JSON) -> PIExperiment {
        return PIExperiment(
            id: json["id"].stringValue!,
            googleId: json["googleId"].stringValue!,
            name: json["name"].stringValue!,
            variations: json["variations"].arrayValue?.map { PIVariation.parseJson($0) } ?? []
        )
    }
    
}

struct PIExperiments {
    let draft: Array<PIExperiment>
    let running: Array<PIExperiment>
    
    init(draft: Array<PIExperiment>, running: Array<PIExperiment>) {
        self.draft = draft
        self.running = running
    }
    
    func current() -> PIExperiment? {
        return self.running.first
    }

    static func parseJson(json: JSON) -> PIExperiments {
        return PIExperiments(
            draft: json["draft"].arrayValue?.map { PIExperiment.parseJson($0) } ?? [],
            running: json["running"].arrayValue?.map { PIExperiment.parseJson($0) } ?? []
        )
    }
    
}

