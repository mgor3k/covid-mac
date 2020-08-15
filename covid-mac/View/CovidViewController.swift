//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Cocoa

class CovidViewController: NSViewController {
    private let viewModel = CovidViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStats()
    }
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .stats
        touchBar.defaultItemIdentifiers = [
            .titleLabel,
            .allCasesItem,
            .deathsItem,
            .recoveredItem,
            .flexibleSpace,
            .otherItemsProxy
        ]
        return touchBar
    }
}

private extension CovidViewController {
    func fetchStats() {
        viewModel.fetchStats { [weak self] result in
            switch result {
            case .success:
                self?.invalidateTouchBar()
            case .failure:
                break
            }
        }
    }
    
    func invalidateTouchBar() {
        view.window?.windowController?.touchBar = nil
    }
}

extension CovidViewController: NSTouchBarDelegate {
    func touchBar(
        _ touchBar: NSTouchBar,
        makeItemForIdentifier identifier: NSTouchBarItem.Identifier
    ) -> NSTouchBarItem? {
        guard let stats = viewModel.stats else { return nil }
        let custom = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case .titleLabel:
            let label = NSTextField.init(labelWithString: "Covid stats in Poland")
            custom.view = label
            
        case .allCasesItem:
            custom.view = NSTextField.init(labelWithString: "All: \(stats.cases)")

        case .deathsItem:
            custom.view = NSTextField.init(labelWithString: "☠️: \(stats.deaths)")

        case .recoveredItem:
            custom.view = NSTextField.init(labelWithString: "👍: \(stats.recovered)")
            
        default:
            return nil
        }
        
        return custom
    }
    
}

extension NSTouchBarItem.Identifier {
    static let titleLabel = NSTouchBarItem.Identifier("covid.titleLabel")
    
    static let allCasesItem = NSTouchBarItem.Identifier("covid.allCases")
    static let deathsItem = NSTouchBarItem.Identifier("covid.deaths")
    static let recoveredItem = NSTouchBarItem.Identifier("covid.recovered")
}

extension NSTouchBar.CustomizationIdentifier {
    static let stats = NSTouchBar.CustomizationIdentifier("covid.stats")
}
