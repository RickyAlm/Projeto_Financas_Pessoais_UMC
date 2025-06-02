/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Categoria;
import java.sql.*;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.ConectaDB;

/**
 *
 * @author Henrique Vieira de Almeida
 */
public class CategoriaDAO {
    public List<Categoria> consultarTodos() throws ClassNotFoundException {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT * FROM categoria ORDER BY nome";

        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Categoria categoria = new Categoria(
                    rs.getInt("id_categoria"),
                    rs.getString("nome"),
                    rs.getString("tipo")
                );

                lista.add(categoria);
            }
        } catch (SQLException ex) {
            System.err.println("Erro ao consultar categorias: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }

        return lista;
    }
}
