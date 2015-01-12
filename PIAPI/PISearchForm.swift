//
//  PISearchForm.swift
//  PIAPI
//
//  Created by Erwan Loisant on 25/11/14.
//  Copyright (c) 2014 Zengularity. All rights reserved.
//

import Foundation

class PISearchForm {
    let api: PIAPI
    let form: PIForm
    let data: Dictionary<String, Array<String>>
    
    init(api: PIAPI, form: PIForm, data: Dictionary<String, Array<String>>) {
        self.api = api
        self.form = form
        self.data = data
    }
    
}

/**
* Paginated response to a Prismic.io query. Note that you may not get all documents in the first page,
* and may need to retrieve more pages or increase the page size.
*/
struct PIResponse {
    let results: Array<PIDocument>
    let page: Int
    let resultsPerPage: Int
    let resultsSize: Int
    let totalResultsSize: Int
    let totalPages: Int
    let nextPage: String?
    let prevPage: String?

    static func fromJson(json: JSON) -> PIResponse {
        return PIResponse(
            results: json["results"].arrayValue!.map { PIDocument.parseJson($0) },
            page: json["page"].integerValue!,
            resultsPerPage: json["results_per_page"].integerValue!,
            resultsSize: json["results_size"].integerValue!,
            totalResultsSize: json["total_results_size"].integerValue!,
            totalPages: json["total_pages"].integerValue!,
            nextPage: json["next_page"].stringValue?,
            prevPage: json["prev_page"].stringValue?
        )
    }

}
