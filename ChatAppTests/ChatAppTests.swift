//
//  ChatAppTests.swift
//  ChatAppTests
//
//  Created by Sergey Shalnov on 07/12/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import XCTest
@testable import ChatApp

class ChatAppTests: XCTestCase {
    
    var requestManager: IRequestManagerMock!
    var imageLoader: IImageDownloader!
    var testImage: UIImage!
    
    // MARK: - Init variables
    
    override func setUp() {
        super.setUp()
        
        testImage = UIImage(named: "Emblem")!
        
        requestManager = RequestManagerMock(testImage: testImage)
        imageLoader = PixabayService(requestSender: RequestSender(), requestLoader: requestManager)
    }
    
    override func tearDown() {
        requestManager = nil
        imageLoader = nil
        testImage = nil
        
        super.tearDown()
    }
    
    
    // MARK: - Test: That ImageLoader called RequestManager.load
    
    func testOnImageLoaderCalledRequestManagerLoad() {
        // given
        let url = "http://google.com/"
        
        // when
        imageLoader.load(url: url, completion: { _ in })
        
        // then
        XCTAssert(requestManager.isLoadCalled)
    }
    
    
    // MARK: - Image compresss
    // This method preparing image for compare with compressed image
    
    private func imageCompress(image: UIImage) -> Data {
        let dataCompression_1 = image.pngData()!
        let imageFromData = UIImage(data: dataCompression_1)!
        let dataCompression_2 = imageFromData.pngData()!
        
        return dataCompression_2
    }
    
    
    // MARK: - Test: That ImageLoader called RequestManager which load testImage
    
    func testOnImageLoaderCalledRequestManagerAndLoadImage() {
        // given
        let expectation = self.expectation(description: "Loading")
        var isEqual = false
        
        // when
        imageLoader.load(url: "http://google.com/") { image in
            guard let image = image else {
                XCTAssert(false)
                return
            }
            
            let dataOfLoadImage = image.pngData()!
            let dataOfTestImage = self.imageCompress(image: self.testImage)
            
            isEqual = dataOfLoadImage == dataOfTestImage
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssert(isEqual)
    }
    
}
