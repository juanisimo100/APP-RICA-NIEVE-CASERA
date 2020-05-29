//
//  ViewControllerRegistro.swift
//  RNC
//
//  Created by JUAN on 08/05/20.
//  Copyright © 2020 JUAN. All rights reserved.
//

import UIKit
import SQLite3
class ViewControllerRegistro: UIViewController {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    @IBOutlet weak var txtDomicilio: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
        var direccion = ""
     var db: OpaquePointer?
       var stmt: OpaquePointer?
  
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "SegueAPrincipal" {
               let x = segue.destination as! ViewController
            x.direccion = direccion
            
        }
       }
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
         let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteReg.sqlite")
                       if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
                           alerta(title: "Error", message: "No se creo DB")
                           return
                       }
                       //Se crea la tabla user
                       let tablaCliente = "Create Table If Not Exists Cliente(Correo Text Primary Key, nombre Text, Contrasena Text, Direccion Text, Telefono Text)"
                       if sqlite3_exec(db, tablaCliente, nil, nil, nil) != SQLITE_OK {
                           alerta(title: "Error", message: "No se creo la tabla Cliente")
                           return
                       }
    }
        func alerta(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }        // Do any additional setup after loading the view.
    
    
    @IBAction func btnRegistrar(_ sender: UIButton) {
          if txtNombre.text!.isEmpty || txtCorreo.text!.isEmpty || txtContraseña.text!.isEmpty || txtTelefono.text!.isEmpty || txtDomicilio.text!.isEmpty {
                     alerta(title: "Falta Informaciòn", message: "Complete el formulario")
                     txtNombre.becomeFirstResponder()
                 }else{ //Variables donde se almacenara el contenido de las cajas de texto, dando el formato NSString para no tener problemas al guardar en la BD
            direccion = String (txtDomicilio.text!)
                     let Correo = txtCorreo.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
                     let Nombre = txtNombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
                      let Contrasena = txtContraseña.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
                      let Domicilio = txtDomicilio.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
                      let Telefono = txtTelefono.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString                //Condiciones que comprueban que se guarden los datos de cada una de las variables
                     let query = "Insert Into Cliente(Correo, nombre, Contrasena, Direccion, Telefono) Values(?, ?, ?, ?, ? )"
                     if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
                         alerta(title: "Error", message: "No se puede ligar query")
                         return
                     }
                     if sqlite3_bind_text(stmt, 1, Correo.utf8String, -1, nil) != SQLITE_OK {
                         alerta(title: "Error", message: "Error campo Correo")
                         return
                     }
                     if sqlite3_bind_text(stmt, 2, Nombre.utf8String, -1, nil) != SQLITE_OK {
                         alerta(title: "Error", message: "Error campo Nombre")
                         return
                     }
                     if sqlite3_bind_text(stmt, 3, Contrasena.utf8String, -1, nil) != SQLITE_OK {
                         alerta(title: "Error", message: "Error campo Contraseña")
                         return
                     }
                       if sqlite3_bind_text(stmt, 3, Domicilio.utf8String, -1, nil) != SQLITE_OK {
                          alerta(title: "Error", message: "Error campo Domicilio")
                          return
                                        }
                       if sqlite3_bind_text(stmt, 3, Telefono.utf8String, -1, nil) != SQLITE_OK {
                          alerta(title: "Error", message: "Error campo Telefono")
                          return
                                        }
              //Se comprueba que se haya ejecutado correctamente el insert para proceder a cambiarnos de vController
                     if sqlite3_step(stmt) != SQLITE_OK {
                         self.performSegue(withIdentifier: "SegueAPrincipal", sender: self)
                     }
          }
      
      }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
