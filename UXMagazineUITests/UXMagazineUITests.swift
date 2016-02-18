//
//  UXMagazineUITests.swift
//  UXMagazineUITests
//
//  Created by O2.LinYi on 16/2/17.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import XCTest

class UXMagazineUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testScrollView() {
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["一款可以让您浏览到业界最新资讯额应用"].swipeLeft()
        elementsQuery.staticTexts["根据您的兴趣提供按主题分类的文章"].swipeLeft()
        scrollViewsQuery.otherElements.containingType(.StaticText, identifier:"内容每周更新与世界同步").element.swipeLeft()
        app.buttons["进入"].tap()
        
    }
    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testExample() {
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
    
}
