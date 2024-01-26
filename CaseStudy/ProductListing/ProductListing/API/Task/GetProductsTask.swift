//
//  GetProductsTask.swift
//  ProductListing
//
//  Created by Koray Yıldız on 17.09.22.
//

import Foundation
import Networker

final class GetProductsTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String = "/bmdevel/MobileCodeChallengeResources/main/groceryProducts.json"
}
