//
//  LookupAddressRobot.swift
//  PracticeAppUITests
//
//  Created by Danny Tsang on 3/5/22.
//

import XCTest

class LookUpAddressRobot {
    
    func verifyOnLookUpAddressView() -> LookUpAddressRobot {
        let navBar = XCUIApplication().navigationBars["Lookup Address"]
        XCTAssert(navBar.exists)
        return self
    }
    
    func verifySearchResults(exists: Bool) -> LookUpAddressRobot {
        let table = XCUIApplication().tables["LookUpAddressView.TableView"]
        let cells = table.cells
        XCTAssert(cells.element.waitForExistence(timeout: 3) == exists)
        return self
    }
    
    func searchFor(_ searchString: String) -> LookUpAddressRobot {
        
        let searchTextField = XCUIApplication().textFields["LookUpAddressView.TextField"]
        searchTextField.typeText(searchString)
        searchTextField.typeText("\n")
        return self
    }
    
    func tapOnFirstResult() -> LookUpAddressRobot {
        let cell = XCUIApplication().cells.firstMatch
        XCTAssert(cell.exists)
        cell.tap()
        return self
    }
    
    func dismissView() -> MainViewControllerRobot {
        let closeButton = XCUIApplication().buttons["LookUpAddressView.CloseButton"]
        closeButton.tap()
        
        let navBar = XCUIApplication().navigationBars["Lookup Address"]
        XCTAssertFalse(navBar.exists)
        
        return MainViewControllerRobot()
    }
}
