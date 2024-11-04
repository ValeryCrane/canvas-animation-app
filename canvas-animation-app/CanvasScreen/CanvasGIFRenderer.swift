import Foundation
import UIKit
import UniformTypeIdentifiers

final class CanvasGIFRenderer {
    func renderGIF(fromFrames frames: [AnimationFrame], frameSize: CGSize, fps: Int) -> URL? {
        let background = UIImage.res.canvasBackground.scaleToFill(frameSize)
        let imageURLs = frames.map { frame in
            var imageURL: URL?
            
            autoreleasepool {
                let image = renderImage(fromFrame: frame, frameSize: frameSize, background: background)
                let data = image.jpegData(compressionQuality: 0.5)
                imageURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(
                    String(UUID().uuidString + ".jpg")
                )
                
                if let imageURL {
                    try? data?.write(to: imageURL, options: .atomic)
                }
            }
            
            return imageURL ?? URL(fileURLWithPath: NSTemporaryDirectory())
        }
        
        return rengerGIFAndReturnURL(fromImages: imageURLs, fps: fps)
    }
    
    private func renderImage(fromFrame frame: AnimationFrame, frameSize: CGSize, background: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(frameSize)
        background.draw(at: .zero)
        if let context = UIGraphicsGetCurrentContext() {
            for i in 0 ..< frame.strokesMaxIndex {
                frame.strokes[i].draw(inContext: context)
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    private func rengerGIFAndReturnURL(fromImages images: [URL], fps: Int) -> URL? {
        let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(
            String(UUID().uuidString + ".gif")
        )

        let fileProperties = [
            kCGImagePropertyGIFDictionary: [
                kCGImagePropertyGIFLoopCount: 0,
                kCGImagePropertyGIFHasGlobalColorMap: false,
            ]
        ]
        
        guard let gifFile = CGImageDestinationCreateWithURL(
            destinationURL as CFURL,
            UTType.gif.identifier as CFString,
            images.count,
            nil
        ) else {
            print("Ошибка при создании GIF файла")
            return nil
        }
        
        CGImageDestinationSetProperties(gifFile, fileProperties as CFDictionary)
        
        let frameProperties = [
            kCGImagePropertyGIFDictionary: [
                kCGImagePropertyGIFDelayTime: 1.0 / Double(fps)
            ]
        ]
        
        for image in images {
            let imageData: Data = (try? .init(contentsOf: image)) ?? Data()
            let uiImage = UIImage(data: imageData)
            try? FileManager.default.removeItem(at: image)
            
            if let cgImage = uiImage?.cgImage {
                CGImageDestinationAddImage(gifFile, cgImage, frameProperties as CFDictionary)
            }
        }
        
        if CGImageDestinationFinalize(gifFile) {
            return destinationURL
        } else {
            print("Ошибка при создании GIF файла")
            return nil
        }
    }
}
