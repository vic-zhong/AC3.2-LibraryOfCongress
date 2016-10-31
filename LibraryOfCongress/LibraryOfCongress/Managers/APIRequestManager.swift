//
//  APIRequestManager.swift
//  LibraryOfCongress
//
//  Created by Victor Zhong on 10/29/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import Foundation

class APIRequestManager {
	
	internal static let manager: APIRequestManager = APIRequestManager()
	private init() {}
	
	func getCongressData(searchString: String, completion: @escaping ((Data?)->Void)) {
		
		let endpointString = searchString.replacingOccurrences(of: " ", with: "%20")
		let endpoint = URL(string: "https://loc.gov/pictures/search/?q=\(endpointString)&fo=json")!
		let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
		
		session.dataTask(with: endpoint) { (data: Data?, response: URLResponse?, error: Error?) in
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
