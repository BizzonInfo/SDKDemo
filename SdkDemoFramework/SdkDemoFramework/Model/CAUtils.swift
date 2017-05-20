//  CAUtils.swift
//  CalendarApp
//
//  Created by BonMac1 on 14/10/15.
//  Copyright © 2015 bon. All rights reserved.
//

import UIKit
import AVFoundation
class CAUtils: NSObject {
    class func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    func getBlueColor()->UIColor{
        return UIColor(red:0.16, green:0.58, blue:0.85, alpha:1.0)
    }
    func getSelectedCellBackGroundColor()->UIColor{
        return UIColor(red:0.76, green:0.87, blue:0.98, alpha:1.0)
    }
    class func getDeviceUniqueId()->String{
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    class func getDeviceVersion()->String?{
        let deviceVersion=UIDevice.current.systemVersion
        return deviceVersion
    }
    class func getBuildNumber()->String{
        return   Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
//    class func showAlertViewWithTitle(_ title:String?,message:String?,cancelButtonTitle:String?){
//        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
//    }
//    class func showAlertViewControllerWithTitle(_ title:String?,message:String?,cancelButtonTitle:String?){
//        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
//        let nav = appDelegate.window?.rootViewController
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: { (alert) -> Void in
//            nav?.dismiss(animated: true, completion: nil)
//        }))
//        nav?.present(alert, animated: false, completion: nil)
//    }
    
    class func getUDID()->String{
        return String(describing: UserDefaults.standard.value(forKey: device_token))
    }
    class func checkEmailValidation(_ stringEmail:String)->Bool{
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: stringEmail)
    }
    class func showLoadingViewWithTitle(_ title:String?){
        var loadingView : SwiftLoader.Config = SwiftLoader.Config()
        loadingView.size = 120
        loadingView.backgroundColor=UIColor.clear
        loadingView.spinnerColor=UIColor.lightGray
        loadingView.titleTextColor = UIColor.white
        loadingView.spinnerLineWidth=2.0
        loadingView.foregroundColor=UIColor.black
        loadingView.foregroundAlpha=0.75
        SwiftLoader.setConfig(loadingView)
        SwiftLoader.show(title, animated: true)
    }
    class func removeLoadingView(_ title:String?){
        if(title==nil){
            SwiftLoader.hide()
        }
        else{
            SwiftLoader.show(title, animated: false)
            delay(seconds: 1.2) { () -> () in
                SwiftLoader.hide()
            }
        }
    }
    class func getSildeMenuOptionChangeNotificationKey()->String{
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            return sideMenuOptioniDevice
        }
        else{
            return sideMenuOptioniDevice
        }
    }
    class func getColorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    class func isiPhone()->Bool{
        if(UIDevice.current.userInterfaceIdiom==UIUserInterfaceIdiom.pad){
            return false
        }
        else{
            return true
        }
    }
    class func getFileName(_ prefixName:String?,Extension:String?)->String {
        let  dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd_MM_yy_hh_mm_ss_SSS"
        let uniqueFileName = dateFormatter.string(from: Date())
        let fileName = prefixName!+"_"+uniqueFileName+Extension!
        return fileName
    }
    class func getProfilePicPlaceHolder()->UIImage{
        return UIImage(named: "profilePic")!
    }
    class func createNewFolderWithName(_ folderName:String)->String{
        let dataPath = CAUtils.getDocumentDirectoryPath() + folderName
        let directoryStatus : Bool = FileManager.default.fileExists(atPath: dataPath)
        if !directoryStatus {
            do {
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                let error = error as NSError
                print(error)
            }
        }
        return dataPath
    }
    
//    class func getProfilePicFromDirectory()->UIImage{
//        let user_id = PAAMSUser.amsUser.userable_id!
//        let dataPath = CAUtils.getDocumentDirectoryPath() + "/AMS_Profile_Pic/\(user_id)/ProfilePic.jpeg"
//        let image = UIImage(contentsOfFile: dataPath)
//        if image != nil {
//            return image!
//        }
//        else{
//            return UIImage(named: "Profile")!
//        }
//    }

    
    class func getDocumentDirectoryPath()->String{
        let arrayPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory  = arrayPaths.first
        return documentDirectory!
    }
    class func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    class func getDateTimeFromString(_ stringDate:String)->Date{
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "hh:mm a"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.date(from: stringDate)!
    }
    class func getDateFromString(_ stringDate:String)->Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="dd-MM-yyyy"
        let local = Locale(identifier: "en_US")
        dateFormatter.locale=local
        if let date = dateFormatter.date(from: stringDate) {
            return date
        }else {
            return Date()
        }
    }
    class func getUpdatedAtDate(_ stringDate:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        let local = Locale(identifier: "en_US")
        dateFormatter.locale=local
        return dateFormatter.date(from: stringDate)!
    }
    class func getUpdatedAtDateString(_ date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.string(from: date)
    }
    class func getStringTimeFromDate(_ date:Date)->String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm:ss"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.string(from: date)
    }
    class func getCurrentDateTime()->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        let currentDataString = dateFormatter.string(from: Date())
        return dateFormatter.date(from: currentDataString)!
    }
    class func getStringFromDate(_ date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat="dd-MM-yyyy"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.string(from: date)
    }
    
    class func changeFormatOfStringDateToString(dateString:String)-> String {
        let startsDate = dateString
        let arraySeperatedDate = startsDate.components(separatedBy: "-")
        let formattedDateString = "\(arraySeperatedDate[2])-"+"\(arraySeperatedDate[1])-"+"\(arraySeperatedDate[0])"
        return formattedDateString
    }
    class func getDateStringFromDate(_ date:Date)->String{ 
        let formatter = DateFormatter()
        //        formatter.dateStyle = .FullStyle
        //        formatter.timeStyle = .NoStyle
        formatter.dateFormat = "dd-MM-yyyy"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.string(from: date)
    }
    class func getExtensionOFFileName(_ fileName:String)->String
    {
        let arrayName = fileName.components(separatedBy: ".")
        let type = arrayName.last!
        return type
    }
