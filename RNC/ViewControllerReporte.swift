//
//  ViewControllerReporte.swift
//  RNC
//
//  Created by JUAN on 29/05/20.
//  Copyright © 2020 JUAN. All rights reserved.
//

import UIKit


class ViewControllerReporte: UIViewController {
    var correo = ""
    var direccion = ""
   
    var saborx = ""
    var tamañox = ""
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("\(saborx)")
        lblNombre.text = correo
        lblDomicilio.text = direccion
        lblSabor.text = saborx
        lblTamaño.text = tamañox

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblSabor: UILabel!
    @IBOutlet weak var lblTamaño: UILabel!
    @IBOutlet weak var lblDomicilio: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
