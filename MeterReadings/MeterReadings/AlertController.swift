//
//  AlertController.swift
//  MeterReadings
//
//  Created by Student on 02.07.21.
//

import Foundation
import Combine
import SwiftUI

public struct AlertController: UIViewControllerRepresentable {
    @Binding var textField1: String
    @Binding var textField2: String
    @Binding var show: Bool
    
    var textField1Placeholder: String = ""
    var textField2Placeholder: String = ""
    
    var submitAction: UIAlertAction
    
    var title: String
    var message: String?
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<AlertController>) -> UIViewController {
        return UIViewController()
    }
    
    public func updateUIViewController(_ viewController: UIViewController, context: UIViewControllerRepresentableContext<AlertController>) {
            if self.show {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                context.coordinator.alert = alert
                
                alert.addTextField { textField1 in
                    textField1.placeholder = textField1Placeholder
                    textField1.text = self.textField1
                }
                alert.addTextField { textField2 in
                    textField2.placeholder = textField2Placeholder
                    textField2.text = self.textField2
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
                    
                })
                alert.addAction(submitAction)
                
                DispatchQueue.main.async {
                    viewController.present(alert, animated: true, completion: {
                        self.show = false
                        context.coordinator.alert = nil
                    })
                }
        }
    }
    
    public func makeCoordinator() -> AlertController.Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        var alert: UIAlertController?
        var control: AlertController
        init(_ control: AlertController) {
            self.control = control
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                self.control.textField1 = text.replacingCharacters(in: range, with: string)
            } else {
                self.control.textField1 = ""
            }
            return true
        }
        
    }
    
}
