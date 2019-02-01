//
//  ebayCQTests.swift
//  ebayCQTests
//
//  Created by Nick on 1/20/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import XCTest
@testable import earthQuakeCheck

class ebayCQTests: XCTestCase {
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testHTTPNetworking() {
        
        let networking = HTTPNetworking()
   
//        networking.getEarthQuakeObjs(completion: { objs in
//            if objs.count == 0 {
//                XCTFail("No record found")
//            }
//        })
    }

    func testEarthQuakeObjInit() {
        
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: "test", withExtension: "json")
        XCTAssertNotNil(fileURL)
        

        do {
            let data = try Data(contentsOf: fileURL!, options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            guard let alljson = jsonResult as? [String:Any] else {
                return
            }
            
            if let featuresDicts = alljson["features"] as? [[String:Any]] {
                if featuresDicts.count > 1 {
                    if let firstObj = featuresDicts.first {
                        let tmpObj = earthQuakeObj.init(featuresDict: firstObj)
                        XCTAssertNotNil(tmpObj?.title, "passed")
                    }
                    
                }else{
                    XCTFail("dict is empty")
                }
            }
            
        } catch {
            // handle error
            XCTFail("json error")
        }
        
    }
}
