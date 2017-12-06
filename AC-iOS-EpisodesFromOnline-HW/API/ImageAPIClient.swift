//
//  ImageAPIClient.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by C4Q on 12/4/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

struct ImageAPIClient {
    private init() {}
    static let manager = ImageAPIClient()
    func getImage(from imageUrlStr: String, completionHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (AppError) ->Void) {
        guard let url = URL(string: imageUrlStr) else { errorHandler(.badURL); return }
        let completion: (Data) -> Void = {(data: Data) in
            guard let onlineImage = UIImage(data: data) else {
                errorHandler(.notAnImage)
                return
            }
            completionHandler(onlineImage)
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
    
}
