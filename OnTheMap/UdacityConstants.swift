//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Layne Faler on 6/20/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

extension UdacityCilent {

    // MARK: Common

    struct UdacityCommon {
        static let SignUpURL = "https://www.udacity.com/account/auth#!/signup"
    }

    // MARK: Errors

    struct UdacityErrors {
        static let Domain = "UdacityClient"
        static let UnableToLogin = "Unable to login."
        static let UnableToLogout = "Unable to logout."
        static let NoUserData = "Cannot access user data."
    }

    // MARK: Components

    struct UdacityComponents {
        static let Scheme = "https"
        static let Host = "www.udacity.com"
        static let Path = "/api"
    }

    // MARK: Methods

    struct UdacityMethods {
        static let Session = "/session"
        static let Users = "/users"
    }

    // MARK: Cookies

    struct UdacityCookies {
        static let XSRFToken = "XSRF-TOKEN"
    }

    // MARK: HeaderKeys

    struct UdacityHeaderKeys {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let XSRFToken = "X-XSRF-TOKEN"
    }

    // MARK: HeaderValues

    struct UdacityHeaderValues {
        static let JSON = "application/json"
    }

    // MARK: HTTPBodyKeys

    struct UdacityHTTPBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }

    // MARK: JSONResponseKeys

    struct UdacityJSONResponseKeys {
        static let Account = "account"
        static let UserKey = "key"
        static let Status = "status"
        static let Session = "session"
        static let Error = "error"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
}

