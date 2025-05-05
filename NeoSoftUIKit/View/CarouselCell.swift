

import UIKit

class CarouselCell: UICollectionViewCell {

    @IBOutlet weak var ImageCarousel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageCarousel.layer.cornerRadius = 12
    }
    
    func configure(with item: ImageItem) {
        ImageCarousel.image = UIImage(named: item.imageName)
    }

}
