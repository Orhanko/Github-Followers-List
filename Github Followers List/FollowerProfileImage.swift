//
//  FollowerProfileImage.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/11/24.
//

import UIKit

class FollowerProfileImage: UIImageView {

    let cache = NetworkManager.shared.cache
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = UIImage(systemName: "person.circle.fill")
        tintColor = .systemOrange
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from url: String) {
        let cacheKey = url
        
        // Proveri da li slika već postoji u kešu
        if let image = cache.object(forKey: cacheKey as NSString) {
            print("Slika vec u keshu")
            DispatchQueue.main.async {
                self.image = image
            }
            return
        }
        
        print("Slika nije u keshu")
        
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self, cacheKey] data, response, error in
            // Sigurnosna provera za self
            guard let self = self else { return }
            
            if error != nil { return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            // Sačuvaj sliku u kešu
            cache.setObject(image, forKey: cacheKey as NSString) // Konverzija u `NSString` samo ovde
            
            // Postavi sliku na glavnom thread-u
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
