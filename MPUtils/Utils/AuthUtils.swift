//
//  AuthUtils.swift
//

import Foundation
import Photos

public class AuthUtils {
    
    public class func authorizePhotoLibrary(_ completion: @escaping (Bool) -> Void) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
            
        case .denied, .restricted:
            completion(false)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                GCDUtils.main {
                    if status == .authorized {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    public class func authorizeCaptureDeviceForMediaType(_ mediaType: String, completion: @escaping (Bool) -> Void) {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: mediaType))
        switch status {
        case .authorized:
            completion(true)
            
        case .denied, .restricted:
            completion(false)
            
        case .notDetermined:
            if AVCaptureDevice.devices(for: AVMediaType(rawValue: mediaType)).count > 0 {
                AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: mediaType), completionHandler: { (granted) in
                    GCDUtils.main {
                        completion(granted)
                    }
                })
            } else {
                GCDUtils.main {
                    completion(false)
                }
            }
        }
    }
    
}



