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
    
    // Storyboard constants
    struct Storyboard {
        static let ShowSearch2VC = "Show Search2VC"
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - IBActions
    @IBAction func takePhoto(sender: UIButton) {
        takePhoto()
    }
    
    // MARK: - Constants and variables
    // store downloaded tags from Imagga API. tags are the recommendations
    typealias recommendation = String
    static var tags: [recommendation]?
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // resets any image placed in before
        imageView.image = nil
    }
    
    
    
    // Methods
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

// Network calls
// MARK: - UIImagePickerControllerDelegate
extension ImaggaViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // method gets called right after use "Use Photo" they took
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Info did not have the required UIImage for the Original Image")
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        // sets imageView to the image taken
        imageView.image = image
        // hides button. starts and shows progress view and activity indicator
        takePhotoButton.hidden = true
        progressView.progress = 0.0
        progressView.hidden = false
        activityIndicatorView.startAnimating()
        
        // called method uploadImage. everything with alamofire is asynchronous. updates UI in async manner
        uploadImage(
            image,
            // animates progress bar
            progress: { [weak weakSelf = self] percent in
                //2. while progress file uploads, calls the progress handler with percent update
                weakSelf?.progressView.setProgress(percent, animated: true)
            },
            completion: { [weak weakSelf = self] tags in
                // 3. completion handler sets controllers back to their original state
                weakSelf?.takePhotoButton.hidden = false
                weakSelf?.progressView.hidden = true
                weakSelf?.activityIndicatorView.stopAnimating()
                
                ImaggaViewController.tags = tags
                // 4. advances to results results screen after successful or unsuccessful upload
                self.performSegueWithIdentifier(Storyboard.ShowSearch2VC, sender: self)
            })
        // returns back to ImaggaViewController before completion handler is done to show image and progress indicator
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // uploads photo to ImaggaAPI. Imagga API uses JPEG image format
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
                    upload.responseJSON { [weak weakSelf = self] response in
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
                        weakSelf?.downloadTags(firstFileID) { tags in
                            completion(tags: tags)
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    
    // downloads tags from Imagga API
    func downloadTags(contentID: String, completion: ([String]) -> Void) {
        Alamofire.request(ImaggaRouter.Tags(contentID))
            .responseJSON { response in
                // 1.
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion([String]())
                    return
                }
                
                // 2.
                guard let responseJSON = response.result.value as? [String: AnyObject],
                    results = responseJSON["results"] as? [AnyObject],
                    firstResult = results.first,
                    tagsAndConfidences = firstResult["tags"] as? [[String: AnyObject]] else {
                        print("Invalid tag information received from service")
                        completion([String]())
                        return
                }
                print(responseJSON)
                
                
                // 3.
                let tags = tagsAndConfidences.flatMap({ dict in
                    return dict["tag"] as? String
                })
                
                print(tags)
                print("build on irl iphone/ipad to take a photo instead of opening photo gallery")
                
                // 4.
                completion(tags)
        }
    }
}