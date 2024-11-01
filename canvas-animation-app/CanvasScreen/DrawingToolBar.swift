import Foundation
import UIKit

protocol DrawingToolBarDelegate: AnyObject {
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSelectTool tool: Tool?)
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSelectColor color: UIColor)
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSetStrokeWidth strokeWidth: CGFloat)
}

extension DrawingToolBar {
    private enum Constants {
        static let colorPickerButtonHeight: CGFloat = 32
        static let colorPickerButtonWidth: CGFloat = 32
    }
}

final class DrawingToolBar: CustomToolBar {
    weak var delegate: DrawingToolBarDelegate?
    
    private(set) var tool: Tool?
    private(set) var color: UIColor
    private(set) var strokeWidth: CGFloat
    
    private let pencilButton = ToolControl(image: .res.pencil)
    private let brushButton = ToolControl(image: .res.brush)
    private let eraserButton = ToolControl(image: .res.eraser)
    private let instrumentsButton = ToolControl(image: .res.instruments)
    private let colorPickerButton: ColorPickerControl
    
    private var isShapesContextMenuVisible: Bool = false
    private var isColorsContextMenuVisible: Bool = false
    
    init(
        initialColorPickerColor: UIColor = .res.paletteRed5,
        initialStrokeWidth: CGFloat = 2,
        delegate: DrawingToolBarDelegate? = nil
    ) {
        self.delegate = delegate
        self.colorPickerButton = .init(color: initialColorPickerColor)
        self.color = initialColorPickerColor
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
    
    @objc
    private func didTapPencilButton(_ sender: ToolControl) {
        dismissContextMenusAndResetState()
        clearSelection()
        
        if !pencilButton.isSelected {
            tool = .pencil
            pencilButton.isSelected = true
            delegate?.drawingToolBar(self, didSelectTool: .pencil)
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
            tool = .eraser
            eraserButton.isSelected = true
            delegate?.drawingToolBar(self, didSelectTool: .eraser)
        }
    }
    
    @objc
    private func didTapInstrumentsButton(_ sender: ToolControl) {
        guard !isShapesContextMenuVisible else { return }
        
        dismissContextMenusAndResetState()
        colorPickerButton.isSelected = false
        instrumentsButton.isSelected = true
        
        switch tool {
        case .shape(let shape):
            instrumentsButton.showContextMenu(ChooseShapeContextMenu(delegate: self, shape: shape))
        default:
            instrumentsButton.showContextMenu(ChooseShapeContextMenu(delegate: self))
        }
    }
    
    @objc
    private func didTapColorPickerButton(_ sender: ColorPickerControl) {
        guard !isColorsContextMenuVisible else { return }
        
        dismissContextMenusAndResetState()
        switch tool {
        case .shape(_):
            break
        default:
            instrumentsButton.isSelected = false
        }
        
        colorPickerButton.isSelected = true
        colorPickerButton.showContextMenu(ColorPickerContextMenu(delegate: self))
    }
}

extension DrawingToolBar: ChooseShapeContextMenuDelegate {
    func chooseShapeContextMenu(_ chooseShapeContextMenu: ChooseShapeContextMenu, didSelectShape shape: Tool.Shape) {
        dismissContextMenusAndResetState()
        clearSelection()
        
        instrumentsButton.isSelected = true
        tool = .shape(shape)
        delegate?.drawingToolBar(self, didSelectTool: .shape(shape))
    }
}

extension DrawingToolBar: ColorPickerContextMenuDelegate {
    func colorPickerContextMenu(_ colorPickerContextMenu: ColorPickerContextMenu, didPickColor color: UIColor) {
        dismissContextMenusAndResetState()
        colorPickerButton.isSelected = false
        colorPickerButton.color = color
        delegate?.drawingToolBar(self, didSelectColor: color)
    }
}
