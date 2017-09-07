//
//  Target.swift
//  Test
//
//  Created by Atkinson, Sean C on 7/9/17.
//  Copyright © 2017 JPMorganChase. All rights reserved.
//

import Foundation

enum TargetUIStyle {
    case meercat
    case bomb
    case baby
    case custom(String) // or something?
}
struct Target {

    let uiStyle: TargetUIStyle
    let onTap: ()->Void
    let onMiss: ()->Void
}
