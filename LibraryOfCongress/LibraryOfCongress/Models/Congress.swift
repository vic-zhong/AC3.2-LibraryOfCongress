//
//  Congress.swift
//  LibraryOfCongress
//
//  Created by Victor Zhong on 10/29/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import Foundation

internal enum CongressModelParseError: Error {
	case results, title, image, imageBig, imageThumb, subjects, hits
}

internal struct Congress {
	
	let title: String
	let imageURL: String
	let thumbURL: String
	let subjects: [String]
	
	static func congress(from data: Data) -> [Congress]? {
		var detailToReturn: [Congress]? = []
		
		do {
			// 1. Attempt to serialize data
			let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
			
			// 2. begin parsing to our array of user data objects
			guard let response: [String : Any] = jsonData as? [String : Any],
				let results: [[String : Any]] = response["results"] as? [[String : Any]]
				else {
					throw CongressModelParseError.results
			}
			print("We've got \(results.count) results!")
			
			// 3. Iterate over each element
			for congressResult in results {
				
				// 4. parse out title
				guard let title: String = congressResult["title"] as? String
					else {
						throw CongressModelParseError.title
				}
				
				// 5. parse out image array
				guard let images: [String : Any] = congressResult["image"] as? [String : Any]
					else {
						throw CongressModelParseError.image
				}
				
				// 5.1. parse out image URL
				guard let imageURL: String = images["full"] as? String
					else {
						throw CongressModelParseError.imageBig
				}
				
				// 5.2. parse out thumb URL
				guard let thumbURL: String = images["square"] as? String
					else {
						throw CongressModelParseError.imageThumb
				}
				
				// 6. parse out subject array down there
				
				let validInfo: Congress = Congress(
					title : title,
					imageURL : "http:\(imageURL)",
					thumbURL : "http:\(thumbURL)",
					subjects : (congressResult["subjects"] as? [String]) ?? ["N/A"]
				)
				
				detailToReturn?.append(validInfo)
			}
			
			print("Returning \(detailToReturn?.count) results")
			return detailToReturn
		}
		catch {
			print("Error encountered with JSONSerialization: \(error)")
		}
		
		return nil
	}
	
	static func hits(from data: Data) -> Int? {
		
		do {
			// 1. Attempt to serialize data
			let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
			
			// 2. Begin parsing
			guard let response: [String : Any] = jsonData as? [String : Any],
				let results: [String : Any] = response["search"] as? [String : Any]
				else {
					throw CongressModelParseError.hits
			}
			
			// 3. Yup, I just wanted this one value
			if (results["hits"] as? Int) != nil { return results["hits"] as? Int }
			else {
				return 0
			}
		}
		catch {
			print("Error encountered with JSONSerialization: \(error)")
		}
		return 0
	}
	
}
