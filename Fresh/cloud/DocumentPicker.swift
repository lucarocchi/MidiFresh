//
//  DocumentPicker.swift
//  100LinesOfCode
//
//  Created by Luca Rocchi on 24/11/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
#if os(iOS)



struct DocumentPicker : UIViewControllerRepresentable {
    let ext:String?
    
    init(ext: String) {
        self.ext = ext
    }

    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator()
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let controller : UIDocumentPickerViewController
        let type = UTType(filenameExtension: ext!)
        controller = UIDocumentPickerViewController(forOpeningContentTypes: [type!])
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        controller.directoryURL = documentDirectory
        controller.delegate = context.coordinator
     
        return controller
    }
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        //<#code#>
    }
    
}


class DocumentPickerCoordinator : NSObject , UIDocumentPickerDelegate,UINavigationControllerDelegate {
    
    override init(){
        super.init()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        //
        guard let url = urls.first else {
              return
        }
        guard url.startAccessingSecurityScopedResource() else { // Notice this line right here
             return
        }
        DispatchQueue.main.async  {
            let ext = url.pathExtension
            NotificationCenter.default.post(name: Notification.Name.init("documentAvailable"),
                                            object: nil, userInfo: ["url": url,"type":ext])

           
        }
    }
}
#endif
