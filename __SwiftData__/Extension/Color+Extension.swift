//
//  Color+Extension.swift
//  __SwiftData__
//
//  Created by  Sadi on 11/02/2025.
//

import SwiftUI

extension Color {

    init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else { return nil }
        self.init(uiColor: uiColor)
    }

    func toHexString(includeAlpha: Bool = false) -> String? {
        return UIColor(self).toHexString(includeAlpha: includeAlpha)
    }

}
