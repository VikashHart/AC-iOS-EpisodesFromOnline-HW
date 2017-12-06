//
//  EpisodeAPIClient.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by C4Q on 12/4/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct EpisodesAPIClient {
    private init() {}
    static let manager = EpisodesAPIClient()
    func getEpisodes(from urlStr: String, completionHandler: @escaping ([Episode]) -> Void, errorHandler: @escaping (AppError) ->Void) {
        guard let url = URL(string: urlStr) else { return }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let episodes = try JSONDecoder().decode([Episode].self, from: data)
                completionHandler(episodes)
            } catch {
                errorHandler(.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
    
}
