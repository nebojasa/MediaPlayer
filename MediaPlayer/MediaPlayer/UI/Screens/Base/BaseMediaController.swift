//
//  BaseMediaController.swift
//  MediaPlayer
//
//  Created by Christopher Webb-Orenstein on 5/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class TrackItemsFlowLayout: UICollectionViewFlowLayout {
    
    func setup() {
        scrollDirection = .vertical
        itemSize = CGSize(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 4.5)
        sectionInset = UIEdgeInsets(top: 20, left: 25, bottom: 30, right: 25)
        minimumLineSpacing = 25
    }
}

public class BaseMediaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    weak var delegate: MediaViewControllerDelegate?
    
    var dataSource: BaseMediaControllerDataSource
    
    init(dataSource: BaseMediaControllerDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.addSubview(collectionView)
        collectionView.setupCollectionView(view: view, newLayout: TrackItemsFlowLayout())
        collectionView.collectionViewRegister(viewController: self)
        self.getData()
    }
    
    
    func getData() {
        dataSource.store.searchTerm = "new"
        dataSource.store.searchForTracks { playlist, error in
            self.dataSource.playlist = playlist
            DispatchQueue.main.async {
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let playlist = dataSource.playlist else { return }
        delegate?.didSelectPlaylistItem(at: indexPath.row, for: playlist)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MediaCell
        if let playlistItem = dataSource.playlist?.playlistItem(at: indexPath.row),
            let track = playlistItem.track,
            let name = track.trackName,
            let urlString = track.artworkUrl,
            let url = URL(string: urlString) {
            let model = MediaCellViewModel(trackName: name, albumImageURL: url)
            cell.configureCell(with: model, withTime: 0)
        }
        cell.alpha = 1
        return cell
    }
    
}