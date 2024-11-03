import Foundation
import UIKit

extension UIColor {
    enum res {
        static let tool: UIColor = .init(named: "tool")!
        static let toolSelected: UIColor = .init(named: "tool_selected")!
        static let toolDisabled: UIColor = .init(named: "tool_disabled")!
        
        static let paletteBeige: UIColor = .init(named: "palette_beige")!
        static let paletteYellow: UIColor = .init(named: "palette_yellow")!
        static let paletteGreen1: UIColor = .init(named: "palette_green1")!
        static let paletteGreen2: UIColor = .init(named: "palette_green2")!
        static let paletteGreen3: UIColor = .init(named: "palette_green3")!
        
        static let paletteRed1: UIColor = .init(named: "palette_red1")!
        static let paletteRed2: UIColor = .init(named: "palette_red2")!
        static let paletteRed3: UIColor = .init(named: "palette_red3")!
        static let paletteRed4: UIColor = .init(named: "palette_red4")!
        static let paletteRed5: UIColor = .init(named: "palette_red5")!
        
        static let paletteOrange1: UIColor = .init(named: "palette_orange1")!
        static let paletteOrange2: UIColor = .init(named: "palette_orange2")!
        static let paletteOrange3: UIColor = .init(named: "palette_orange3")!
        static let paletteOrange4: UIColor = .init(named: "palette_orange4")!
        static let paletteOrange5: UIColor = .init(named: "palette_orange5")!
        
        static let palettePurple1: UIColor = .init(named: "palette_purple1")!
        static let palettePurple2: UIColor = .init(named: "palette_purple2")!
        static let palettePurple3: UIColor = .init(named: "palette_purple3")!
        static let palettePurple4: UIColor = .init(named: "palette_purple4")!
        static let palettePurple5: UIColor = .init(named: "palette_purple5")!
        
        static let paletteBlue1: UIColor = .init(named: "palette_blue1")!
        static let paletteBlue2: UIColor = .init(named: "palette_blue2")!
        static let paletteBlue3: UIColor = .init(named: "palette_blue3")!
        static let paletteBlue4: UIColor = .init(named: "palette_blue4")!
        static let paletteBlue5: UIColor = .init(named: "palette_blue5")!
        
        static let paletteWhite: UIColor = .init(named: "palette_white")!
        static let paletteBlack: UIColor = .init(named: "palette_black")!
        
        static let briefPalette: [UIColor] = [
            .paletteWhite, .paletteOrange5, .paletteBlack, .paletteBlue5
        ]
        
        static let fullPalette: [UIColor] = [
            .paletteBeige, .paletteYellow, .paletteGreen1, .paletteGreen2, .paletteGreen3,
            .paletteRed1, .paletteRed2, .paletteRed3, .paletteRed4, .paletteRed5,
            .paletteOrange1, .paletteOrange2, .paletteOrange3, .paletteOrange4, .paletteOrange5,
            .palettePurple1, .palettePurple2, .palettePurple3, .palettePurple4, .palettePurple5,
            .paletteBlue1, .paletteBlue2, .paletteBlue3, .paletteBlue4, .paletteBlue5
        ]
    }
}
