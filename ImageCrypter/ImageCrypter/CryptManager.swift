//
//  CryptManager.swift
//  ImageCrypter
//
//  Created by Igor Khomich on 11.02.2020.
//  Copyright © 2020 Igor Khomich. All rights reserved.
//

import Foundation
import UIKit
import CryptoKit

public protocol CryptManagerProtocol {
    func encrypt(image: UIImage, completion: @escaping (Result<Data, Error>) -> Void)
    func decrypt(data: Data, completion: @escaping (Result<UIImage, Error>) -> Void)
}

public class CryptManager: CryptManagerProtocol {

    private let keyManager: KeyManager
    
    public init(login: String) {
        keyManager = KeyManager(keyTagName: login)
    }
    
    public func encrypt(image: UIImage, completion: @escaping (Result<Data, Error>) -> Void){
        guard let key = keyManager.getKey() else {
            completion(.failure(ICError.canNotGenerateSecuredKey))
            return
        }

        guard let data = image.pngData() else {
            completion(.failure(ICError.imageCorrupted))
            return
        }
        
        do {
            let encryptedData = try ChaChaPoly.seal(data, using: key)
            completion(.success(encryptedData.combined))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func decrypt(data: Data, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let key = keyManager.getKey() else {
            completion(.failure(ICError.canNotGenerateSecuredKey))
            return
        }
        do {
            let sealedBox = try ChaChaPoly.SealedBox(combined: data)
            let decryptedData = try ChaChaPoly.open(sealedBox, using: key)
            guard let image = UIImage(data: decryptedData) else {
                completion(.failure(ICError.decryptedDataIsNotAnImage))
                return
            }
            completion(.success(image))
        } catch {
            completion(.failure(ICError.dataCanNotBeDecrypted))
        }
    }
    
}
