//
//  MediaPickerPhoto.swift
//  EnvironmentTest2
//
//  Created by Jon Thornham on 11/3/21.
//

import Foundation
import SwiftUI


/// Media picker object for Camera or Library
struct MediaPickerPhoto: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    /// Presentation wrapper
    @Environment(\.presentationMode) var presentationMode

    /// Source type to present for
    let sourceType: UIImagePickerController.SourceType

    /// Binding for showing error alerts
    @Binding var showError: Bool

    /// Callback for media selection
    let completion: (UIImage?, String?) -> Void

    // MARK: - Representable

    func makeUIViewController(context: UIViewControllerRepresentableContext<MediaPickerPhoto>) -> UIImagePickerController {
        print("MakeUIViewController")
        let picker = UIImagePickerController()

        if sourceType == .camera {
            picker.videoQuality = .typeMedium
        }

        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<MediaPickerPhoto>) {
        // no-op
    }

    // MARK: - Coordinator

    func makeCoordinator() -> MediaCoordinatorPhoto {
        return Coordinator(self)
    }
}

/// Coordinator for  media picker
class MediaCoordinatorPhoto: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
//    // AuthSession
//    @EnvironmentObject var authSession: AuthSession
//
//    let db = Firestore.firestore()
    
    /// Parent picker
    let parent: MediaPickerPhoto

    // MARK: - Init

    init(_ parent: MediaPickerPhoto) {
        print("MediaCoordinatorPhoto")

        self.parent = parent
    }

    // MARK: - Delegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let type = (info[.mediaType] as? String)?.lowercased() else {
            return
        }

        if type.contains("image"), let uiImage = info[.originalImage] as? UIImage {
            // We attempt to resize the image to max os 1280x1280 for perf
            // If it fails, we use the original selection image
            let image = uiImage.resized(maxSize: CGSize(width: 1280, height: 1280)) ?? uiImage

            self.parent.completion(image, nil)
        } else {
            print("Invalid media type selected")
            let error = "There was an error updating your user profile picture. Please try again later."
            parent.completion(nil, error)
            //parent.showError = true
        }

        parent.presentationMode.wrappedValue.dismiss()
    }
}

extension UIImage {
    /// Resize current image
    /// - Parameter maxSize: Target max size
    /// - Returns: Nullable result
    func resized(maxSize: CGSize) -> UIImage? {
        let widthRatio  = maxSize.width  / size.width
        let heightRatio = maxSize.height / size.height

        var newSize: CGSize
        if (widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }
        else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
