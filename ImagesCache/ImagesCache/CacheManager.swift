//
//  CacheManager.swift
//  ImagesCache
//
//  Created by Igor Khomich on 12.02.2020.
//  Copyright © 2020 Igor Khomich. All rights reserved.
//

import Foundation
import UIKit

public protocol CacheManagerProtocol {
    func save(data: Data, name: String)
    func readData(name: String) -> Data?
    func getAllNames() -> [String]?
    func removeAllFiles()
}

public class CacheManager {
    
    private let pathToDocuments: URL?
    
    public static func defaultCacheManager() -> CacheManagerProtocol {
        return CacheManager()
    }
    
    init() {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let path = paths.first {
            pathToDocuments = URL(fileURLWithPath: path).appendingPathComponent("IMAGECACHES")
            self.createCacheDirectory()
        } else {
            pathToDocuments = nil
        }
    }
    
    private func createCacheDirectory() {
        if let pathToDocuments = pathToDocuments, !FileManager.default.fileExists(atPath: pathToDocuments.path) {
            do {
                try FileManager.default.createDirectory(atPath: pathToDocuments.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
    }
}

extension CacheManager: CacheManagerProtocol {
    
    public func save(data: Data, name: String) {

        guard let pathToDocuments = pathToDocuments else {
            return
        }
        
        let fileURL = pathToDocuments.appendingPathComponent(name)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                //do nothing
            }
        }
       
        do {
            try data.write(to: fileURL)
        } catch {
            //do nothing
        }
    }

    public func readData(name: String) -> Data? {

        if let pathToDocuments = pathToDocuments {
            let dataUrl = pathToDocuments.appendingPathComponent(name)
            let data = try? Data(contentsOf: dataUrl)
            return data
        }

        return nil
    }
    
    public func getAllNames() -> [String]? {
        if let pathToDocuments = pathToDocuments {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: pathToDocuments, includingPropertiesForKeys: nil)
                
                let fileNames = directoryContents.map({
                    $0.lastPathComponent
                })

                return fileNames

            } catch {
                print(error)
            }
        }
        
        return nil
    }

    public func removeAllFiles() {
        if let pathToDocuments = pathToDocuments {
            do {
                try  FileManager.default.removeItem(at: pathToDocuments)
                createCacheDirectory()
            } catch {
                //do nothing
            }
        }
    }
}
