//
//  NetworkAsync.swift
//  Landmarks
//
//  Created by Luca Rocchi on 08/07/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
class NetworkAsync<T:Codable> : ObservableObject {
    var result : T?
    func getData(url:String) async throws {
        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
        result = try JSONDecoder().decode(T.self, from: data)
        print("Async result", result!)
    }
    
}
