package util;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import java.sql.*;

/**
 *
 * @author Henrique Vieira de Almeida
 */
public class ConectaDB {
    public static Connection conectar() throws ClassNotFoundException {
        Connection connection = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_financas_pessoais_umc","root","");
            return connection;
        }
        catch (SQLException ex) {
            System.out.println("Erro: " + ex);
        }
        return connection;
    }
}
