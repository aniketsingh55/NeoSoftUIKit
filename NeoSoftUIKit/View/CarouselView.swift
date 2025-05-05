

import UIKit

protocol CarouselViewDelegate: AnyObject {
    func carouselView(_ carouselView: CarouselView, didScrollTo index: Int)
}

protocol SearchDelegate: AnyObject {
    func searchQuery(query: String)
}

class CarouselView: UIView,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var CollectionViewCarousel: UICollectionView!
    @IBOutlet weak var PageControl: UIPageControl!
    @IBOutlet weak var searchBar: UISearchBar!
    var images: [ImageItem] = []
    weak var delegateCarouselView: CarouselViewDelegate?
    weak var delegateSearch: SearchDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CollectionViewCarousel.dataSource = self
        CollectionViewCarousel.delegate = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.makeTransparent()
        
        CollectionViewCarousel.register(UINib(nibName: "CarouselCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCell")
        
        CollectionViewCarousel.isPagingEnabled = true
        CollectionViewCarousel.showsHorizontalScrollIndicator = false
    }
    
    class func loadFromNib() -> CarouselView {
        let nib = UINib(nibName: "CarouselView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! CarouselView
    }
    
    
    func configure(with items: [ImageItem]) {
        images = items
        print(images.count)
        PageControl.numberOfPages = items.count
        PageControl.currentPage = 0
        CollectionViewCarousel.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        cell.configure(with: images[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        PageControl.currentPage = page
        delegateCarouselView?.carouselView(self, didScrollTo: page)
    }
    func scrollToPage(_ index: Int) {
        guard index >= 0 && index < images.count else { return }
        let indexPath = IndexPath(item: index, section: 0)
        CollectionViewCarousel.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        PageControl.currentPage = index
    }

}

extension CarouselView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegateSearch?.searchQuery(query: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension UISearchBar {
    func makeTransparent() {
        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        setSearchFieldBackgroundImage(UIImage(), for: .normal)
        backgroundImage = UIImage()
        if let textField = value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .clear
        }
        showsCancelButton = true
    }
}
