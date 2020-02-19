import Foundation
import UIKit
import ImageCrypter
import ImagesCache

class ItemsListInteractor {
    weak var presenter: ItemsListInteractorToPresenterInterface!
        
    let configs = DefaultConfigs()
    let cacheManager = CacheManager.defaultCacheManager()

    let cryptManager: CryptManager
    
    init() {
        cryptManager = CryptManager(login: configs.cryptLogin)
    }
    
}

// MARK: - ENCRYPTOR
extension ItemsListInteractor {
    
    func decryptDataAndConvertToImage(_ data: Data, completion: @escaping (UIImage) -> ()) {
        cryptManager.decrypt(data: data) { result in
            
            let resultImage: UIImage
            switch result {
            case .success(let image):
                resultImage = image
            case .failure(let error):
                print("DECRYPTION ERROR: \(error.localizedDescription)")
                resultImage = #imageLiteral(resourceName: "lock")
            }
            
            completion(resultImage)
        }
    }
    
    func encrypt(image: UIImage, completion: @escaping (Data) -> ()) {
        cryptManager.encrypt(image: image) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("ENCRYPTION ERROR: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Presenter To Interactor Interface
extension ItemsListInteractor: ItemsListPresenterToInteractorInterface {
    
    func getItemsList() {
        if let list = cacheManager.getAllNames() {
            presenter.itemsLoaded(items: list)
        }
    }
    
    
    func backupNewImage(_ image: UIImage) {
        encrypt(image: image) { [unowned self] data in
            self.cacheManager.save(data: data, name: String(image.hash))
            self.getItemsList()
        }
    }
    
    func imageForItem(item: String, completion: @escaping (UIImage) -> ()) {
        if let cachedData = cacheManager.readData(name: item) {
            self.decryptDataAndConvertToImage(cachedData, completion: completion)
            return
        }
        
        completion(#imageLiteral(resourceName: "cross"))
    }
}

// MARK: - Communication Interfaces
// VIPER Interface for communication from Interactor -> Presenter
protocol ItemsListInteractorToPresenterInterface: class {
    func itemsLoaded(items: [String])
}

