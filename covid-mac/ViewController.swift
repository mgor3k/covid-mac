import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var countryTextField: NSTextField!
    
    private let api: StatsFetching = StatsFetcher(session: URLSession.shared)
    private var stats: Stats?
    
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

private extension ViewController {
    func fetchStats() {
        api.fetchData(for: "Poland") { [weak self] result in
            switch result {
            case .success(let stats):
                self?.stats = stats
                DispatchQueue.main.async {
                    self?.invalidateTouchBar()
                }
                print(stats)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func invalidateTouchBar() {
        self.view.window?.windowController?.touchBar = nil
    }
}

extension ViewController: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        print("Making touchbar")
        let custom = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case .titleLabel:
            let label = NSTextField.init(labelWithString: "Covid stats in Poland")
            custom.view = label
            
        case .allCasesItem:
            custom.view = NSTextField.init(labelWithString: "All: \(stats?.cases ?? 0)")

        case .deathsItem:
            custom.view = NSTextField.init(labelWithString: "☠️: \(stats?.deaths ?? 0)")

        case .recoveredItem:
            custom.view = NSTextField.init(labelWithString: "👍: \(stats?.recovered ?? 0)")
            
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
