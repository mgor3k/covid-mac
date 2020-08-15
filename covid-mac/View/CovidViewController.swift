//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Cocoa

class CovidViewController: NSViewController {
    @IBOutlet private weak var countryTextField: NSTextField!
    
    private lazy var viewModel = CovidViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryTextField.stringValue = viewModel.countryName
        fetchStats()
    }
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .stats
        touchBar.defaultItemIdentifiers = [
            .allCasesItem,
            .deathsItem,
            .recoveredItem,
            .flexibleSpace,
            .otherItemsProxy
        ]
        return touchBar
    }
    
    @IBAction func setButtonTapped(_ sender: Any) {
        viewModel.setCountry(countryTextField.stringValue)
        fetchStats()
    }
}

private extension CovidViewController {
    func fetchStats() {
        viewModel.fetchStats() { [weak self] result in
            switch result {
            case .success:
                self?.invalidateTouchBar()
            case .failure:
                break
            }
        }
    }
    
    func invalidateTouchBar() {
        touchBar = nil
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
        case .allCasesItem:
            let country = viewModel.countryName
            custom.view = NSTextField(labelWithString: "Total cases in \(country): \(stats.cases)")

        case .deathsItem:
            custom.view = NSTextField(labelWithString: "☠️: \(stats.deaths)")

        case .recoveredItem:
            custom.view = NSTextField(labelWithString: "👍: \(stats.recovered ?? 0)")
            
        default:
            return nil
        }
        
        return custom
    }
}
