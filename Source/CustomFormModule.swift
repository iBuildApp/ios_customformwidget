//
//  CustomFormModule.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 23/05/2019.
//

import UIKit
import IBACore
import IBACoreUI

public class CustomFormModule: BaseModule, ModuleType {
    public var moduleRouter: AnyRouter { return router }
    
    private var router: CustomFormModuleRouter!
    internal var config: WidgetModel?
    internal var data: DataModel?
    
    public override class func canHandle(config: WidgetModel) -> Bool {
        return config.type == "customform" ? true : false
    }
    
    public required init() {
        print("\(type(of: self)).\(#function)")
        super.init()
        router = CustomFormModuleRouter(with: self)
    }
    
    public func setConfig(_ model: WidgetModel) {
        self.config = model
        guard let data = model.data else { return }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted])
            let decoder = JSONDecoder()
            self.data = try decoder.decode(DataModel.self, from: jsonData)
        } catch {
            print(error)
        }
    }
}
