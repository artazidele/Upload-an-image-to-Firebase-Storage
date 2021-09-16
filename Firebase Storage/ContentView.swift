//
//  ContentView.swift
//  Firebase Storage
//
//  Created by arta.zidele on 15/09/2021.
//

import SwiftUI
import FirebaseStorage

struct ContentView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    
    
    @State var shown = false
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to choose an image!")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: self.$filterIntensity)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                        
                    }
                    Spacer()
                    Button("Save") {
                        if image != nil {
                            let storage = Storage.storage()
                            storage.reference().child("temp").putData(inputImage!.jpegData(compressionQuality: 0.35)!, metadata: nil) {
                                (_, err) in
                                if err != nil {
                                    print((err?.localizedDescription)!)
                                    return
                                }
                                print("Success")
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker2(image: self.$inputImage)
            }
        }
        
        
        
        
        
//        Button(action: {
//            self.shown.toggle()
//        }) {
//            Text("Choose Image")
//        }.sheet(isPresented: $shown) {
//            imagePicker(shown: self.$shown)
//        }
        
        
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
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
