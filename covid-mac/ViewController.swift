//
//  ViewController.swift
//  covid-mac
//
//  Created by Maciej Gorecki on 16/05/2020.
//  Copyright © 2020 Maciej Gorecki. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var messegeTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .hyftBar
        touchBar.defaultItemIdentifiers = [.infoLabelItem, .joyEmojiItem, .sadEmojiItem,
          .angryEmojiItem, .flexibleSpace, .otherItemsProxy]
        return touchBar
    }
    
    


}

extension ViewController: NSTouchBarDelegate {
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let custom = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case .infoLabelItem:
            let label = NSTextField.init(labelWithString: NSLocalizedString("How do you feel today?", comment:""))
            custom.view = label
            
        case .joyEmojiItem:
            custom.view = NSButton(title: NSLocalizedString("😂", comment:""), target: self,
              action: #selector(buttonPressed))

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


import AppKit

extension NSTouchBarItem.Identifier {
    static let infoLabelItem = NSTouchBarItem.Identifier("com.zeta.InfoLabel")
    static let joyEmojiItem = NSTouchBarItem.Identifier("com.zeta.JoyEmoji")
    static let sadEmojiItem = NSTouchBarItem.Identifier("com.zeta.SadEmoji")
    static let angryEmojiItem = NSTouchBarItem.Identifier("com.zeta.AngryEmoji")

}

extension NSTouchBar.CustomizationIdentifier {
    static let hyftBar = NSTouchBar.CustomizationIdentifier("com.zeta.ViewController.HYFTTouchBar")
}
