//
//  RegistroFormViewController.swift
//  campanhabrinquedo
//
//  Created by user204576 on 1/9/22.
//

import UIKit

class RegistroFormViewController: UIViewController {

    

    
    
    @IBOutlet weak var titleCadastro: UINavigationItem!
    
    var doacao: Doacao?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let doacao = doacao{
            title = "Edicao"
            //textFieldNome.text = doacao.doador
            //textFieldEndereco.text = doacao.endereco
            //textViewDescricao.text = doacao.brinquedo
            
            //buttonForm.setTitle("Editar", for: .normal)
        }else{
            title = "Cadastro"
            //textFieldNome.text = ""
            //textFieldEndereco.text = ""
            //textViewDescricao.text = ""
            
            //buttonForm.setTitle("Cadastrar", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func salvarCadastro(_ sender: UIButton) {
        if doacao == nil {
            doacao = Doacao(context: context)
        }
        //doacao?.doador = textFieldNome.text
        //doacao?.endereco = textFieldEndereco.text
        //doacao?.brinquedo = textViewDescricao.text
        
        
        try? context.save()
        navigationController?.popViewController(animated: true)
    }
    
}














