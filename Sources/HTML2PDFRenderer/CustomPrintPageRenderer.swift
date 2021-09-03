//
//  File.swift
//  
//
//  Created by Tobias on 03.09.21.
//

import UIKit

class CustomPrintPageRenderer: UIPrintPageRenderer {
    
    let owner: HTML2PDFRenderer
    let dataSource: HTML2PDFRendererDataSource?
    
    init(owner: HTML2PDFRenderer, dataSource: HTML2PDFRendererDataSource?) {
        self.owner = owner
        self.dataSource = dataSource
    }
    
    override func drawHeaderForPage(at pageIndex: Int, in headerRect: CGRect) {
        dataSource?.html2pdfRenderer(owner, drawHeader: pageIndex, in: headerRect)
    }
    
    override func drawFooterForPage(at pageIndex: Int, in footerRect: CGRect) {
        dataSource?.html2pdfRenderer(owner, drawFooter: pageIndex, in: footerRect)
    }
}
