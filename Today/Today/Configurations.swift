//
//  Configurations.swift
//  Today
//
//  Created by 박준하 on 2023/02/04.
//

import Foundation
import UIKit
import AVFoundation
import CoreLocation
import AudioToolbox
import SystemConfiguration
import GPUImage
import Photos


// ------------------------------------------------
// MARK: - REPALCE THE STRING BELOW TO SET YOUR OWN APP NAME
// ------------------------------------------------
let APP_NAME = "Today"


// ------------------------------------------------
// MARK: - REPLACE THE PRODUCT IDENTIFIER BELOW WITH THE ONE YOU'LL SET IN THE IAP SECTION OF YOUR APP'S App Store Connect PAGE
// ------------------------------------------------
let IAP_PRODUCT_ID = "com.snapback.pro"


// ------------------------------------------------
// MARK: - CHANGE THE NUMBER OF PHOTO FRAMES ACCORDINGLY TO THE "photo_frame" IMAGES YOU HAVE IN THE Assets.xcassets FOLDER
// ------------------------------------------------
let PHOTO_FRAMES_NUMBER = 8


// ------------------------------------------------
// MARK: - LIST OF CAMERAS
// ------------------------------------------------
let listOfCameras = [
    "Leika Day__Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.",                            // Cam1
    "Icy Night__Dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",         // Cam2
    "Blacky__Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",   // Cam3
    "Tooner__Adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum.",  // Cam4
    "Pink Blink__Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Adipiscing elit, ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",           // Cam5
    "Blurry__Do eiusmod tempor incididunt ut labore et dolore magna aliqua. Adipiscing elit, so ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",                // Cam6
    "Vintage__Eiusmod tempor incididunt do ut labore et dolore magna aliqua. Adipiscing elit, so ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",               // Cam7
    "Purple Rain__Tempor incididunt do ut labore et dolore magna aliqua. Adipiscing elit, so ut enim ad minim veniam, quis nostrud exercitation ullamco amet laboris nisi ut aliquip ex ea commodo consequat.",              // Cam8
    "Red Room__Tempor incididunt do ut labore et dolore magna aliqua. Adipiscing elit, so ut enim ad minim veniam, quis nostrud exercitation ullamco amet laboris nisi ut aliquip ex ea commodo consequat.",                 // Cam9
    "Dark Sketch__Tempor incididunt do ut labore et dolore magna aliqua. Adipiscing elit, so ut enim ad minim veniam, quis nostrud exercitation ullamco amet laboris nisi ut aliquip ex ea commodo consequat.",              // Cam10

    // YOU CAN ADD NEW CAMERA NAMES AND DESCRIPTION HERE...
]
