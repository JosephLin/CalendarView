//
//  CalendarLayout.swift
//  CalendarView
//
//  Created by Joseph Lin on 5/11/16.
//  Copyright © 2016 Joseph Lin. All rights reserved.
//

import UIKit


extension NSIndexPath {
    
    public convenience init(column: Int) {
        self.init(indexes: [column], length: 1)
    }
    
    public convenience init(column: Int, row: Int) {
        self.init(indexes: [column, row], length: 2)
    }

    public var column: Int {
        get {
            return self.indexAtPosition(0)
        }
    }
}

protocol GridLayoutDelegate : UICollectionViewDelegate {
    func positionForItemAtIndexPath(indexPath: NSIndexPath) -> Double?
}

enum ElementKind: String {
    case Background
    case Divider
    case ColumnLabel
    case RowLabel
}

class GridLayout: UICollectionViewLayout {
    
    var columnWidth: CGFloat {
        get {
            guard let collectionView = self.collectionView else {
                return 0
            }
            return (collectionView.frame.width - self.edgeInsets.left - self.edgeInsets.right) / CGFloat(self.numberOfColumns)
        }
    }
    var rowHeight: CGFloat = 40.0
    
    var numberOfColumns = 7
    var numberOfRows = 24

    var edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    var showColumnLabels = false
    var showRowLabels = false

    //MARK:- Overrides
    
    override func collectionViewContentSize() -> CGSize {
        
        let width = self.edgeInsets.left + self.columnWidth * CGFloat(self.numberOfColumns) + self.edgeInsets.right
        let height = self.edgeInsets.top + self.rowHeight * CGFloat(self.numberOfRows) + self.edgeInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var allAttributes = [UICollectionViewLayoutAttributes]();
        
        for column in 0..<self.numberOfColumns {
            if let attributes = self.layoutAttributesForSupplementaryViewOfKind(ElementKind.Background.rawValue, atIndexPath: NSIndexPath(column: column)) {
                allAttributes.append(attributes)
            }
            
            if self.showColumnLabels == true {
                if let attributes = self.layoutAttributesForSupplementaryViewOfKind(ElementKind.ColumnLabel.rawValue, atIndexPath: NSIndexPath(column: column)) {
                    allAttributes.append(attributes)
                }
            }
        }
        
        for row in 0...self.numberOfRows {
            if let attributes = self.layoutAttributesForSupplementaryViewOfKind(ElementKind.Divider.rawValue, atIndexPath: NSIndexPath(column: 0, row: row)) {
                allAttributes.append(attributes)
            }
            
            if self.showRowLabels == true {
                if let attributes = self.layoutAttributesForSupplementaryViewOfKind(ElementKind.RowLabel.rawValue, atIndexPath: NSIndexPath(column: 0, row: row)) {
                    allAttributes.append(attributes)
                }
            }
        }

        return allAttributes;
    }
    
//    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        
//        guard let delegate = self.collectionView?.delegate as? GridLayoutDelegate, position = delegate.positionForItemAtIndexPath(indexPath) else {
//            return nil
//        }
//        
//        let x = CGFloat(indexPath.column) * columnWidth
//        let y = CGFloat(position) * self.collectionViewContentSize().height
//        let frame = CGRect(x: x, y: y, width: columnWidth, height: rowHeight)
//        
//        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
//        attributes.frame = frame
//        
//        return attributes
//    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let kind = ElementKind(rawValue: elementKind) else {
            return nil
        }

        switch kind {
        case .Background:
            let x = self.edgeInsets.left + CGFloat(indexPath.column) * self.columnWidth
            let y = self.edgeInsets.top
            let width = self.columnWidth
            let height = CGFloat(self.numberOfRows) * self.rowHeight
            
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
            attributes.frame = CGRect(x: x, y: y, width: width, height: height)
            attributes.zIndex = 0
            
            return attributes
            
        case .Divider:
            let x = self.edgeInsets.left
            let y = self.edgeInsets.top + CGFloat(indexPath.row) * self.rowHeight
            let width = CGFloat(self.numberOfColumns) * self.columnWidth
            let height = CGFloat(1)
            
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
            attributes.frame = CGRect(x: x, y: y, width: width, height: height)
            attributes.zIndex = 1

            return attributes
            
        case .ColumnLabel:
            let x = self.edgeInsets.left + CGFloat(indexPath.column) * self.columnWidth
            let y = CGFloat(0)
            let width = self.columnWidth
            let height = self.edgeInsets.top
            
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
            attributes.frame = CGRect(x: x, y: y, width: width, height: height)
            attributes.zIndex = 2
            
            return attributes
            
        case .RowLabel:
            let x = CGFloat(0)
            let y = self.edgeInsets.top + CGFloat(indexPath.row) * self.rowHeight - 0.5 * self.rowHeight
            let width = self.edgeInsets.left
            let height = self.rowHeight
            
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
            attributes.frame = CGRect(x: x, y: y, width: width, height: height)
            attributes.zIndex = 3
            
            return attributes
        }
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        if let collectionView = self.collectionView where CGRectEqualToRect(collectionView.bounds, newBounds) == false {
            return true
        }
        return false;
    }
}

