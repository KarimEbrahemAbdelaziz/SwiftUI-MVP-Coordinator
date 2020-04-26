//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol DetailRedBaseCoordinator: FinalCoordinator {}

extension DetailRedBaseCoordinator {
    func presentNextView(viewModel: DetailViewModel?, isPresented: Binding<Bool>) -> some ReturnWrapper {
        let coordinator = DetailCoordinator<Self>(viewModel: viewModel, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
}

class DetailRedCoordinator<P: FinalCoordinator>: DetailRedBaseCoordinator {
    private let viewModel: DetailRedViewModel?
    private var isPresented: Binding<Bool>
    
    init(viewModel: DetailRedViewModel?, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.isPresented = isPresented
    }
    
    @discardableResult
    func start() -> some ReturnWrapper {
        let view = DetailRedFactory.make(with: viewModel, coordinator: self)
            .onDisappear(perform: { [weak self] in
                self?.stop()
            })
        return NavigationReturnWrapper(isPresented: isPresented, destination: view)
    }
}

class DetailRedModalCoordinator<P: FinalCoordinator>: DetailRedBaseCoordinator {
    private let viewModel: DetailRedViewModel?
    private var isPresented: Binding<Bool>
    
    init(viewModel: DetailRedViewModel?, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.isPresented = isPresented
    }
    
    @discardableResult
    func start() -> some ReturnWrapper {
        let view = DetailRedFactory.make(with: viewModel, coordinator: self, shouldShowDimiss: true)
        let destination = NavigationView { view }
            .navigationViewStyle(StackNavigationViewStyle())
        return ModalReturnWrapper(isPresented: isPresented, destination: destination)
    }
}
