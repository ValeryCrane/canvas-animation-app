import Foundation
import UIKit

protocol DrawingToolBarDelegate: AnyObject {
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSelectTool tool: (any DrawingTool)?)
}

extension DrawingToolBar {
    private enum DrawingToolType {
        case pencil
        case eraser
        case square
        case circle
        case triangle
        case arrow
        
        static func fromChooseShapeContextMenuShape(_ shape: ChooseShapeContextMenu.Shape) -> Self {
            switch shape {
            case .square:
                return .square
            case .circle:
                return .circle
            case .triangle:
                return .triangle
            case .arrow:
                return .arrow
            }
        }
        
        func chooseShapeContextMenuShape() -> ChooseShapeContextMenu.Shape? {
            switch self {
            case .square:
                return .square
            case .circle:
                return .circle
            case .triangle:
                return .triangle
            case .arrow:
                return .arrow
            case .pencil, .eraser:
                return nil
            }
        }
    }
}

extension DrawingToolBar {
    private enum Constants {
        static let colorPickerButtonHeight: CGFloat = 32
        static let colorPickerButtonWidth: CGFloat = 32
    }
}

final class DrawingToolBar: CustomToolBar {
    weak var delegate: DrawingToolBarDelegate?
    
    private let pencilButton = ToolControl(image: .res.pencil)
    private let brushButton = ToolControl(image: .res.brush)
    private let eraserButton = ToolControl(image: .res.eraser)
    private let instrumentsButton = ToolControl(image: .res.instruments)
    private let colorPickerButton: ColorPickerControl
    
    private var isShapesContextMenuVisible: Bool = false
    private var isColorsContextMenuVisible: Bool = false
    
    private var toolType: DrawingToolType? {
        didSet {
            if toolType != oldValue {
                notifyDelegateAboutToolChange()
            }
        }
    }
    
    private var strokeColor: UIColor {
        didSet {
            if strokeColor != oldValue {
                notifyDelegateAboutToolChange()
            }
        }
    }
    
    private var strokeWidth: CGFloat {
        didSet {
            if strokeWidth != oldValue {
                notifyDelegateAboutToolChange()
            }
        }
    }
    
    init(
        initialStrokeColor: UIColor,
        initialStrokeWidth: CGFloat,
        delegate: DrawingToolBarDelegate? = nil
    ) {
        self.delegate = delegate
        self.colorPickerButton = .init(color: initialStrokeColor)
        self.strokeColor = initialStrokeColor
        self.strokeWidth = initialStrokeWidth
        
        super.init(centerItems: [
            pencilButton, brushButton, eraserButton, instrumentsButton, colorPickerButton
        ])
        
        configureButtons()
        setColorPickerButtonDimensions()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissContextMenusAndResetState() {
        super.dismissContextMenus()
        
        isShapesContextMenuVisible = false
        isColorsContextMenuVisible = false
    }
    
    private func clearSelection() {
        [pencilButton, brushButton, eraserButton, instrumentsButton, colorPickerButton].forEach {
            $0.isSelected = false
        }
    }
    
    private func configureButtons() {
        pencilButton.addTarget(self, action: #selector(didTapPencilButton(_:)), for: .touchUpInside)
        brushButton.addTarget(self, action: #selector(didTapBrushButton(_:)), for: .touchUpInside)
        eraserButton.addTarget(self, action: #selector(didTapEraserButton(_:)), for: .touchUpInside)
        instrumentsButton.addTarget(self, action: #selector(didTapInstrumentsButton(_:)), for: .touchUpInside)
        colorPickerButton.addTarget(self, action: #selector(didTapColorPickerButton(_:)), for: .touchUpInside)
    }
    
    private func setColorPickerButtonDimensions() {
        colorPickerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorPickerButton.widthAnchor.constraint(equalToConstant: Constants.colorPickerButtonWidth),
            colorPickerButton.heightAnchor.constraint(equalToConstant: Constants.colorPickerButtonHeight)
        ])
    }
    
    private func notifyDelegateAboutToolChange() {
        switch toolType {
        case .pencil:
            delegate?.drawingToolBar(self, didSelectTool: PencilDrawingTool(
                strokeColor: strokeColor, strokeWidth: strokeWidth
            ))
        case .eraser:
            delegate?.drawingToolBar(self, didSelectTool: EraserDrawingTool(
                strokeWidth: 10
            ))
        case .square:
            // TODO.
            break
        case .circle:
            // TODO.
            break
        case .triangle:
            // TODO.
            break
        case .arrow:
            // TODO.
            break
        case nil:
            delegate?.drawingToolBar(self, didSelectTool: nil)
        }
    }
    
    @objc
    private func didTapPencilButton(_ sender: ToolControl) {
        dismissContextMenusAndResetState()
        clearSelection()
        
        if !pencilButton.isSelected {
            toolType = .pencil
            pencilButton.isSelected = true
        }
    }
    
    @objc
    private func didTapBrushButton(_ sender: ToolControl) {
        // TODO.
    }
    
    @objc
    private func didTapEraserButton(_ sender: ToolControl) {
        dismissContextMenusAndResetState()
        clearSelection()
        
        if !eraserButton.isSelected {
            toolType = .eraser
            eraserButton.isSelected = true
        }
    }
    
    @objc
    private func didTapInstrumentsButton(_ sender: ToolControl) {
        guard !isShapesContextMenuVisible else { return }
        
        dismissContextMenusAndResetState()
        colorPickerButton.isSelected = false
        instrumentsButton.isSelected = true
        
        if let toolType, let shape = toolType.chooseShapeContextMenuShape() {
            instrumentsButton.showContextMenu(ChooseShapeContextMenu(delegate: self, shape: shape))
        } else {
            instrumentsButton.showContextMenu(ChooseShapeContextMenu(delegate: self))
        }
    }
    
    @objc
    private func didTapColorPickerButton(_ sender: ColorPickerControl) {
        guard !isColorsContextMenuVisible else { return }
        
        dismissContextMenusAndResetState()
        if toolType?.chooseShapeContextMenuShape() == nil {
            instrumentsButton.isSelected = false
        }
        
        colorPickerButton.isSelected = true
        colorPickerButton.showContextMenu(ColorPickerContextMenu(delegate: self))
    }
}

extension DrawingToolBar: ChooseShapeContextMenuDelegate {
    func chooseShapeContextMenu(
        _ chooseShapeContextMenu: ChooseShapeContextMenu,
        didSelectShape shape: ChooseShapeContextMenu.Shape
    ) {
        dismissContextMenusAndResetState()
        clearSelection()
        
        instrumentsButton.isSelected = true
        toolType = .fromChooseShapeContextMenuShape(shape)
    }
}

extension DrawingToolBar: ColorPickerContextMenuDelegate {
    func colorPickerContextMenu(_ colorPickerContextMenu: ColorPickerContextMenu, didPickColor color: UIColor) {
        dismissContextMenusAndResetState()
        colorPickerButton.isSelected = false
        colorPickerButton.color = color
        strokeColor = color
    }
}
