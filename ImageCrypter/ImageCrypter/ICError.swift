//
//  ICError.swift
//  ImageCrypter
//
//  Created by Igor Khomich on 11.02.2020.
//  Copyright © 2020 Igor Khomich. All rights reserved.
//

import Foundation

public enum ICError: Error {
    case keyStoreError(String)
    case keyNotExistsError
    case canNotGenerateSecuredKey
    case imageCorrupted
    case dataCanNotBeDecrypted
    case decryptedDataIsNotAnImage
    case encryptionError
}

extension ICError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .imageCorrupted:
            return NSLocalizedString(
                "can not read image",
                comment: ""
            )
            case .encryptionError:
                return NSLocalizedString(
                    "Can not encrypt data",
                    comment: ""
                )
        case .keyStoreError(let message):
             return NSLocalizedString(
                       "Can not save key: \(message)",
                       comment: ""
                   )
        case .keyNotExistsError:
            return NSLocalizedString(
                "Key not exists, create and save first",
                comment: ""
            )
        case .canNotGenerateSecuredKey:
             return NSLocalizedString(
                           "sequred key is not available and can not be created",
                           comment: ""
                       )
        case .dataCanNotBeDecrypted:
            return NSLocalizedString(
                "decryption problem, check the key",
                comment: ""
            )
        case .decryptedDataIsNotAnImage:
            return NSLocalizedString(
                "data decrypted but it's not an image",
                comment: ""
            )
        }
    }
}

