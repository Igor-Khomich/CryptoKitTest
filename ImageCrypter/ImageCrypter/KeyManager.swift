//
//  KeyManager.swift
//  ImageCrypter
//
//  Created by Igor Khomich on 11.02.2020.
//  Copyright © 2020 Igor Khomich. All rights reserved.
//

import Foundation
import CryptoKit



internal protocol KeyManagerProtocol {
    func getKey() -> SymmetricKey?
}

internal class KeyManager: KeyManagerProtocol {

    private let keyTagName: String
    
    init(keyTagName: String) {
        self.keyTagName = keyTagName
    }
    
    func getKey() -> SymmetricKey? {
        do {
            let key = try readKey()
            return key
        } catch ICError.keyNotExistsError {
            
            let key = createKey()
            do {
                try save(key: key)
            } catch  {
                return nil
            }
            
            return key
        } catch {
           return nil
        }
    }
    
    private func createKey() -> SymmetricKey {
        return SymmetricKey(size: .bits256)
    }
    
    private func save(key: SymmetricKey) throws {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: keyTagName,
                     kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
                     kSecUseDataProtectionKeychain: true,
                     kSecValueData: key.dataRepresentation] as [String: Any]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw ICError.keyStoreError("Unable to store item: \(status.description)")
        }
    }
    
    private func readKey() throws -> SymmetricKey {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: keyTagName,
                     kSecUseDataProtectionKeychain: true,
                     kSecReturnData: true] as [String: Any]
        
        var item: CFTypeRef?
        switch SecItemCopyMatching(query as CFDictionary, &item) {
        case errSecSuccess:
            guard let data = item as? Data else {
                throw ICError.keyStoreError("Unable to read key")
            }
            return SymmetricKey(data: data)
        case errSecItemNotFound: throw ICError.keyNotExistsError
        case let status: throw ICError.keyStoreError("Unable to store item: \(status.description)")
        }
    }
}

extension SymmetricKey {
    var dataRepresentation: Data {
        return self.withUnsafeBytes { bytes in
            let cfdata = CFDataCreateWithBytesNoCopy(nil, bytes.baseAddress?.assumingMemoryBound(to: UInt8.self), bytes.count, kCFAllocatorNull)
            return ((cfdata as NSData?) as Data?) ?? Data()
        }
    }
}
