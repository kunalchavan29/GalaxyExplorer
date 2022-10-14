//
//  GalaxyService.swift
//  GalaxyExplorer
//
//  Created by A118830248 on 14/10/22.
//

import Foundation
protocol GalaxyServiceProtocol {
    func getGalaxy(count: Int, completion: @escaping (Result<[Planetary], Error>) -> Void)
}

class GalaxyService: GalaxyServiceProtocol {
    func getGalaxy(count: Int, completion: @escaping (Result<[Planetary], Error>) -> Void) {
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=fr28VtFuEGJYpSZVt5E4DvjWnvq5B2HVAcbyFkiq&count=\(count)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        let urlReq = URLRequest(url: url)
        let task = session.dataTask(with: urlReq) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error on download \(error ?? URLError(.badServerResponse))")
                return
            }
            guard 200 ..< 300 ~= response.statusCode else {
                print("statusCode != 2xx; \(response.statusCode)")
                return
            }
            print(String(data: data, encoding: .utf8)!)
            do {
                let decoded = try JSONDecoder().decode([Planetary].self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
}
