//
//  ImageViewUtils.swift
//  WA8
//
//  Created by 郭 on 2023/11/24.
//

import Foundation
import UIKit

extension UIImageView {
    //MARK: Borrowed from: https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
    
    //MARK:  We are creating a background task to load the cloud image. It has to be through an asynchronous background thread because it is a network call. We cannot guarantee the image getting downloaded instantly.
    func loadRemoteImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
