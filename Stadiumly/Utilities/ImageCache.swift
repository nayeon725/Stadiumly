import UIKit

final class ImageCache {
    static let shared = ImageCache()
    
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    
    func image(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func remove(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearAll() {
        cache.removeAllObjects()
    }
    
    func preloadImages(_ imageNames: [String], completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        for imageName in imageNames {
            if image(for: imageName) != nil { continue }
            
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = UIImage(named: imageName)?.preparingThumbnail(of: CGSize(width: 200, height: 200)) {
                    self.save(image, for: imageName)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}

// UIImageView 확장
extension UIImageView {
    func loadOptimized(named: String) {
        if let cached = ImageCache.shared.image(for: named) {
            self.image = cached
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let image = UIImage(named: named)?.preparingThumbnail(of: CGSize(width: 200, height: 200)) {
                ImageCache.shared.save(image, for: named)
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
} 