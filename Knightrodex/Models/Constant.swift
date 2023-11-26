//
//  Constant.swift
//  Knightrodex
//
//  Created by Max Bagatini Alves on 11/6/23.
//

import Foundation

enum Constant {
    // API
    static let apiPath = "https://knightrodex-49dcc2a6c1ae.herokuapp.com/api"
    static let loginEndpoint = "/login"
    static let badgeEndpoint = "/addbadge"
    static let signUpEndpoint = "/signup"
    static let hintsEndpoint = "/gethints"
    static let userProfileEndpoint = "/showuserprofile"
    static let searchEmailEndpoint = "/searchemail"
    static let getActivityEndpoint = "/getactivity"
    static let sendResetCodeEndpoint = "/passwordsend"
    static let updatePasswordEndpoint = "/passwordupdate"
    static let followUserEndpoint = "/followuser"
    static let unfollowUserEndpoint = "/unfollowuser"
    static let updateProfilePictureEndpoint = "/updateprofilepicture"
    
    // Cloudinary
    static let cloudinaryCloudName = "knightrodex"
    static let cloudinaryApiKey = "584478179859476"
    static let cloudinaryApiSecret = "b_pogwWUC-SblGXRaBWvYOPDdoM"
    static let cloudinaryImgFolder = "knightrodex_users"
}
