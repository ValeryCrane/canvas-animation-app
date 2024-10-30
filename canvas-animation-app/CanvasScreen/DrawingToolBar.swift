import Foundation
import UIKit

protocol DrawingToolBarDelegate: AnyObject {
    func drawingToolBar(_ drawingToolBar: DrawingToolBar, didSelectTool tool: DrawingToolBar.Tool?)
}

extension DrawingToolBar {
    enum Tool {
        case pencil
        case brush
        case eraser
        case instruments
        case colorPicker
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
    
    private let pencilButton = CustomToolBarItem(image: .res.pencil)
    private let brushButton = CustomToolBarItem(image: .res.brush)
    private let eraserButton = CustomToolBarItem(image: .res.eraser)
    private let instrumentsButton = CustomToolBarItem(image: .res.instruments)
    private let colorPickerButton: ColorPickerToolBarItem
    
    init(
        initialColorPickerColor: UIColor,
        delegate: DrawingToolBarDelegate? = nil
    ) {
        self.delegate = delegate
        self.colorPickerButton = .init(color: initialColorPickerColor)
        
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
    
    func selectTool(_ tool: Tool) {
        clearSelection()
        
        switch tool {
        case .pencil:
            pencilButton.isSelected = true
        case .brush:
            brushButton.isSelected = true
        case .eraser:
            eraserButton.isSelected = true
        case .instruments:
            instrumentsButton.isSelected = true
        case .colorPicker:
            colorPickerButton.isSelected = true
        }
    }
    
    func clearSelection() {
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
    private func didTapPencilButton(_ sender: CustomToolBarItem) {
        if !pencilButton.isSelected {
            selectTool(.pencil)
            delegate?.drawingToolBar(self, didSelectTool: .pencil)
        }
    }
    
    @objc
    private func didTapBrushButton(_ sender: CustomToolBarItem) {
        if !brushButton.isSelected {
            selectTool(.brush)
            delegate?.drawingToolBar(self, didSelectTool: .brush)
        }
    }
    
    @objc
    private func didTapEraserButton(_ sender: CustomToolBarItem) {
        if !eraserButton.isSelected {
            selectTool(.eraser)
            delegate?.drawingToolBar(self, didSelectTool: .eraser)
        }
    }
    
    @objc
    private func didTapInstrumentsButton(_ sender: CustomToolBarItem) {
        if !instrumentsButton.isSelected {
            selectTool(.instruments)
            delegate?.drawingToolBar(self, didSelectTool: .instruments)
        }
    }
    
    @objc
    private func didTapColorPickerButton(_ sender: ColorPickerToolBarItem) {
        if !colorPickerButton.isSelected {
            selectTool(.colorPicker)
            delegate?.drawingToolBar(self, didSelectTool: .colorPicker)
        }
    }
}
