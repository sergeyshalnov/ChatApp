//
//  RequestManager.swift
//  ChatAppTests
//
//  Created by Sergey Shalnov on 07/12/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit
@testable import ChatApp

protocol IRequestManagerMock: IRequestLoader  {
    
    var isLoadCalled: Bool { set get }
    var testImage: UIImage {set get }
    
}


// MARK: - Mock & Stub for RequestManager

class RequestManagerMock: IRequestManagerMock {
    
    var isLoadCalled: Bool = false
    var testImage: UIImage
    
    init(testImage: UIImage) {
        self.testImage = testImage
    }
    
    func load(url: String, completion: @escaping (Data?) -> Void) {
        isLoadCalled = true
        
        let imageData = testImage.pngData()!

        completion(imageData)
    }
    
    func cancel() {
        //
    }
    
}
