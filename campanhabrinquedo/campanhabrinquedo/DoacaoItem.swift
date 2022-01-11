//
//  DoacaoItem.swift
//  campanhabrinquedo
//
//  Created by user204576 on 1/10/22.
//

import Foundation

class DoacaoItem{
    internal init(id: String? = nil, brinquedo: String? = nil, conservacao: String? = nil, doador: String? = nil, endereco: String? = nil, telefone: String? = nil) {
        self.id = id
        self.brinquedo = brinquedo
        self.conservacao = conservacao
        self.doador = doador
        self.endereco = endereco
        self.telefone = telefone
    }
    
    var id: String!
    var brinquedo: String!
    var conservacao: String!
    var doador: String!
    var endereco: String!
    var telefone: String!
    
    
}
