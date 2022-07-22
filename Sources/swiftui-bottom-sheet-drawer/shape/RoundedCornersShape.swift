//
//  RoundedCornersShape.swift
//
//
//  Created by Igor Shelopaev on 21.07.2022.
//

import SwiftUI

/// Create rounded conner shape with custom corner radius for every conner
struct RoundedCornersShape: Shape {

    // MARK: - Config

    let tl: CGFloat //topLeading

    let tt: CGFloat //topTrailing

    let bl: CGFloat //bottomLeading

    let bt: CGFloat //bottomTrailing

    let width: CGFloat //container width

    let height: CGFloat //container height

    // MARK: - Life circle

    init(
        tl: CGFloat = 0,
        tt: CGFloat = 0,
        bl: CGFloat = 0,
        br: CGFloat = 0,
        width: CGFloat,
        height: CGFloat) {
        self.tl = tl
        self.tt = tt
        self.bl = bl
        self.bt = br
        self.width = width
        self.height = height
    }

    
    /// Create curcve with defined corner radius custom for every corner
    /// - Parameter rect: outer space
    /// - Returns: Curve path
    func path(in rect: CGRect) -> Path {
        Path { path in

            let w = width
            let h = height

            let tl = min(min(self.tl, h / 2), w / 2)
            let tt = min(min(self.tt, h / 2), w / 2)
            let bl = min(min(self.bl, h / 2), w / 2)
            let bt = min(min(self.bt, h / 2), w / 2)

            path.move(to: CGPoint(x: w / 2.0, y: 0))
            path.addLine(to: CGPoint(x: w - tt, y: 0))
            path.addArc(center: CGPoint(x: w - tt, y: tt), radius: tt,
                startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

            path.addLine(to: CGPoint(x: w, y: h - bt))
            path.addArc(center: CGPoint(x: w - bt, y: h - bt), radius: bt,
                startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

            path.addLine(to: CGPoint(x: bl, y: h))
            path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

            path.addLine(to: CGPoint(x: 0, y: tl))
            path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            path.closeSubpath()

        }
    }
}
