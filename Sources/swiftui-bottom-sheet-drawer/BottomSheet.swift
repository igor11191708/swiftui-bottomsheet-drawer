//
//  BottomSheet.swift
//
//
//  Created by Igor Shelopaev on 20.07.2022.
//

import SwiftUI


/// Bottom sheet widget
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 6.0, *)
public struct BottomSheet<Content : View>: View {

    private typealias Position = BottomSheetPosision

    @State private var offset: CGFloat = 0

    @State private var position: BottomSheetPosision


// MARK: - Config

    /// View
    let content: Content

    /// Visible height of the sheet drawer
    let shift: CGFloat

    /// Space from the very top to the max height drawer can reach
    let topIndentation: CGFloat

    /// Hide or show drag button
    let showDragButton: Bool

    ///Avalable space to do dragging
    let draggerHeight: CGFloat

    /// Dragging length after which trigger move to the next level depends on the direction of moving
    let dragThresholdToAct: CGFloat

    /// Animate move
    let doAnimation: Bool

    // MARK: - Lifecircle

    /// Init component
    /// - Parameters:
    ///   - content: View content
    ///   - shift: Visible height of the sheet drawer
    ///   - topIndentation: Space from the very top to the max height drawer can reach
    ///   - showDragButton: Hide or show drag button
    ///   - draggerHeight: Space sensitive for dragging
    ///   - dragThresholdToAct: Dragging lenght after wich trigger move to the next level deppends on the direction of moving
    ///   - doAnimation: Animate move
    public init(
        content: Content,
        shift: CGFloat = 88,
        topIndentation: CGFloat = 50,
        showDragButton: Bool = true,
        draggerHeight: CGFloat = 50,
        dragThresholdToAct: CGFloat = 25,
        doAnimation: Bool = true
    ) {
        self.content = content
        self.topIndentation = max(topIndentation, 0)
        self.shift = max(shift, 25)
        self.showDragButton = showDragButton
        self.draggerHeight = min(draggerHeight, 25)
        self.dragThresholdToAct = max(dragThresholdToAct, 0)
        self.doAnimation = doAnimation

        self._position = State(initialValue: .down(max(shift, 25)))
    }


    /// The content and behavior of the view
    public var body: some View {
        GeometryReader { proxy in
            let h = proxy.size.height
            let w = proxy.size.width

            ZStack(alignment: .top) {
                Color.clear.background(.thinMaterial)
                    .clipShape(RoundedCornersShape(tl: 30, tt: 30, width: w, height: h))
                    .shadow(color: .primary.opacity(0.05), radius: 2, x: 1, y: -2)
                content
            }
                .offset(y: h - shift)
                .offset(y: -offset)
                .overlay(dragger(h), alignment: .top)
        }.ignoresSafeArea(.all, edges: .bottom)
            .preference(key: BottomSheetPosisionKey.self, value: position)
            .frame(minHeight: shift)
            .messureSize(updateSheetSize)
    }

    // MARK: - Private

    /// Define gesture operation processing
    /// - Parameter height: Available height
    /// - Returns: Gesture
    private func gesture(_ height: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged {
            let maxH = height - shift
            offset = maxH - $0.location.y.clamped(topIndentation, height - shift)
        }
            .onEnded { value in
            onEndDrag(value, height)
        }
    }


    /// Update sheet size in case of macOS window size change
    /// - Parameter size: Current size
    private func updateSheetSize(size: CGSize) {
        #if os(macOS)
            let h = size.height
            let limit = revertLimit(h)
            let position = position.update(height: limit + shift)
            if limit != offset {
                updateOffset(width: limit)
                self.position = position
            }
        #endif
    }


    /// Reset drawer position if drag lenght is not enoght to change the drawer position
    /// - Parameter maxH: Avalable height
    /// - Returns: Reverted offset value
    private func revertLimit(_ height: CGFloat) -> CGFloat {

        var limit: CGFloat = 0
        let maxH = height - shift
        let half = maxH / 2

        if position.isUp {
            limit = maxH - topIndentation
        } else if position.isModdle {
            limit = half
        }

        return limit
    }


    /// Get spect for the next position
    /// - Parameters:
    ///   - maxH: Avalable height
    ///   - up: Direction
    /// - Returns: Bunch of specs for the next position
    private func moveNext(_ height: CGFloat, up: Bool) -> (limit: CGFloat, position: Position) {
        var limit: CGFloat = 0
        var position: Position = .down(shift)
        let maxH = height - shift
        let half = maxH / 2

        if up {
            if offset > half {
                limit = maxH - topIndentation
                position = .up(limit + shift)
            } else {
                limit = half
                position = .middle(half + shift)
            }
        } else {
            if offset > half {
                limit = half
                position = .middle(half + shift)
            }
        }

        return (limit: limit, position: position)
    }

    /// Process end drag
    /// - Parameters:
    ///   - value: Bunch of drag values on end drag
    ///   - height: Avalable height
    private func onEndDrag(_ value: DragGesture.Value, _ height: CGFloat) {
        let start = value.startLocation.y
        let end = value.location.y
        let up = start - end > 0
        let delta = abs(start - end)
        var limit: CGFloat = 0

        if delta < dragThresholdToAct {
            limit = revertLimit(height)
        } else {
            let next = moveNext(height, up: up)
            limit = next.limit
            position = next.position
        }

        updateOffset(width: limit)
    }


    /// Update offset with new limit
    /// - Parameter limit: New limit
    private func updateOffset(width limit: CGFloat) {
        if doAnimation {
            withAnimation(.easeInOut(duration: 0.25)) {
                offset = limit
            }
        } else {
            offset = limit
        }
    }

    /// Dragger button tpl
    @ViewBuilder
    private var draggerButton: some View {
        if showDragButton {
            VStack {
                Capsule()
                    .fill(Color.primary)
                    .frame(width: 80, height: 5)
            }
        } else {
            EmptyView()
        }
    }


    /// Create draggable surface
    /// - Parameter h: The height of the draggable surface
    /// - Returns: Draggable surface
    private func dragger(_ height: CGFloat) -> some View {
        Color.white
            .opacity(0.001)
            .frame(height: 50)
            .overlay(draggerButton, alignment: .top)
            .offset(y: height - shift)
            .offset(y: -offset)
            .gesture(gesture(height))
    }

}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(content: Color.clear.background(.thinMaterial))
    }
}