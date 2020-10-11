//
//  IntentHandler.swift
//  FunnyIntent
//
//  Created by Tao on 2020/10/10.
//  Copyright © 2020 Duke. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        
		guard intent is INPlayMediaIntent else {
			fatalError("Unhandled intent type: \(intent)")
		}

		return PlayEpisodeHandler()
    }
}
