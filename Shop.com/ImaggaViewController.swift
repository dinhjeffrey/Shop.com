//
//  ImaggaViewController.swift
//  Shop.com
//
//  Created by jeffrey dinh on 7/21/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import Alamofire
import UIKit

class ImaggaViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var tags: [String]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func takePhoto(sender: UIButton) {
        takePhoto()
    }
    
    // method takes user to camera app when pressing takePhoto button. After take a photo can either "retake" or "use photo"
    private func takePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(.Camera) { // opens camera if available
            picker.sourceType = UIImagePickerControllerSourceType.Camera
        } else { // goes to photo library if can't access camera
            picker.sourceType = .PhotoLibrary
            picker.modalPresentationStyle = .FullScreen
        }
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

// MARK: - UIImagePickerControllerDelegate
extension ImaggaViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // method gets called right after use "Use Photo" they took
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Info did not have the required UIImage for the Original Image")
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        imageView.image = image
        
        takePhotoButton.hidden = true
        progressView.progress = 0.0
        progressView.hidden = false
        activityIndicatorView.startAnimating()
        
        uploadImage(
            image,
            progress: { [unowned self] percent in
                //2
                self.progressView.setProgress(percent, animated: true)
            },
            completion: { [weak weakSelf = self] tags in
                // 3
                weakSelf?.takePhotoButton.hidden = false
                weakSelf?.progressView.hidden = true
                weakSelf?.activityIndicatorView.stopAnimating()
                
                weakSelf?.tags = tags
                
                // 4
                self.performSegueWithIdentifier("ShowResults", sender: self)
            })
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uploadImage(image: UIImage, progress: (percent: Float) -> Void,
                     completion: (tags: [String]) -> Void) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        Alamofire.upload(
            ImaggaRouter.Content,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: imageData, name: "imagefile",
                    fileName: "image.jpg", mimeType: "image/jpeg")
            },
            encodingCompletion: {encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                        dispatch_async(dispatch_get_main_queue()) {
                            let percent = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
                            progress(percent: percent)
                        }
                    }
                    upload.validate()
                    upload.responseJSON { response in
                        guard response.result.isSuccess else {
                            // 1.
                            print("Error while uploading file: \(response.result.error)")
                            completion(tags: [String()])
                            return
                        }
                        // 2.
                        guard let responseJSON = response.result.value as? [String: AnyObject],
                            uploadedFiles = responseJSON["uploaded"] as? [AnyObject],
                            firstFile = uploadedFiles.first as? [String: AnyObject],
                            firstFileID = firstFile["id"] as? String else {
                                print("Invalid information received from service")
                                completion(tags: [String]())
                                return
                        }
                        
                        print("Content uploaded with ID: \(firstFileID)")
                        // 3.
//                        self.downloadTags(firstFileID) { tags in
//                            completion(tags: tags)
//                        }
                    }
                    
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    //
    //
    //
    //
    //    func downloadTags(contentID: String, completion: ([String]) -> Void) {
    //        Alamofire.request(ImaggaRouter.Tags(contentID))
    //            .responseJSON { response in
    //                // 1.
    //                guard response.result.isSuccess else {
    //                    print("Error while fetching tags: \(response.result.error)")
    //                    completion([String]())
    //                    return
    //                }
    //
    //                // 2.
    //                guard let responseJSON = response.result.value as? [String: AnyObject],
    //                    results = responseJSON["results"] as? [AnyObject],
    //                    firstResult = results.first,
    //                    tagsAndConfidences = firstResult["tags"] as? [[String: AnyObject]] else {
    //                        print("Invalid tag information received from service")
    //                        completion([String]())
    //                        return
    //                }
    //
    //                // 3.
    //                let tags = tagsAndConfidences.flatMap({ dict in
    //                    return dict["tag"] as? String
    //                })
    //
    //                // 4.
    //                completion(tags)
    //        }
    //    }
    //
    //    func downloadColors(contentID: String, completion: ([PhotoColor]) -> Void) {
    //        Alamofire.request(ImaggaRouter.Colors(contentID))
    //            // 1.
    //            .responseJSON { response in
    //                // 2.
    //                guard response.result.isSuccess else {
    //                    print("Error while fetching colors: \(response.result.error)")
    //                    completion([PhotoColor]())
    //                    return
    //                }
    //
    //                // 3.
    //                guard let responseJSON = response.result.value as? [String: AnyObject],
    //                    results = responseJSON["results"] as? [AnyObject],
    //                    firstResult = results.first as? [String: AnyObject],
    //                    info = firstResult["info"] as? [String: AnyObject],
    //                    imageColors = info["image_colors"] as? [[String: AnyObject]] else {
    //                        print("Invalid color information received from service")
    //                        completion([PhotoColor]())
    //                        return
    //                }
    //
    //                // 4.
    //                let photoColors = imageColors.flatMap({ dict -> PhotoColor? in
    //                    guard let r = dict["r"] as? String,
    //                        g = dict["g"] as? String,
    //                        b = dict["b"] as? String,
    //                        closestPaletteColor = dict["closest_palette_color"] as? String else {
    //                            return nil
    //                    }
    //                    return PhotoColor(red: Int(r),
    //                        green: Int(g),
    //                        blue: Int(b),
    //                        colorName: closestPaletteColor)
    //                })
    //
    //                // 5.
    //                completion(photoColors)
    //        }
    //    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
