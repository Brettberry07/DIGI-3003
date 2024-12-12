//
//  MenuController.swift
//  OrderApp
//
//  Created by Berry, Brett A. (Student) on 11/15/24.
//

import Foundation
import UIKit

enum MenuControllerError: Error, LocalizedError {
    case categoriesNotFound
    case menuItemsNotFound
    case orderRequestFailed
    case imageDataMissing
}

typealias MinutesToPrepare = Int

class MenuController {
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }
    
    static let shared = MenuController()
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    
    let basicURl = URL(string: "http://localhost:8080/")!
    
    //GET requests
    func fetchCategories() async throws -> [String] {
        let categoriesURL = basicURl.appendingPathComponent("categories")
        let (data, response) = try await URLSession.shared.data(from: categoriesURL)
        
        //unwrapping response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MenuControllerError.categoriesNotFound
        }
        
        //decoding the data
        let jsonDecoder = JSONDecoder()
        let categoriesResponse = try jsonDecoder.decode(CategoriesResponse.self, from: data)
        
        return categoriesResponse.categories
    }
    
    func fetchMenuItems(forCategory categoryName: String) async throws -> [MenuItem] {
        let baseMenuURL = basicURl.appendingPathComponent("menu")
        
        var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        
        let (data, response) = try await URLSession.shared.data(from: menuURL)
        
        //unwrapping response
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.menuItemsNotFound
        }
        
        let decoder = JSONDecoder()
        let menuResponse = try decoder.decode(MenuResponse.self, from: data)
        
        return menuResponse.items
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 else {
            throw MenuControllerError.imageDataMissing
        }
        
        guard let image = UIImage(data: data) else {
            throw MenuControllerError.imageDataMissing
        }
        
        return image
    }
    
    //POST requests
    func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        let orderURL = basicURl.appendingPathComponent("order")
        
        //creating the request
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //creating the json data
        let menuIdsDict = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(menuIdsDict)
        
        //posting the data
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //unwrapping response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MenuControllerError.orderRequestFailed
        }
        
        //decoding data
        let jsonDecoder = JSONDecoder()
        let orderResponse = try jsonDecoder.decode(OrderResponse.self, from: data)
        
        return orderResponse.prepTime
    }
    
}
