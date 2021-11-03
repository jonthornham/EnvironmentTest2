//
//  ContentView.swift
//  EnvironmentTest2
//
//  Created by Jon Thornham on 11/3/21.
//

import SwiftUI

struct ContentView: View {
    // MARK: ++++++++++++++++++++++++++++++++++++++ Properties ++++++++++++++++++++++++++++++++++++++
  
      // Dismiss the View
      @Environment(\.presentationMode) var presentaionMode: Binding<PresentationMode>
  
      // Media Picker
      @State var showMediaPickerSheet = false
      @State var showLibrary = false
      @State var showMediaErrorAlert = false
      @frozen enum MediaTypeSource {
          case library
      }
  
      // MARK: ++++++++++++++++++++++++++++++++++++++ View ++++++++++++++++++++++++++++++++++++++
      var body: some View {
  
          return Button(action: {
              self.presentMediaPicker()
          }, label: {
              Text("Button")
          })
  
              .actionSheet(isPresented: $showMediaPickerSheet, content: {
                  ActionSheet(
                      title: Text("Add Store Picture"),
                      buttons: sheetButtons()
                  )
              }) // Action Sheet
              .sheet(isPresented: $showLibrary, content: {
                  MediaPickerPhoto(sourceType: .photoLibrary, showError: $showMediaErrorAlert) { (image, error) in
                      if error != nil {
                          print(error!)
                      } else {
                          guard let image = image else {
                              return
                          }
                      }
                  }
              })
      } // View
  
  
      // MARK: ++++++++++++++++++++++++++++++++++++++ Methods ++++++++++++++++++++++++++++++++++++++
  
      // Media Picker Methods
      func presentMediaPicker() {
          print("PresentMediaPicker1Listing")
          self.showMediaPickerSheet = true
      }
  
      func sheetButtons() -> [Alert.Button] {
          print("ShowSheetButtonsListing")
  
          return UIImagePickerController.isSourceTypeAvailable(.camera) ? [
              .default(Text("Choose Photo")) {
                  presentMediaPicker1(.library)
              },
              .cancel {
                  showMediaPickerSheet = false
              }
          ] : [
              .default(Text("Choose Photo")) {
                  presentMediaPicker1(.library)
              },
              .cancel {
                  showMediaPickerSheet = false
              }
          ]
      }
  
      private func presentMediaPicker1(_ type: MediaTypeSource) {
          print("PresentMediaPicker2Listing")
  
          showMediaPickerSheet = false
          switch type {
          case .library:
              showLibrary = true
          }
      }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
