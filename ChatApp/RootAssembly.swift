//
//  RootAssembly.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

class RootAssembly {
  lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
  private lazy var serviceAssembly: IServiceAssembly = ServiceAssembly(coreAssembly: self.coreAssembly)
  private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
