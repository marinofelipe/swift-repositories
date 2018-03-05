//
//  CustomGridFlowLayout.swift
//  SwiftRepositories
//
//  Created by Felipe Lefèvre Marino on 3/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

protocol GridHeightLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForCellAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

class CustomGridFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: GridHeightLayoutDelegate?
    
    var orientationColumnMultiplier: Int {
        get {
            switch UIDevice.current.orientation {
            case .portrait:
                return 1
            default:
                return 2
            }
        }
    }
    var numberOfColumns: Int {
        get {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 2 * orientationColumnMultiplier
            } else {
                return 1 * orientationColumnMultiplier
            }
        }
    }
    lazy var cellMargins: CGFloat = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 10.0
        } else {
            return 5.0
        }
    }()
    private var cachedAttributes = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0.0
    private var contentSize = CGSize.zero
}

extension CustomGridFlowLayout {
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        collectionView.contentInset = UIEdgeInsets(top: cellMargins, left: cellMargins * 2, bottom: cellMargins, right: cellMargins * 2)
        
        cachedAttributes.removeAll()
        if cachedAttributes.isEmpty {
            var contentHeight: CGFloat = 0.0
            let contentWidth: CGFloat = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
            let columnWidth = contentWidth / CGFloat(numberOfColumns) - (cellMargins * CGFloat(numberOfColumns - 1)) / CGFloat(numberOfColumns)
            
            var xOffset = [CGFloat]()
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            for column in 0 ..< numberOfColumns {
                var offset = CGFloat(column) * columnWidth
                offset += cellMargins * CGFloat(column)
                xOffset.append(offset)
            }
            var column = 0
            
            for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                
                let itemWidth = columnWidth
                var itemHeight: CGFloat = 130.0
                if let delegate = delegate {
                    itemHeight = delegate.collectionView(collectionView, heightForCellAt: indexPath, withWidth: itemWidth)
                }
                
                var itemXlocation = xOffset[column]
                let itemYlocation = yOffset[column]
                
                if item == collectionView.numberOfItems(inSection: 0) - 1 && column == 0 {
                    itemXlocation = (contentWidth / 2) - (columnWidth / 2)
                } else if numberOfColumns == 4 {
                    if item == collectionView.numberOfItems(inSection: 0) - 2 && column == 0 {
                        itemXlocation = (contentWidth / 2) - columnWidth
                    } else if item == collectionView.numberOfItems(inSection: 0) - 1 && column == 1 {
                        itemXlocation = (contentWidth / 2) + cellMargins * 2
                    }
                    
                    if item == collectionView.numberOfItems(inSection: 0) - 3 && column == 0 {
                        itemXlocation = (contentWidth / 2) - (columnWidth * 1.5) - cellMargins
                    } else if item == collectionView.numberOfItems(inSection: 0) - 2 && column == 1 {
                        itemXlocation = (contentWidth / 2) - (columnWidth / 2)
                    } else if item == collectionView.numberOfItems(inSection: 0) - 1 && column == 2 {
                        itemXlocation = (contentWidth / 2) + (columnWidth / 2) + cellMargins
                    }
                }
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: itemXlocation, y: itemYlocation, width: itemWidth, height: itemHeight)
                cachedAttributes.append(attributes)
                
                yOffset[column] = yOffset[column] + itemHeight + cellMargins + 3
                column = column < numberOfColumns - 1 ? column + 1 : 0
            }
            
            yOffset = yOffset.sorted{$0 < $1}
            if let height = yOffset.last {
                contentHeight = height
            }
            contentSize = CGSize(width: contentWidth, height: contentHeight)
        }
    }
}

extension CustomGridFlowLayout {
    override open var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes
    }
}

