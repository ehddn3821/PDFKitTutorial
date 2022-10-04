//
//  PDFPreviewViewController.swift
//  PDFKitTutorial
//
//  Created by 앱지 Appg on 2022/10/04.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
    
    public var documentData: Data?
    
    @IBOutlet var pdfView: PDFView!
    @IBOutlet var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = documentData {
            pdfView.translatesAutoresizingMaskIntoConstraints = false
            pdfView.autoScales = true
            pdfView.pageBreakMargins = UIEdgeInsets.init(top: 20, left: 8, bottom: 32, right: 8)
            pdfView.document = PDFDocument(data: data)
        }
    }
    
    @IBAction func tappedShare(_ sender: Any) {
        if let data = documentData {
            let vc = UIActivityViewController(activityItems: [data], applicationActivities: [])
            if UIDevice.current.userInterfaceIdiom == .pad {
                vc.popoverPresentationController?.barButtonItem = shareButton
            }
            self.present(vc, animated: true)
        }
    }
}
