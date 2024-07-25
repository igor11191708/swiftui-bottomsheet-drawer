//
//  BottomSheet.swift
//
//
//  Created by Igor Shelopaev on 20.07.2022.
//

import SwiftUI


/// Bottom sheet drawer widget
@available(iOS 15.0, macOS 12.0, watchOS 10.0, *)
public struct BottomSheet<Content : View>: IBottomSheetView {

    private typealias Position = BottomSheetPosition

    /// Offset relatively the base
    @State private var offset: CGFloat = 0

    /// Current position
    @State private var position: BottomSheetPosition

    /// Animate move
    private var doAnimation: Bool = true
    
    /// Hide or show drag button
    private var showDragButton: Bool = true
    
// MARK: - Config

    /// View
    let content: Content

    /// Visible height of the sheet drawer
    let shift: CGFloat

    /// Space from the very top to the max height drawer can reach
    let topIndentation: CGFloat

    ///Available space to do dragging
    let draggerHeight: CGFloat

    /// Dragging length after which trigger move to the next level depends on the direction of moving
    let dragThresholdToAct: CGFloat

    // MARK: - Lifecircle

    /// Init component
    /// - Parameters:
    ///   - content: View content
    ///   - shift: Visible height of the sheet drawer
    ///   - topIndentation: Space from the very top to the max height drawer can reach
    ///   - showDragButton: Hide or show drag button
    ///   - draggerHeight: Space sensitive for dragging
    ///   - dragThresholdToAct: Dragging length after which trigger move to the next level depends on the direction of moving
    ///   - doAnimation: Animate move
    public init(
        content: Content,
        shift: CGFloat = 88,
        topIndentation: CGFloat = 50,
        draggerHeight: CGFloat = 50,
        dragThresholdToAct: CGFloat = 25
    ) {
        self.content = content
        self.topIndentation = max(topIndentation, 0)
        self.shift = max(shift, 25)
        self.draggerHeight = min(draggerHeight, 25)
        self.dragThresholdToAct = max(dragThresholdToAct, 0)

        self._position = State(initialValue: .down(max(shift, 25)))
    }

    /// The content and behavior of the view
    public var body: some View {
        GeometryReader { proxy in
            let h = proxy.size.height

            ZStack(alignment: .top) {
                backgroundTpl(proxy.size)
                content
            }
                .offset(y: h - shift)
                .offset(y: -offset)
                .overlay(dragger(h), alignment: .top)
        }.ignoresSafeArea(.all, edges: .bottom)
            .preference(key: BottomSheetPositionKey.self, value: position)
            .frame(minHeight: shift)
            .messureSize(updateSheetSize)
    }

    // MARK: - Private
    
    /// Background Tpl
    /// - Parameter size: Available size
    @ViewBuilder
    func backgroundTpl(_ size : CGSize) -> some View{
        let h = size.height
        let w = size.width
        Color.clear.background(.thinMaterial)
            .clipShape(RoundedCornersShape(tl: 30, tt: 30, width: w, height: h))
            .shadow(color: .primary.opacity(0.05), radius: 2, x: 1, y: -2)
    }
    
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
            let limit = calculateLimit(h)
            let position = position.update(height: limit + shift)
            if limit != offset {
                updateOffset(width: limit)
                self.position = position
            }
        #endif
    }

    /// Get limit by new height
    /// - Window size is changed then need to recalculate limit
    /// - Reset drawer position if drag length is not enough to change the drawer position
    /// - Parameter maxH: Available height
    /// - Returns: Reverted offset value
    private func calculateLimit(_ height: CGFloat) -> CGFloat {
        var limit: CGFloat = 0
        let maxH = height - shift
        let half = maxH / 2

        if position.isUp {
            limit = maxH - topIndentation
        } else if position.isMiddle {
            limit = half
        }

        return limit
    }

    /// Get spect for the next position
    /// - Parameters:
    ///   - maxH: Available height
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
    ///   - height: Available height
    private func onEndDrag(_ value: DragGesture.Value, _ height: CGFloat) {
        let start = value.startLocation.y
        let end = value.location.y
        let up = start - end > 0
        let delta = abs(start - end)
        var limit: CGFloat = 0

        if delta < dragThresholdToAct {
            limit = calculateLimit(height)
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
            Capsule()
                .fill(Color.primary)
                .frame(width: 80, height: 5)
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

public extension BottomSheet {
    
    // MARK: - Builder methods
    
    /// Hide dragging button
    /// - Returns: Sheet with hidden button
    func hideDragButton() -> Self{
        var view = self
        view.showDragButton = false
        return view
    }
    
    
    ///  Turn off animation
    /// - Returns: Sheet without animation
    func withoutAnimation() -> Self{
        var view = self
        view.doAnimation = false
        return view
    }
    
    // MARK: - Event methods
    
    /// Handler for changing the sheet position
    /// - Parameter fn: callback to react
    /// - Returns: View
    func onPositionChanged(_ fn: @escaping (BottomSheetPosition) -> ()) -> some View {
        self.onPreferenceChange(BottomSheetPositionKey.self) {
            fn($0)
        }
    }
}

#if DEBUG
    struct BottomSheet_Previews: PreviewProvider {
        static var previews: some View {
            ZStack {
                BottomSheet(content: Color.clear.background(.thinMaterial))
            }
        }
    }
#endif

