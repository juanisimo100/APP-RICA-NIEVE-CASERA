//
//  ViewController.swift
//  RNC
//
//  Created by JUAN on 05/05/20.
//  Copyright © 2020 JUAN. All rights reserved.
//

import UIKit
import SQLite3
class ViewController: UIViewController { 
    var Productos = [sabores]()
    var correo = ""
    var direccion = ""
    let dataJsonUrlClass = JsonClass()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    
    @IBAction func productos(_ sender: UIButton) {
    
    Productos.removeAll()
        let datos_a_enviar = ["id": ""] as NSMutableDictionary
        
        //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
        
        dataJsonUrlClass.arrayFromJson(url:"RNC/getsabores.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
            
            DispatchQueue.main.async {//proceso principal
                
                /*
                 recibimos un array de tipo:
                 (
                     [0] => Array
                     (
                         [success] => 200
                         [message] => Producto encontrado
                         [idProd] => 1
                         [nomProd] => Desarmador plus
                         [existencia] => 10
                         [precio] => 80
                     )
                 )
                 object(at: 0) as! NSDictionary -> indica que el elemento 0 de nuestro array lo vamos a convertir en un diccionario de datos.
                 */
                let cuenta = array_respuesta?.count
                
                for indice in stride(from: 0, to: cuenta!, by: 1){
                    let product = array_respuesta?.object(at: indice) as! NSDictionary
                    let idprod = product.object(forKey: "idsabor") as! String?
                    let nomprod = product.object(forKey: "nombre") as! String?
                    let existe = product.object(forKey: "imagen") as! String?
                    self.Productos.append(sabores(idsabor: idprod, nombre: nomprod, imagen: existe ) )
                }
                self.performSegue(withIdentifier: "segue1", sender: self)
               
            }
            
        
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let x = direccion
        print("\(direccion)")
        
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
                //condiciones para loguear un usuario en la app
                let query = "Select Correo From Cliente"
                
        
                if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
                    let error = String(cString: sqlite3_errmsg(db))
                    
                    alerta(title: "Error", message: "Error en \(error)")
                    return
                }
                       // condiciòn para extrer los datos de nuestro select, de no cumplierse se manda al vcontroller registro
                if sqlite3_step(stmt) == SQLITE_ROW {
                   
                    correo = String(cString: sqlite3_column_text(stmt, 0))
                    
                    alerta(title: "Bienvenido", message: "Hola \(correo)")
                    
                }
                else{
                    
                    self.performSegue(withIdentifier: "SegueARegistro", sender: self)
                    
                }
                // Do any additional setup after loading the view.
            }
            //funcion para dirigir a otro vcontroller
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "SegueARegistro" {
                    _ = segue.destination as! ViewControllerRegistro
                    }
                if segue.identifier == "segue1"{
                    let seguesabor = segue.destination as! TableViewController
                    seguesabor.sabor = Productos
                    seguesabor.correo = correo
                    seguesabor.direccion = direccion
                }
            }
            //funcion para arrojar alertas
            func alerta(title: String, message: String) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }        // Do any additional setup after loading the view.

