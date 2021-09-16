//
//  ContentView.swift
//  Firebase Storage
//
//  Created by arta.zidele on 15/09/2021.
//

import SwiftUI
import FirebaseStorage

struct ContentView: View {
    @State var shown = false
    var body: some View {
        Button(action: {
            self.shown.toggle()
        }) {
            Text("Choose Image")
        }.sheet(isPresented: $shown) {
            imagePicker(shown: self.$shown)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct imagePicker: UIViewControllerRepresentable {
    func makeCoordinator() -> imagePicker.Coordinator {
        return imagePicker.Coordinator(parent1: self)
    }
    
    @Binding var shown: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) ->  UIImagePickerController {
        let imagepic = UIImagePickerController()
        imagepic.sourceType = .photoLibrary
        imagepic.delegate = context.coordinator
        return imagepic
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: imagePicker!
        init(parent1: imagePicker) {
            parent = parent1
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.shown.toggle()
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            let storage = Storage.storage()
            storage.reference().child("temp").putData(image.jpegData(compressionQuality: 0.35)!, metadata: nil) {
                (_, err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                print("Success")
            }
            parent.shown.toggle()
        }
    }
}
