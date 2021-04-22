//
//  ImagePicker.swift
//  proyecto
//
//  Created by macOS on 21/4/21.
//

import SwiftUI
import YPImagePicker

class ImagePicker{
    let picker: YPImagePicker
    var config: YPImagePickerConfiguration
    var photo: UIImage?
    
    init() {
        config = YPImagePickerConfiguration()
        config.wordings.albumsTitle = "Album"
        config.wordings.cameraTitle = "Cámara"
        config.wordings.cancel = "Cancelar"
        config.wordings.done = "Terminar"
        config.wordings.next = "Siguiente"
        config.wordings.filter = "Filtro"
        config.wordings.save = "Guardar"
        config.wordings.libraryTitle = "Galería"
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
        config.showsPhotoFilters = true
        config.showsVideoTrimmer = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "Imágenes"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library, .photo]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesCancelButton = false
        picker = YPImagePicker(configuration: config)

    }
    
    
    
    func rootViewController() -> UIViewController {
      var rootViewController: UIViewController = (UIApplication.shared.windows.first?.rootViewController)!
      while ((rootViewController.presentedViewController) != nil) { rootViewController = rootViewController.presentedViewController!; }
      return rootViewController
    }
    
    
    func getPicker() -> YPImagePicker{
        return picker
    }

}
