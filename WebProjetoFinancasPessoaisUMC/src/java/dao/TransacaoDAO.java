/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Transacao;
import util.ConectaDB;
import java.sql.*;
import org.apache.jasper.tagplugins.jstl.core.Out;


/**
 *
 * @author Henrique Vieira de Almeida
 */
public class TransacaoDAO {        
    public boolean inserir(Transacao p_transacao) throws ClassNotFoundException, SQLException {
        String sql = "INSERT INTO transacao (id_usuario, id_categoria, data, valor, tipo, mes_ano " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (
            Connection conexao = ConectaDB.conectar();
            PreparedStatement ps = conexao.prepareStatement(sql)) {
                ps.setInt(1, p_transacao.getId_usuario());
                ps.setInt(2, p_transacao.getId_categoria());
                ps.setDate(3, Date.valueOf(p_transacao.getData()));
                ps.setDouble(4, p_transacao.getValor());
                ps.setString(5, p_transacao.getTipo().toString());
                ps.setString(6, p_transacao.getMesAno());
                
                return ps.executeUpdate() > 0;
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao inserir: " + ex);
            return false;
        }        
    }
    
        public List<Usuario> consultarTodos() throws ClassNotFoundException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario ORDER BY nome";

        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNome(rs.getString("nome"));
                usuario.setSobrenome(rs.getString("sobrenome"));
                usuario.setEmail(rs.getString("email"));
                usuario.setTelefone(rs.getString("telefone"));
                usuario.setDataNascimento(rs.getDate("data_nascimento").toLocalDate());

                // Correção para o tipo de usuário
                String tipoStr = rs.getString("tipo");
                try {
                    usuario.setTipo(Usuario.TipoUsuario.valueOf(tipoStr.toLowerCase()));
                } catch (IllegalArgumentException e) {
                    // Valor padrão caso o tipo não seja reconhecido
                    usuario.setTipo(Usuario.TipoUsuario.comum);
                    System.err.println("Tipo de usuário desconhecido: " + tipoStr);
                }

                usuario.setDataCriacao(rs.getTimestamp("data_criacao"));
                usuario.setAtivo(rs.getBoolean("ativo"));

                lista.add(usuario);
            }
        } catch (SQLException ex) {
            System.err.println("Erro ao consultar usuários: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }

        return lista;
    }

            public List<Usuario> consultarTodos() throws ClassNotFoundException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario ORDER BY nome";

        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNome(rs.getString("nome"));
                usuario.setSobrenome(rs.getString("sobrenome"));
                usuario.setEmail(rs.getString("email"));
                usuario.setTelefone(rs.getString("telefone"));
                usuario.setDataNascimento(rs.getDate("data_nascimento").toLocalDate());

                // Correção para o tipo de usuário
                String tipoStr = rs.getString("tipo");
                try {
                    usuario.setTipo(Usuario.TipoUsuario.valueOf(tipoStr.toLowerCase()));
                } catch (IllegalArgumentException e) {
                    // Valor padrão caso o tipo não seja reconhecido
                    usuario.setTipo(Usuario.TipoUsuario.comum);
                    System.err.println("Tipo de usuário desconhecido: " + tipoStr);
                }

                usuario.setDataCriacao(rs.getTimestamp("data_criacao"));
                usuario.setAtivo(rs.getBoolean("ativo"));

                lista.add(usuario);
            }
        } catch (SQLException ex) {
            System.err.println("Erro ao consultar usuários: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }

        return lista;
    }

    
    public List<Transacao> consultarTodas() throws ClassNotFoundException {
        List<Transacao> lista = new ArrayList<>();
        String sql = "SELECT * FROM transacao ORDER BY data";

        try (
            Connection conexao = ConectaDB.conectar();
            PreparedStatement ps = conexao.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Transacao transacao = new Transacao();
                
                transacao.setId_transacao(rs.getInt("id_"));
                String tipoStr = rs.getString("tipo");
                try {
                    transacao.setTipo(Transacao.TipoTransacao.valueOf(tipoStr.toLowerCase()));
                } catch (IllegalArgumentException e) {

                }
                    rs.getString("mes_ano")
                );
                        
                lista.add(transacao);
            }
        } catch (SQLException ex) {
            System.err.println("Erro ao consultar transações: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }

        return lista;
    }

    private static class tipoStr {

        public tipoStr() {
        }
    }

}