class GridLabelView: UICollectionReusableView {
    lazy var textLabel: UILabel = { [unowned self] in
        
        let label = UILabel(frame: self.bounds)
        label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        label.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
        
        return label
    }()
}

class GridView: UICollectionView, UICollectionViewDataSource {
    
    var fillColor = UIColor(white: 0.1, alpha: 1.0)
    var alternateFillColor = UIColor(white: 0.3, alpha: 1.0)
    var selectedFillColor = UIColor(white: 0.6, alpha: 1.0)
    var dividerColor = UIColor(white: 0.5, alpha: 1.0)
    var indicatorColor = UIColor(white: 1.0, alpha: 1.0)
    var labelColor = UIColor(white: 1.0, alpha: 1.0)
    
    var numberOfMajorTicks = 24
    var numberOfMinorTicksBetweenMajorTicks = 1
    
    var columnLabels: [String?]? {
        didSet {
            guard let layout = self.collectionViewLayout as? GridLayout else {
                return
            }
            
            layout.showColumnLabels = columnLabels != nil
        }
    }
    var rowLabels: [String?]? {
        didSet {
            guard let layout = self.collectionViewLayout as? GridLayout else {
                return
            }
            
            layout.showRowLabels = rowLabels != nil
        }
    }
    
    //MARK:- Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let gridLayout = GridLayout()
        gridLayout.edgeInsets = UIEdgeInsets(top: 40, left: 60, bottom: 20, right: 20)
        self.collectionViewLayout = gridLayout
        
        self.dataSource = self
        
        self.registerClass(UICollectionReusableView.self,
                           forSupplementaryViewOfKind: ElementKind.Background.rawValue,
                           withReuseIdentifier: ElementKind.Background.rawValue)
        
        self.registerClass(UICollectionReusableView.self,
                           forSupplementaryViewOfKind: ElementKind.Divider.rawValue,
                           withReuseIdentifier: ElementKind.Divider.rawValue)

        self.registerClass(GridLabelView.self,
                           forSupplementaryViewOfKind: ElementKind.ColumnLabel.rawValue,
                           withReuseIdentifier: ElementKind.ColumnLabel.rawValue)
        
        self.registerClass(GridLabelView.self,
                           forSupplementaryViewOfKind: ElementKind.RowLabel.rawValue,
                           withReuseIdentifier: ElementKind.RowLabel.rawValue)
        
        
        // closure invokes didSet
        ({ self.columnLabels  = ["SUN", nil, "TUE"] })()
        ({
            var rowLabels = [String?]()
            
            for i in 0..<self.numberOfMajorTicks {
                
                rowLabels.append(String(i) + ":00")
                
                for _ in 0..<self.numberOfMinorTicksBetweenMajorTicks {
                    rowLabels.append(nil)
                }
            }
            self.rowLabels  = rowLabels
        })()
    }
    
    //MARK:- UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard let layout = self.collectionViewLayout as? GridLayout else {
            return 0
        }
        return layout.numberOfColumns;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kind, forIndexPath: indexPath)
        
        if let elementKind = ElementKind(rawValue: kind) {
            switch elementKind {
            case .Background:
                let color = indexPath.column % 2 == 0 ? self.fillColor : self.alternateFillColor
                view.backgroundColor = color

            case .Divider:
                view.backgroundColor = self.dividerColor

            case .ColumnLabel:
                view.backgroundColor = UIColor.clearColor()
                
                if let view = view as? GridLabelView {
                    
                    view.textLabel.textColor = self.labelColor
                    view.textLabel.textAlignment = .Center
                    
                    if let columnLabels = self.columnLabels where indexPath.column < columnLabels.count {
                        view.textLabel.text = columnLabels[indexPath.column]
                    }
                    else {
                        view.textLabel.text = nil
                    }
                }
                
            case .RowLabel:
                view.backgroundColor = UIColor.clearColor()
                
                if let view = view as? GridLabelView {
                    
                    view.textLabel.textColor = self.labelColor
                    view.textLabel.textAlignment = .Center
                    
                    if let rowLabels = self.rowLabels where indexPath.row < rowLabels.count {
                        view.textLabel.text = rowLabels[indexPath.row]
                    }
                    else {
                        view.textLabel.text = nil
                    }
                }
            }
        }
        
        return view
    }
}

