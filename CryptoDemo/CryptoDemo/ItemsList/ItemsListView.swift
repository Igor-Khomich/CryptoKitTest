import UIKit

class ItemsListView: UIViewController {
    var presenter: ItemsListViewToPresenterInterface!
    
    var refresher:UIRefreshControl!
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        listCollectionView.alwaysBounceVertical = true
        refresher.tintColor = .lightGray
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        listCollectionView.addSubview(refresher)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()

    }
    
    @IBAction func backupNewImage(_ sender: Any) {
        presenter.showPhotoAlbum(in: self)
    }
    
    @objc func loadData() {
        refresher.beginRefreshing()
        presenter.loadItems()
     }
}

extension ItemsListView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        //TODO: @IGK fix orientation
        if let image = info[.originalImage] as? UIImage  {
            presenter.backupNewImage(image)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ItemsListView: UICollectionViewDelegate {
    
}

extension ItemsListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseCellIdentifier,
                                                      for: indexPath)
        if let cell = cell as? ItemCell {
            cell.startLoading()
            presenter.imageForItem(at: indexPath.row, completion: cell.imageLoaded(_:))
        }
        return cell
    }
}

extension ItemsListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
}

// MARK: - Navigation Interface
extension ItemsListView: ItemsListNavigationInterface { }

// MARK: - Presenter to View Interface
extension ItemsListView: ItemsListPresenterToViewInterface {
    func itemsReady() {
        DispatchQueue.main.async {
            self.listCollectionView.setContentOffset(.zero, animated: true)
            self.listCollectionView.reloadData()
            self.refresher.endRefreshing()
        }
    }
}

// MARK: - Communication Interfaces
// VIPER Interface for communication from View -> Presenter
protocol ItemsListViewToPresenterInterface: class {
    var itemsCount: Int { get }
    func imageForItem(at index: Int, completion: @escaping (UIImage) -> ())
    func loadItems()
    func backupNewImage(_ image: UIImage)
    func showPhotoAlbum(in context: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate )
}
