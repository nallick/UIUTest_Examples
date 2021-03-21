//
//  CucumberTests.swift
//
//  Created by Tyler Thompson on 8/26/18.
//  Copyright © 2018-2021 Purgatory Design. All rights reserved.
//

import Foundation
import CucumberSwift
import UIUTest

extension Cucumber: StepImplementation {
	public var bundle: Bundle {
		return Bundle(for: CucumberTestBundleLocation.self)
	}

    public func setupSteps() {
		setupAuthenticationTests()
        AuthenticationDSLSteps().setup()
    }
}

private class CucumberTestBundleLocation {}
