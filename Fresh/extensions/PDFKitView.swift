//
//  PDFDocument.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 07/02/23.
//

import Foundation

import SwiftUI
import UniformTypeIdentifiers
#if os(iOS)
import PDFKit

struct PDFKitView: UIViewRepresentable {
    
    @Binding var pdfDocument: PDFDocument
    
    //init(showing pdfDoc: PDFDocument) {
        //self.pdfDocument = pdfDoc
    //}
    
    //you could also have inits that take a URL or Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}

struct PDFUIView: View {
    
    @State var pdfDoc: PDFDocument
    
    var body: some View {
        NavigationView {
            
            //if let pdfDoc = pdfDoc {
            PDFKitView( pdfDocument: $pdfDoc)
            //}else {
            //    EmptyView()
            //}
        }.navigationTitle("Music Sheet")
    }
}

#endif
