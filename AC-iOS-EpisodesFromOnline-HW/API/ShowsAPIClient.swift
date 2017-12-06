//
//  ShowsAPIClient.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by C4Q on 12/4/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


struct ShowsAPIClient {
    private init() {}
    static let manager = ShowsAPIClient()
    func getShows(from urlStr: String, completionHandler: @escaping ([ShowInfo]) -> Void, errorHandler: @escaping (AppError) ->Void) {
        guard let url = URL(string: urlStr) else { return }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let shows = try JSONDecoder().decode([ShowInfo].self, from: data)
                completionHandler(shows)
            } catch {
                errorHandler(.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
    
}
