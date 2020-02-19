import UIKit

class ItemsListWireframe {
        // MARK: - VIPER Stack
        lazy var moduleInteractor = ItemsListInteractor()
        // Uncomment to use a navigationController from storyboard
        /*
        lazy var moduleNavigationController: UINavigationController = {
                let sb = ItemsListWireframe.storyboard()
                let nc = (sb.instantiateViewController(withIdentifier: ItemsListConstants.navigationControllerIdentifier) as? UINavigationController)!
                return nc
        }()
        */
        lazy var modulePresenter = ItemsListPresenter()
        lazy var moduleView: ItemsListView = {
                // Uncomment the commented line below and delete the storyboard
                //      instantiation to use a navigationController from storyboard
                //let vc = self.moduleNavigationController.viewControllers[0] as! ItemsListView
                let sb = ItemsListWireframe.storyboard()
                let vc = (sb.instantiateViewController(withIdentifier: ItemsListConstants.viewIdentifier) as? ItemsListView)!
                _ = vc.view
                return vc
        }()

        // MARK: - Computed VIPER Variables
        lazy var presenter: ItemsListWireframeToPresenterInterface = self.modulePresenter
        lazy var view: ItemsListNavigationInterface = self.moduleView

        // MARK: - Instance Variables

        // MARK: - Initialization
        init() {
                let i = moduleInteractor
                let p = modulePresenter
                let v = moduleView

                i.presenter = p

                p.interactor = i
                p.view = v
                p.wireframe = self

                v.presenter = p
        }

    	class func storyboard() -> UIStoryboard {
                return UIStoryboard(name: ItemsListConstants.storyboardIdentifier,
                                    bundle: Bundle(for: ItemsListWireframe.self))
    	}

        // MARK: - Operational

}

// MARK: - Module Interface
extension ItemsListWireframe: ItemsList {
        var delegate: ItemsListDelegate? {
                get {
                        return presenter.delegate
                }
                set {
                        presenter.set(delegate: newValue)
                }
        }
}

// MARK: - Presenter to Wireframe Interface
extension ItemsListWireframe: ItemsListPresenterToWireframeInterface {

}

// MARK: - Communication Interfaces
// Interface Abstraction for working with the VIPER Module
protocol ItemsList: class {
        var delegate: ItemsListDelegate? { get set }
}

// VIPER Module Constants
struct ItemsListConstants {
        // Uncomment to utilize a navigation controller from storyboard
        //static let navigationControllerIdentifier = "ItemsListNavigationController"
        static let storyboardIdentifier = "ItemsList"
        static let viewIdentifier = "ItemsListView"
}

// VIPER Interface for manipulating the navigation of the view
protocol ItemsListNavigationInterface: class {

}

// VIPER Interface for communication from Wireframe -> Presenter
protocol ItemsListWireframeToPresenterInterface: class {
        var delegate: ItemsListDelegate? { get }
        func set(delegate newDelegate: ItemsListDelegate?)
}
