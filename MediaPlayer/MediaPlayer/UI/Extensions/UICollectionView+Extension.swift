import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ :T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not deque cell")
        }
        return cell
    }
    
    func tetherToController(controller: UIViewController) {
        self.dataSource = controller as? UICollectionViewDataSource
        self.delegate = controller as? UICollectionViewDelegate
    }
    
    func setup(with newLayout: TrackItemsFlowLayout) {
        newLayout.setup()
        collectionViewLayout = newLayout
        frame = UIScreen.main.bounds
    }
    
    func collectionViewRegister(viewController: UIViewController) {
        register(MediaCell.self)
        tetherToController(controller: viewController)
    }
    
    func setupCollectionView(view: UIView, newLayout: TrackItemsFlowLayout) {
        setup(with: newLayout)
        frame = UIScreen.main.bounds
        backgroundColor = .white
        //  guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else { return }
        contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
}


