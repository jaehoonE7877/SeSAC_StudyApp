//
//  SeSACImageDescription.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/05.
//

import Foundation

enum SeSACImageDescription {
    case sesac
    case background
}

extension SeSACImageDescription {
    var name: [String] {
        switch self {
        case .sesac:
            return ["기본 새싹", "튼튼 새싹", "민트 새싹", "퍼플 새싹", "골드 새싹"]
        case .background:
            return ["하늘 공원", "씨티 뷰", "밤의 산책로", "낮의 산책로", "연극 무대", "라틴 거실", "홈트방", "뮤지션 작업실"]
        }
    }
    
    var description: [String] {
        switch self {
        case .sesac:
            return ["새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다.", "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다.", "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다.", "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다.", "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다."]
        case .background:
            return ["새싹들을 많이 마주치는 매력적인 하늘 공원입니다", "창밖으로 보이는 도시 야경이 아름다운 공간입니다", "어둡지만 무섭지 않은 조용한 산책로입니다", "즐겁고 가볍게 걸을 수 있는 산책로입니다", "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다", "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다", "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다", "여러가지 음악 작업을 할 수 있는 작업실입니다"]
        }
    }
}
