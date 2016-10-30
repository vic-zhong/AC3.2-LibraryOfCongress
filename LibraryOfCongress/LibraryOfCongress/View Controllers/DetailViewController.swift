//
//  DetailViewController.swift
//  LibraryOfCongress
//
//  Created by Victor Zhong on 10/29/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var imageView: UIImageView!
	
	@IBOutlet weak var subjectView: UITextView!
	
	var selectedCongressData: Congress!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
	}
	
	internal func loadData() {
		titleLabel.text = selectedCongressData.title
		
		var newString = "Subjects:"
		for all in selectedCongressData.subjects {
			newString += "\n\(all)"
		}
		
		subjectView.text = newString
		
		APIRequestManager.manager.downloadImage(urlString: selectedCongressData.imageURL) { (returnedData: Data) in
			DispatchQueue.main.async {
				self.imageView.image = UIImage(data: returnedData)
				self.view.setNeedsLayout()
			}
		}
	}
	
}
