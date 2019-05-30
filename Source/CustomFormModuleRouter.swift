//
//  CustomFormModuleRouter.swift
//  CustomFormModule
//
//  Created by Anton Boyarkin on 23/05/2019.
//

import IBACore
import IBACoreUI

public enum CustomFormModuleRoute: Route {
    case root
}

public class CustomFormModuleRouter: BaseRouter<CustomFormModuleRoute> {
    var module: CustomFormModule?
    init(with module: CustomFormModule) {
        self.module = module
    }
    
    public override func generateRootViewController() -> BaseViewControllerType {
        return CustomFormViewController(type: module?.config?.type, data: module?.data)
    }
    
    public override func prepareTransition(for route: CustomFormModuleRoute) -> RouteTransition {
        return RouteTransition(module: generateRootViewController(), isAnimated: true, showNavigationBar: true, showTabBar: false)
    }
    
    public override func rootTransition() -> RouteTransition {
        return self.prepareTransition(for: .root)
    }
}
