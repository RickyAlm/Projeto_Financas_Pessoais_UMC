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
        String sql = "INSERT INTO usuario (nome, sobrenome, email, telefone, data_nascimento, senha, tipo, data_criacao, ativo) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conexao = ConectaDB.conectar();
            PreparedStatement ps = conexao.prepareStatement(sql)) {
            
            ps.setString(1, p_usuario.getNome());
            ps.setString(2, p_usuario.getSobrenome());
            ps.setString(3, p_usuario.getEmail());
            ps.setString(4, p_usuario.getTelefone());
            ps.setDate(5, Date.valueOf(p_usuario.getDataNascimento()));
            ps.setString(6, p_usuario.getSenha());
            ps.setString(7, p_usuario.getTipo().toString());
            ps.setTimestamp(8, p_usuario.getDataCriacao());
            ps.setBoolean(9, p_usuario.isAtivo());
            
            return ps.executeUpdate() > 0;
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao inserir: " + ex);
            return false;
        }
    }
    
    public Usuario buscarPorEmail(String email) throws ClassNotFoundException, SQLException {
        String sql = "SELECT * FROM usuario WHERE email = ?";
        Usuario usuario = null;

        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {

            ps.setString(1, email);

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
                    usuario.setDataCriacao(rs.getTimestamp("data_criacao"));
                    usuario.setAtivo(rs.getBoolean("ativo"));
                }
            }
        }
        return usuario;
    }
    
    public boolean verificarCredenciais(String email, String senha) throws ClassNotFoundException, SQLException {
        Usuario usuario = buscarPorEmail(email);
        
        if (usuario != null) {
            return usuario.getSenha().equals(senha) && usuario.isAtivo();
        }
        
        return false;
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
                    "data_nascimento = ?, senha = ?, tipo = ?, ativo = ? " +
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
            ps.setBoolean(8, p_usuario.isAtivo());
            ps.setInt(9, p_usuario.getIdUsuario());
            
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
    
    public Usuario login(String email, String senha) throws ClassNotFoundException, SQLException {
        Usuario usuario = buscarPorEmail(email);
        
        if (usuario != null && usuario.getSenha().equals(senha) && usuario.isAtivo()) {
            return usuario;
        }
        return null;
    }
    
    public boolean verificarSenha(int idUsuario, String senha) throws ClassNotFoundException {
        String sql = "SELECT senha FROM usuario WHERE id_usuario = ?";

        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("senha").equals(senha);
                }
            }
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao verificar senha: " + ex);
        }

        return false;
    }

    public boolean atualizarDadosBasicos(Usuario usuario) throws ClassNotFoundException {
        String sql = "UPDATE usuario SET nome = ?, sobrenome = ?, email = ?, telefone = ?, data_nascimento = ? WHERE id_usuario = ?";

        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {

            ps.setString(1, usuario.getNome());
            ps.setString(2, usuario.getSobrenome());
            ps.setString(3, usuario.getEmail());
            ps.setString(4, usuario.getTelefone());
            ps.setDate(5, Date.valueOf(usuario.getDataNascimento()));
            ps.setInt(6, usuario.getIdUsuario());

            return ps.executeUpdate() > 0;
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao atualizar dados básicos: " + ex);
            return false;
        }
    }

    public boolean atualizarSenha(int idUsuario, String novaSenha) throws ClassNotFoundException {
        String sql = "UPDATE usuario SET senha = ? WHERE id_usuario = ?";

        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {

            ps.setString(1, novaSenha);
            ps.setInt(2, idUsuario);

            return ps.executeUpdate() > 0;
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao atualizar senha: " + ex);
            return false;
        }
    }
    
    public boolean isAdmin(int idUsuario) throws ClassNotFoundException {
        String sql = "SELECT tipo FROM usuario WHERE id_usuario = ?";

        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Usuario.TipoUsuario.valueOf(rs.getString("tipo")) == Usuario.TipoUsuario.admin;
                }
            }
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao verificar admin: " + ex);
        }
        return false;
    }
}