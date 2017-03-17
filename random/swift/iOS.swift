
//
//  JSON 1.0
//  Created by Caleb Hess on 3/4/16.
//

import UIKit
import Foundation

class iOS {
    func export(view: UIViewController, items: [AnyObject]) {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypePostToTwitter, UIActivityTypePostToFacebook]
        view.presentViewController(controller, animated: true, completion: nil)
    }
    
    func qrCode() -> UIImage {
        let text = "thisisaqrcode."
        let data = text.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        let qrcodeImage = filter.outputImage!
        return UIImage(CIImage: qrcodeImage)
    }
}
