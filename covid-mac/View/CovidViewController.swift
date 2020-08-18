//
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Cocoa

class CovidViewController: NSViewController {
    @IBOutlet private weak var countryTextField: NSTextField!
    @IBOutlet private weak var errorLabel: NSTextField!
    
    private lazy var viewModel = CovidViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryTextField.stringValue = viewModel.countryName
        setupFetching()
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
        viewModel.changeCountry(countryTextField.stringValue)
    }
}

private extension CovidViewController {
    func setupFetching() {
        viewModel.statsDidUpdate = { [weak self] result in
            switch result {
            case .success:
                self?.errorLabel.isHidden = true
            case .failure(let error):
                self?.errorLabel.isHidden = false
                self?.errorLabel.stringValue = error.localizedDescription
            }
            self?.invalidateTouchBar()
        }
        
        viewModel.startFetching()
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
        let custom = NSCustomTouchBarItem(identifier: identifier)

        guard let stats = viewModel.stats else {
            if identifier == .allCasesItem {
                let label = NSTextField(labelWithString: "Error")
                label.textColor = .systemRed
                custom.view = label
                return custom
            }
            return nil
        }
        
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