//    class func getAttachedFileUrlString(activity_id:String,fileName:String)->String{
//        let urlString = activityAttachFileUrl+"\((activity_id))/" + fileName
//        return urlString
//    }
    class func getDocumentDirectoryFilePath(_ activity_id:String,user_id:String,file_name:String)->String{
        let documentDirectoryPath = CAUtils.getDocumentDirectoryPath()
        let path = "\(documentDirectoryPath)/MyToDo_ActivityFiles/\(user_id)/\(activity_id)/\(file_name)"
        print(path)
        return path
    }
    func videoSnapshot(_ filePathLocal: NSString) -> UIImage? {
        
        let videoURL = URL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    func getPreviewImageForVideoAtURL(_ videoURL: URL, atInterval: Int) -> UIImage? {
        print("Taking pic at \(atInterval) second")
        let asset = AVAsset(url: videoURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(atInterval), 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let frameImg = UIImage(cgImage: img)
            return frameImg
        } catch {
            /* error handling here */
        }
        return nil
    }
    class func getCategoryUsingIndexPath(_ indexPath:IndexPath)->String{
        let section = (indexPath as NSIndexPath).section+1
        return "\(section)"
    }
    class func isWhiteSpace(_ input: String) -> Bool {
        let letters = CharacterSet.alphanumerics
        let phrase = input
        let range = phrase.rangeOfCharacter(from: letters)
        return range == nil ? true : false
    }
    class func trimWhiteSpaceInString(_ string:String)->String{
        let trimmedString = string.trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmedString
    }
//    class func showToastWithTitle(_ title:String){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let winDow = appDelegate.window?.rootViewController
//        winDow?.view.makeToast(title, duration: 2, position: ToastPosition.bottom)
//    }
    class func getResizedImagefromImage(_ image:UIImage?,scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    class func getDoneToolBarButton(tableView:UITableViewController,target:Selector?)-> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 103/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: tableView, action: target)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: tableView, action: nil)
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    class func getSelectAndDoneToolBarButton(tableView:UITableViewController,target1:Selector?,target2:Selector?,target3:Selector?,target4:Selector?)-> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 103/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        let arrowButtonRight = UIBarButtonItem(title: " > ", style: .plain, target: tableView, action: target3)
        let arrowButtonLeft = UIBarButtonItem(title: " < ", style: .plain, target: tableView, action: target4)
        let doneButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: tableView, action: target1)
        let selectButton = UIBarButtonItem(title: "Select", style: .plain, target: tableView, action: target2)
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([selectButton,arrowButtonLeft,arrowButtonRight,flexibleSpaceBarButton,doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    class func setBackgroundForTableView(tableView:UITableView){
        let imageView = UIImageView(image: UIImage(named: BackgroundImage))
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 1.0
        tableView.backgroundView = imageView
    }
    class func setBackgroundImage(imageName:String){
        BackgroundImage = imageName
    }
    
    class func getRandomColor() -> UIColor {
        let randomRed = CGFloat(drand48())
        let randomGreen = CGFloat(drand48())
        let randomBlue = CGFloat(drand48())
        //        print("red: \(randomRed), green: \(randomGreen) , blue: \(randomBlue)")
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    //    class func isNetworkAvailable()->Bool {
//        let status = CAReachability().connectionStatus()
//        switch status {
//        case .unknown, .offline:
//            CAUtils.showToastWithTitle("Connect to network")
//            return false
//        case .online(.wwan):
//            return true
//        case .online(.wiFi):
//            return true
//        }
//    }

}
// trying to change font color by finding the average color
extension UIImage {
    func areaAverage() -> UIColor {
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        if #available(iOS 9.0, *) {
            // Get average color.
            let context = CIContext()
            let inputImage = ciImage ?? CoreImage.CIImage(cgImage: cgImage!)
            let extent = inputImage.extent
            let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
            let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
            let outputImage = filter.outputImage!
            let outputExtent = outputImage.extent
            assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
            
            // Render to bitmap.
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        } else {
            // Create 1x1 context that interpolates pixels when drawing to it.
            let context = CGContext(data: &bitmap, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)!
            let inputImage = cgImage ?? CIContext().createCGImage(ciImage!, from: ciImage!.extent)
            
            // Render to bitmap.
            context.draw(inputImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: String.Encoding.utf8)
            else { return nil }
        do {
            let attributedOptions : [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
                NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue) as AnyObject
            ] //NSNumber(value: String.Encoding.utf8.rawValue)
            return try NSAttributedString(data: data, options: attributedOptions, documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
