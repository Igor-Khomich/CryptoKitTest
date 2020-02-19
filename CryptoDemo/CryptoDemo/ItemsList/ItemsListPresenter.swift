import Foundation
import ImageCrypter
import UIKit

class ItemsListPresenter {
        // MARK: - VIPER Stack
        var interactor: ItemsListPresenterToInteractorInterface!
        weak var view: ItemsListPresenterToViewInterface!
        var wireframe: ItemsListPresenterToWireframeInterface!

        // MARK: - Instance Variables
        weak var delegate: ItemsListDelegate?
        var moduleWireframe: ItemsList {
                get {
                        let mw = (self.wireframe as? ItemsList)!
                        return mw
                }
        }

        var items: [String] = []
        
        // MARK: - Operational

}

// MARK: - Interactor to Presenter Interface
extension ItemsListPresenter: ItemsListInteractorToPresenterInterface {
    func itemsLoaded(items: [String]) {
        self.items = items
        view.itemsReady()
    }
}

// MARK: - View to Presenter Interface
extension ItemsListPresenter: ItemsListViewToPresenterInterface {
    
    func backupNewImage(_ image: UIImage) {
        interactor.backupNewImage(image)
    }
    
    func loadItems() {
        interactor.getItemsList()
    }
    
    var itemsCount: Int {
        return items.count
    }
    
    func imageForItem(at index: Int, completion: @escaping (UIImage) -> ()) {
        if index < itemsCount {
            interactor.imageForItem(item: items[index], completion: completion)
        }
    }
    
    func showPhotoAlbum(in context: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate ) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = context
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false

            context.present(imagePicker, animated: true, completion: nil)
        }
    }
}

// MARK: - Wireframe to Presenter Interface
extension ItemsListPresenter: ItemsListWireframeToPresenterInterface {
        func set(delegate newDelegate: ItemsListDelegate?) {
                delegate = newDelegate
        }
}

// MARK: - Communication Interfaces
// VIPER Interface to the Module
protocol ItemsListDelegate: class {

}

// VIPER Interface for communication from Presenter to Interactor
protocol ItemsListPresenterToInteractorInterface: class {
    func imageForItem(item: String, completion: @escaping (UIImage) -> ())
    func getItemsList()
    func backupNewImage(_ image: UIImage)
}

// VIPER Interface for communication from Presenter -> Wireframe
protocol ItemsListPresenterToWireframeInterface: class {

}

// VIPER Interface for communication from Presenter -> View
protocol ItemsListPresenterToViewInterface: class {
    func itemsReady()
}
