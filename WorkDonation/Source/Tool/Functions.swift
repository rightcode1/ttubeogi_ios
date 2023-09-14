//
//  Functions.swift
//  dontWorry
//
//  Created by hoonKim on 09/03/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation

enum ImageType {
    case storeBanner
    case storeDetail
    case storeAreaBanner
    case storeAreaBannerDetail
    case storeAreaSlide
    case review
    case eventReview
    case homePopup
    case hotPickMain
    case hotPickDetail
    case homeTopEvent
    case homeTopEventDetail
}

func getImageURL(pk: String, type: ImageType) -> URL {
    switch type {
    case .homeTopEvent:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/topevent/list/\(pk).png")!
    case .homeTopEventDetail:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/topevent/focus/\(pk).png")!
    case .storeBanner:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/company/main/\(pk).png")!
    case .storeDetail:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/company/focus/\(pk).png")!
    case .storeAreaSlide:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/company/list/\(pk).png")!
    case .storeAreaBanner:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/banner/list/\(pk).png")!
    case .storeAreaBannerDetail:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/banner/focus/\(pk).png")!
    case .review:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/review/\(pk).jpg")!
    case .eventReview:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/homeevent_review/\(pk).jpg")!
    case .homePopup:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/event/popup/\(pk).png")!
    case .hotPickMain:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/pick/thumbnail/\(pk).png")!
    case .hotPickDetail:
        return URL(string: "\(ApiEnvironment.baseUrl)/img/pick/focus/\(pk).png")!
    }
}

