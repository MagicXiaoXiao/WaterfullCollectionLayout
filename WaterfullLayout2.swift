//
//  WaterfullLayout2.swift
//  HelloXcode9
//
//  Created by 晓晓魔导师 on 2017/6/7.
//  Copyright © 2017年 花落知多少. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
    
    func contentHeight(collectionView: UICollectionView, indexPath: IndexPath, width: CGFloat) -> CGFloat
    
}

class WaterfullLayout2: UICollectionViewLayout {
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    var delegate: PinterestLayoutDelegate!
    
    var numberOfColumns: Int = 2
    var cellPadding: CGFloat = 10
    
    override func prepare() {
        super.prepare()
        if cache.isEmpty {
            
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            
            for column in 0..<numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let width = columnWidth - cellPadding * 2
                
                let conHeight = delegate.contentHeight(collectionView: collectionView!, indexPath: indexPath, width: width)
                
                let height = cellPadding + conHeight + cellPadding
                
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] += height
                
                column = column >= (numberOfColumns - 1) ? 0 : column+1
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if rect.intersects(attributes.frame){
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
}
