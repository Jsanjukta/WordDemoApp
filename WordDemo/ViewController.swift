//
//  ViewController.swift
//  WordDemo
//
//  Created by Krishna on 20/09/19.
//  Copyright © 2019 Krishna. All rights reserved.
//

import  UIKit

class ViewController: UIViewController, UITextViewDelegate,UIImagePickerControllerDelegate , UIPopoverControllerDelegate , UINavigationControllerDelegate {
    
    //MARK: - IBOutlets and Variables -
    @IBOutlet var txtView: UITextView!
    let picker:UIImagePickerController? = UIImagePickerController()
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initDesign()
    }
    
    func initDesign(){
        self.picker?.delegate = self
        self.navigationItem.title = "NOTE"
        
    }
    
    //MARK: - Button Action -
    @IBAction func btnBoldAction(_ sender: Any) {
        if let textRange = txtView.selectedTextRange {
            let selectedText = txtView.text(in: textRange)
            let mainString = txtView.text
            let range = (mainString! as NSString).range(of: selectedText!)
            let attribute = NSMutableAttributedString.init(string: mainString!)
            attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 20.0) , range: range)
            txtView.attributedText = attribute
            
        }
    }
    
    @IBAction func btnItalicAction(_ sender: Any) {
        if let textRange = txtView.selectedTextRange {
            let selectedText = txtView.text(in: textRange)
            let mainString = txtView.text
            let range = (mainString! as NSString).range(of: selectedText!)
            let attribute = NSMutableAttributedString.init(string: mainString!)
            attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.italicSystemFont(ofSize: 20.0) , range: range)
            txtView.attributedText = attribute
            
        }
    }
    
    @IBAction func btnPickImageAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
        
        let galleryButton = UIAlertAction(title: "Gallery", style: .default, handler: { (action) -> Void in
            self.picker!.allowsEditing = false
            self.picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(self.picker!, animated: true, completion: nil)
        })
        let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                self.picker!.allowsEditing = false
                self.picker!.sourceType = UIImagePickerController.SourceType.camera
                self.picker!.cameraCaptureMode = .photo
                self.present(self.picker!, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
                alert.addAction(ok)
                
            }
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        })
        alertController.addAction(galleryButton)
        alertController.addAction(cameraButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Image Picker Delegate -
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(
            animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let fullString = txtView.attributedText?.mutableCopy() as? NSMutableAttributedString
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = pickedImage.resizeImage(targetSize: CGSize(width: 150.0, height: 150.0))
            let image1String = NSAttributedString(attachment: image1Attachment)
            guard let selectedRange = txtView.selectedTextRange else {
                return
            }
            // cursorPosition is an Int
            let cursorPosition = txtView.offset(from: txtView.beginningOfDocument, to: selectedRange.start)
            fullString?.insert(image1String, at: cursorPosition)
            txtView.attributedText = fullString
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


