

import UIKit

class ListCell: UITableViewCell {
    
    static let identifier = "ListCell"
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemSubTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configure(with item: ListItem) {
        itemImageView.image = UIImage(named: item.imageName)
        itemTitleLabel.text = item.title
        itemSubTitleLabel.text = item.subtitle
    }
    
}
