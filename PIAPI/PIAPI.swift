//
//  PIAPI.swift
//  PIAPI
//
//  Created by Erwan Loisant on 24/11/14.
//  Copyright (c) 2014 Zengularity. All rights reserved.
//

import Foundation

class PIAPI {
    let data: PIAPIData
    let accessToken: String?
    //let cache: Cache
    //let logger: Logger

    init(data: PIAPIData, accessToken: String?) {
        self.data = data
        self.accessToken = accessToken
    }

    func refs() -> Dictionary<String, PIRef> {
        return self.data.refs.groupBy { $0.label }.mapValues { $0.first! }
    }
    
    func bookmarks() -> Dictionary<String, String> {
        return data.bookmarks
    }
    
    func forms() -> Dictionary<String, PISearchForm> {
        return self.data.forms.mapValues { (form: PIForm) -> PISearchForm in
            PISearchForm(api: self, form: form, data: form.defaultData()) }
    }
    
    func master() -> PIRef {
        return self.data.refs.filter { $0.isMasterRef }.first!
    }
    
    /**
    * Experiments exposed by prismic.io API
    */
    func experiments() -> PIExperiments {
        return self.data.experiments
    }
    
    /**
    * Shortcut to the current running experiment, if any
    */
    func experiment() -> PIExperiment? {
        return self.experiments().current()
    }
    
    class func get(
            endpoint: String,
            accessToken: String? = nil,
            completionHandler: ((PIAPI!, NSError!) -> Void))
    {
        let url = NSURL(string: endpoint)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            let body = NSString(data: data, encoding: NSUTF8StringEncoding)
            if (error != nil) {
                // TODO: Generate PIError
            } else {
                var err: NSError?
                completionHandler(PIAPI(data: PIAPIData.parseJson(JSON(object: body!)), accessToken: accessToken), nil)
            }
        }
    }
    
}

class PIAPIData {
    let refs: Array<PIRef>
    let bookmarks: Dictionary<String, String>
    let types: Dictionary<String, String>
    let tags: Array<String>
    let forms: Dictionary<String, PIForm>
    let experiments: PIExperiments

    init(refs: Array<PIRef>,
        bookmarks: [String: String],
        types: [String: String],
        tags: [String],
        forms: [String: PIForm],
        experiments: PIExperiments)
    {
        self.refs = refs
        self.bookmarks = bookmarks
        self.types = types
        self.tags = tags
        self.forms = forms
        self.experiments = experiments
    }

    class func parseJson(json: JSON) -> PIAPIData {
        let refs = json["refs"].arrayValue?.map { PIRef.parseJson($0) } ?? []
        let bookmarks: Dictionary<String, String> = (json["bookmarks"].dictionaryValue?.mapValues { $0.stringValue! }) ?? Dictionary<String, String>()
        let types = (json["types"].dictionaryValue?.mapValues { $0.stringValue! }) ?? Dictionary<String, String>()
        let tags: Array<String> = (json["tags"].arrayValue?.map { $0.stringValue! }) ?? []
        let forms = json["forms"].dictionaryValue?.mapValues { PIForm.parseJson($0) } ?? Dictionary<String, PIForm>()
        let experiments: PIExperiments = PIExperiments.parseJson(json["experiments"])
        return PIAPIData(
            refs: refs,
            bookmarks: bookmarks,
            types: types,
            tags: tags,
            forms: forms,
            experiments: experiments
        )
    }
    
}

extension Dictionary {

    func mapValues<U> (transform: Value -> U) -> [Key: U] {
        var result = [Key: U]()
        for (key, value) in self {
            result[key] = transform(value)
        }
        return result
    }
    
    func filter(f: Element -> Bool) -> [Key: Value] {
        var result = [Key: Value]()
        for elt: Element in self {
            if (f(elt)) {
                result[elt.0] = elt.1
            }
        }
        return result
    }

    func has (key: Key) -> Bool {
        return indexForKey(key) != nil
    }

}

extension Array {

    func groupBy<U> (f: (Element) -> U) -> [U: Array] {
        var result = [U: Array]()
        for item in self {
            let groupKey: U = f(item)
            if result.has(groupKey) {
                result[groupKey]! += [item]
            } else {
                result[groupKey] = [item]
            }
        }
        return result
    }
    
}

