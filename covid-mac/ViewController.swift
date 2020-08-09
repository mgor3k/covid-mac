import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var messegeTextField: NSTextField!
    
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
        touchBar.customizationIdentifier = .hyftBar
        touchBar.defaultItemIdentifiers = [
            .titleLabel,
            .allCasesItem,
            .sadEmojiItem,
            .angryEmojiItem,
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

        case .sadEmojiItem:
            custom.view = NSButton(title: NSLocalizedString("😟", comment:""), target: self,
              action: #selector(buttonPressed))

        case .angryEmojiItem:
            custom.view = NSButton(title: NSLocalizedString("😡", comment:""), target: self,
              action: #selector(buttonPressed))
            
        default:
            return nil
        }
        
        return custom
    }
    
    @objc func buttonPressed() {
        
    }
    
    func getMessageBaseOnReaction(_ reaction: String) -> String {
            switch reaction {
            case "😂":
                return "Being happy never goes out of style. - Lilly Pulitzer"
            case "😟":
                return "Sadness flies away on the wings of time. - Jean de La Fontaine"
            case "😡":
                return "To be angry is to revenge the faults of others on ourselves. - Alexander Pope"
            default:
                return "Look like our quote does not cater to this reaction"
            }
        }

    //Quotes are extracted from https://www.brainyquote.com
    func showMessageBaseOnReaction(_ reaction: String) {
        messegeTextField.isHidden = false
        messegeTextField.stringValue = getMessageBaseOnReaction(reaction)
    }
    
}

extension NSTouchBarItem.Identifier {
    static let titleLabel = NSTouchBarItem.Identifier("covid.titleLabel")
    
    static let allCasesItem = NSTouchBarItem.Identifier("covid.allCases")
    static let sadEmojiItem = NSTouchBarItem.Identifier("com.zeta.SadEmoji")
    static let angryEmojiItem = NSTouchBarItem.Identifier("com.zeta.AngryEmoji")

}

extension NSTouchBar.CustomizationIdentifier {
    static let hyftBar = NSTouchBar.CustomizationIdentifier("com.zeta.ViewController.HYFTTouchBar")
}
