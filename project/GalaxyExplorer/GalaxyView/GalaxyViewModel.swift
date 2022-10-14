//
//  GalaxyViewModel.swift
//  GalaxyExplorer
//
//  Created by A118830248 on 14/10/22.
//

import Foundation

struct Planetary: Codable {
    var title: String?
    var hdurl: String?
}


class PlanetViewModel {
    var reloadCallBack: (() -> Void)?
    var errorMessage: ((String) -> Void)?
    
    var service: GalaxyService
    var dataSource: [Planetary] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.reloadCallBack?()
            }
        }
    }
    
    init(service: GalaxyService) {
        self.service = service
    }
    
    func getImages(count: Int) {
        service.getGalaxy(count: count, completion: {[weak self] result in
            switch result {
            case .success(let nasaResults):
                self?.dataSource = nasaResults
            case .failure(let error):
                self?.errorMessage?(error.localizedDescription)
            }
        })
        
    }
}
