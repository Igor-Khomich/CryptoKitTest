//
//  CacheError.swift
//  ImagesCache
//
//  Created by Igor Khomich on 12.02.2020.
//  Copyright © 2020 Igor Khomich. All rights reserved.
//

import Foundation


public enum CacheError: Error {
    case canNotFindDocumentDirectory
    case dataCorrupted
}

extension CacheError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .canNotFindDocumentDirectory:
            return NSLocalizedString(
                "can not find document directory",
                comment: ""
            )
            case .dataCorrupted:
            return NSLocalizedString(
                "data can not be procced",
                comment: ""
            )
        }
    }
}

