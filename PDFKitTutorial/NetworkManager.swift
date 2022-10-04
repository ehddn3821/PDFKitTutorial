//
//  NetworkManager.swift
//  PDFKitTutorial
//
//  Created by 앱지 Appg on 2022/10/04.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    
    private let margaritaUrl = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s="
    
    func getCocktails(searchQuery: String, success: @escaping (_ menu: Menu) -> Void, failure: @escaping (_ error: String) -> Void) {
        
        var semaphore = DispatchSemaphore(value: 0)
        
        var request = URLRequest(url: URL(string: "\(margaritaUrl)\(searchQuery)")!, timeoutInterval: .infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                failure(error?.localizedDescription ?? "GET error")
                semaphore.signal()
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(Menu.self, from: data)
                success(response)
            }
            catch {
                failure(error.localizedDescription)
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
}
