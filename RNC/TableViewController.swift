//
//  TableViewController.swift
//  RNC
//
//  Created by JUAN on 21/05/20.
//  Copyright © 2020 JUAN. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

   var Productos = [tamano]()
    var correo = ""
    var direccion = ""
    var saborx : String?
    
    
    let dataJsonUrlClass = JsonClass()
    @IBOutlet var tabla: UITableView!
    var sabor = [sabores]()
    override func viewDidLoad(){
        super.viewDidLoad()
        tabla.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sabor.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda") as! TableViewCell
        let sa:sabores
        sa=sabor[indexPath.row]
        cell.nombre.text = sa.nombre
        // Configure the cell...
        
        return cell
        
    }
   
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
           let datos_a_enviar = ["id": ""] as NSMutableDictionary
           
           //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
           
           dataJsonUrlClass.arrayFromJson(url:"RNC/gettamano.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
               
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
                       let idprod = product.object(forKey: "idtamaño") as! String?
                        let nomprod = product.object(forKey: "nombre") as! String?
                       let existe = product.object(forKey: "imagen") as! String?
                    self.Productos.append(tamano(idtamaño: idprod, nombre: nomprod, imagen: existe))
                   }
                let x : sabores
                x = self.sabor[indexPath.row]
                    
                self.saborx = String(x.nombre!)
               //print("valor de x \(saborx)")
                
                self.performSegue(withIdentifier:"segue2", sender: self)
               }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          /*if segue.identifier == "segue2"{
               _ = segue.destination as! TableViewControllerTamano
        }*/
        if segue.identifier == "segue2"{
            let seguesabor = segue.destination as! TableViewControllerTamano
            seguesabor.tam = Productos
            seguesabor.correo = correo
            seguesabor.direccion = direccion
            seguesabor.saborx = saborx!
            
                       }
        
}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
