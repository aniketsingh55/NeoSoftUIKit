
import Foundation

class HomeViewModel {
    private(set) var imageItems: [ImageItem] = []
    var allPages: [[ListItem]] = []
    private(set) var filteredItems: [ListItem] = []
    private(set) var currentPageIndex = 0
    var searchQuery = ""
    var onDataUpdate: (() -> Void)?

    
    func loadData() {
        imageItems = (1...5).map { ImageItem(imageName: "image\($0)") }
        
        allPages = imageItems.enumerated().map { (pageIndex, imageItem) in
            (1...10).map {
                ListItem(
                    imageName: imageItem.imageName,
                    title: "Item \($0)",
                    subtitle: "Subtitle \($0)"
                )
            }
        }
        
        updateFilteredItems()
    }

    func updateSearch(query: String) {
        searchQuery = query
        updateFilteredItems()
    }

    func updatePage(index: Int) {
        currentPageIndex = index
        updateFilteredItems()
    }

    func updateFilteredItems() {
        let pageItems = allPages[currentPageIndex]
        filteredItems = searchQuery.isEmpty ? pageItems :
            pageItems.filter { $0.title.lowercased().contains(searchQuery.lowercased()) }
        onDataUpdate?()
    }

    func currentStats() -> (count: Int, topChars: [(char: Character, count: Int)]) {
        let allText = filteredItems.map { $0.title }.joined().lowercased()
        let counts = allText.reduce(into: [Character: Int]()) { dict, char in
            if char.isLetter {
                dict[char, default: 0] += 1
            }
        }
        let top3: [(Character, Int)] = counts
            .sorted { $0.value > $1.value }
            .prefix(3)
            .map { ($0.key, $0.value) }
        return (filteredItems.count, Array(top3))
    }
}
