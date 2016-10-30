//
//  APIRequestManager.swift
//  LibraryOfCongress
//
//  Created by Victor Zhong on 10/29/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import Foundation

internal class APIRequestManager {
	private static let congressAPIEndpoint: URL = URL(string: "https://loc.gov/pictures/search/?q=mark%20twain&fo=json")!
	
	internal static let manager: APIRequestManager = APIRequestManager()
	private init() {}
	
	func getCongressData(completion: @escaping ((Data?)->Void)) {
		
		let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
		session.dataTask(with: APIRequestManager.congressAPIEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
			if error != nil {
				print("Error encountered in API request: \(error?.localizedDescription)")
			}
			
			if data != nil {
				print("Data returned in response")
				completion(data)
			}
			
			}.resume()
	}
	
	func downloadImage(urlString: String, callback: @escaping (Data) -> () ) {
		
		guard let imageURL = URL(string: urlString) else { return }
		let session = URLSession.shared
		session.dataTask(with: imageURL) { (data: Data?, response: URLResponse?, error: Error?) in
			if error != nil {
				print("Error encountered!: \(error!)")
			}
			guard let imageData = data else { return }
			callback(imageData)
			
			}.resume()
	}
	
}
