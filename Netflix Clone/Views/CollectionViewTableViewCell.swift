//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by ADMIN on 15/11/2022.
//

import UIKit

protocol CollectionViewCellTableViewCellDelegate: AnyObject{
    func collectionViewTableViewCellDidTapCell(_ cell:CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

 
    static let identifier = "CollectionViewTableViewCell"
    private var titles: [Any] = [Any]()
    
    
    weak var delegate:CollectionViewCellTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Any]){
        self.titles = titles
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    
    private func donwloadTitleAt(indexPath: IndexPath){
        // downcast here
        
        if titles is [Movie]{
            if let allTitles = titles as? [Movie]{
                DataPersistenceManager.shared.downloadTitle(with: allTitles[indexPath.row]){ result in
                    switch result{
                    case .success():                        NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
                        case .failure (let error):
                            print (error.localizedDescription)
                        }
                }
                //print("Downloading",  allTitles[indexPath.row].original_title ?? "Unknown")
            }
        }
        
        if titles is [Tv]{
            if let allTitles = titles as? [Tv]{
                print("Downloading", allTitles[indexPath.row].original_title ?? "Unknown")
            }
        }
        
        if titles is [UpcomingMovie]{
            if let allTitles = titles as? [UpcomingMovie]{
                print("Downloading", allTitles[indexPath.row].original_title ?? "Unknown")
            }
        }
        
        
    }
    
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = .green
//        return cell
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{return UICollectionViewCell()}
        // to conditionally configure the cell based on the type returned from the Movie and TV models
        
        if titles is [Movie]{
            if let allTitles = titles as? [Movie]{
                guard let model = allTitles[indexPath.row].poster_path else{return UICollectionViewCell()}
                cell.configure(with: model)
                return cell
            }
        }
        
        if titles is [Tv]{
            if let allTitles = titles as? [Tv]{
                guard let model = allTitles[indexPath.row].poster_path else{return UICollectionViewCell()}
                cell.configure(with: model)
                return cell
            }
        }
        
        if titles is [UpcomingMovie]{
            if let allTitles = titles as? [UpcomingMovie]{
                guard let model = allTitles[indexPath.row].poster_path else{return UICollectionViewCell()}
                cell.configure(with: model)
                return cell
            }
        }
        return UICollectionViewCell()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if titles is [Movie]{
            if let allTitles = titles as? [Movie]{
                guard let titleName = allTitles[indexPath.row].original_title else{return}
                APICaller.shared.getMovie(with: titleName + " trailer"){ [weak self] result in
                    switch result{
                    case .success(let videoElement):
                        //print(videoElement.id)
                        guard let strongSelf = self else{return}
                        let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: allTitles[indexPath.row].overview ?? "Unknown")
                        self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf , viewModel: viewModel )
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        if titles is [Tv]{
            if let allTitles = titles as? [Tv]{
                guard let titleName = allTitles[indexPath.row].original_title else{return}
                APICaller.shared.getMovie(with: titleName + " trailer"){ [weak self] result in
                    switch result{
                    case .success(let videoElement):
                        //print(videoElement.id)
                        guard let strongSelf = self else{return}
                        let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: allTitles[indexPath.row].overview ?? "Unknown")
                        self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf , viewModel: viewModel )
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        if titles is [UpcomingMovie]{
            if let allTitles = titles as? [UpcomingMovie]{
                guard let titleName = allTitles[indexPath.row].original_title else{return}
                APICaller.shared.getMovie(with: titleName + " trailer"){ [weak self] result in
                    switch result{
                    case .success(let videoElement):
                        //print(videoElement.id)
                        guard let strongSelf = self else{return}
                        let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: allTitles[indexPath.row].overview ?? "Unknown")
                        self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf , viewModel: viewModel )
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
        identifier: nil,
        previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download",subtitle: nil, image: nil, identifier: nil , discoverabilityTitle: nil, state: .off){[weak self]
                _ in
                self?.donwloadTitleAt(indexPath: indexPath)
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        
        return config
    }
    
    
    
}
