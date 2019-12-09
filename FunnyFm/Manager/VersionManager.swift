//
//  versionManager.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/9.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import Siren

class VersionManager: NSObject {
	
	//创建,基本参数
	static func setupSiren() {
		Siren.shared.rulesManager = RulesManager(majorUpdateRules: .critical,
                                          minorUpdateRules: .annoying,
                                          patchUpdateRules: .default,
                                          revisionUpdateRules: Rules(promptFrequency: .weekly, forAlertType: .option))
		Siren.shared.wail { results in
            switch results {
            case .success(let updateResults):
                print("AlertAction ", updateResults.alertAction)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
	}
	
}
