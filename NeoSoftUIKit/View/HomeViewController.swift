

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var ListTableView: UITableView!
    let viewModel = HomeViewModel()
    var carouselView = CarouselView()
    let fab = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.loadData()
        setupUI()
        
    }

    func setupUI() {
        
        carouselView = CarouselView.loadFromNib()
        carouselView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        carouselView.configure(with: viewModel.imageItems)
        carouselView.delegateSearch = self
        carouselView.delegateCarouselView = self
        ListTableView.tableHeaderView = carouselView
        ListTableView.dataSource = self
        ListTableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: ListCell.identifier)
        
        
        fab.backgroundColor = .systemBlue
        fab.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        fab.tintColor = .white
        fab.layer.cornerRadius = 28
        view.addSubview(fab)
        fab.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            fab.widthAnchor.constraint(equalToConstant: 56),
            fab.heightAnchor.constraint(equalToConstant: 56),
            fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            fab.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
        ])

        fab.addTarget(self, action: #selector(showStats), for: .touchUpInside)
    }

    private func bindViewModel() {
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.ListTableView.reloadData()
                self?.carouselView.scrollToPage(self?.viewModel.currentPageIndex ?? 0)
            }
        }
    }

    @objc private func showStats() {
        let (count, chars) = viewModel.currentStats()
        let vc = BottomSheetViewController()
        vc.configure(count: count, characters: chars)
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}

extension HomeViewController: SearchDelegate {
    func searchQuery(query: String){
        viewModel.updateSearch(query: query)
    }
}

extension HomeViewController: CarouselViewDelegate {
    func carouselView(_ carouselView: CarouselView, didScrollTo index: Int) {
        print(index)
        viewModel.updatePage(index: index)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as! ListCell
        let item = viewModel.filteredItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}



class BottomSheetViewController: UIViewController {
    private let label = UILabel()

    func configure(count: Int, characters: [(char: Character, count: Int)]) {
        label.numberOfLines = 0
        var text = "List (\(count) items)\n"
        for (char, cnt) in characters {
            text += "\(char) = \(cnt)\n"
        }
        label.text = text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
