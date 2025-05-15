package dao;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import model.Usuario;
import util.ConectaDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Henrique Vieira de Almeida
 */
public class UsuarioDAO {
    
    public boolean inserir(Usuario p_usuario) throws ClassNotFoundException {
        String sql = "INSERT INTO usuario (nome, sobrenome, email, telefone, data_nascimento, senha, tipo, renda_mensal, data_criacao, ativo) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conexao = ConectaDB.conectar();
            PreparedStatement ps = conexao.prepareStatement(sql)) {
            
            ps.setString(1, p_usuario.getNome());
            ps.setString(2, p_usuario.getSobrenome());
            ps.setString(3, p_usuario.getEmail());
            ps.setString(4, p_usuario.getTelefone());
            ps.setDate(5, Date.valueOf(p_usuario.getDataNascimento()));
            ps.setString(6, p_usuario.getSenha());
            ps.setString(7, p_usuario.getTipo().toString());
            ps.setBigDecimal(8, p_usuario.getRendaMensal());
            ps.setTimestamp(9, p_usuario.getDataCriacao());
            ps.setBoolean(10, p_usuario.isAtivo());
            
            return ps.executeUpdate() > 0;
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao inserir: " + ex);
            return false;
        }
    }
    
    public List<Usuario> consultarTodos() throws ClassNotFoundException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario";
        
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
                usuario.setSenha(rs.getString("senha"));
                usuario.setTipo(Usuario.TipoUsuario.valueOf(rs.getString("tipo")));
                usuario.setRendaMensal(rs.getBigDecimal("renda_mensal"));
                usuario.setDataCriacao(rs.getTimestamp("data_criacao"));
                usuario.setAtivo(rs.getBoolean("ativo"));
                
                lista.add(usuario);
            }
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao consultar todos: " + ex);
        }
        
        return lista.isEmpty() ? null : lista;
    }
    
    public Usuario consultarPorId(int id) throws ClassNotFoundException {
        String sql = "SELECT * FROM usuario WHERE id_usuario = ?";
        Usuario usuario = null;
        
        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setIdUsuario(rs.getInt("id_usuario"));
                    usuario.setNome(rs.getString("nome"));
                    usuario.setSobrenome(rs.getString("sobrenome"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setTelefone(rs.getString("telefone"));
                    usuario.setDataNascimento(rs.getDate("data_nascimento").toLocalDate());
                    usuario.setSenha(rs.getString("senha"));
                    usuario.setTipo(Usuario.TipoUsuario.valueOf(rs.getString("tipo")));
                    usuario.setRendaMensal(rs.getBigDecimal("renda_mensal"));
                    usuario.setDataCriacao(rs.getTimestamp("data_criacao"));
                    usuario.setAtivo(rs.getBoolean("ativo"));
                }
            }
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao consultar por ID: " + ex);
        }
        
        return usuario;
    }
    
    public boolean alterar(Usuario p_usuario) throws ClassNotFoundException {
        String sql = "UPDATE usuario SET nome = ?, sobrenome = ?, email = ?, telefone = ?, " +
                    "data_nascimento = ?, senha = ?, tipo = ?, renda_mensal = ?, ativo = ? " +
                    "WHERE id_usuario = ?";
        
        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {
            
            ps.setString(1, p_usuario.getNome());
            ps.setString(2, p_usuario.getSobrenome());
            ps.setString(3, p_usuario.getEmail());
            ps.setString(4, p_usuario.getTelefone());
            ps.setDate(5, Date.valueOf(p_usuario.getDataNascimento()));
            ps.setString(6, p_usuario.getSenha());
            ps.setString(7, p_usuario.getTipo().toString());
            ps.setBigDecimal(8, p_usuario.getRendaMensal());
            ps.setBoolean(9, p_usuario.isAtivo());
            ps.setInt(10, p_usuario.getIdUsuario());
            
            return ps.executeUpdate() > 0;
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao alterar: " + ex);
            return false;
        }
    }
    
    public boolean excluirPorId(int id) throws ClassNotFoundException {
        String sql = "DELETE FROM usuario WHERE id_usuario = ?";
        
        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao excluir: " + ex);
            return false;
        }
    }
    
    public Usuario login(String email, String senha) throws ClassNotFoundException {
        String sql = "SELECT * FROM usuario WHERE email = ? AND senha = ?";
        Usuario usuario = null;
        
        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, senha);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setIdUsuario(rs.getInt("id_usuario"));
                    usuario.setNome(rs.getString("nome"));
                    usuario.setSobrenome(rs.getString("sobrenome"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setTelefone(rs.getString("telefone"));
                    usuario.setDataNascimento(rs.getDate("data_nascimento").toLocalDate());
                    usuario.setSenha(rs.getString("senha"));
                    usuario.setTipo(Usuario.TipoUsuario.valueOf(rs.getString("tipo")));
                    usuario.setRendaMensal(rs.getBigDecimal("renda_mensal"));
                    usuario.setDataCriacao(rs.getTimestamp("data_criacao"));
                    usuario.setAtivo(rs.getBoolean("ativo"));
                }
            }
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao fazer login: " + ex);
        }
        
        return usuario;
    }
}