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
        String sql = "SELECT * FROM categoria ORDER BY id_categoria DESC";

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

    public List<Categoria> consultarComBusca(String busca, String filtroTipo) throws ClassNotFoundException {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT * FROM categoria WHERE (nome LIKE ? OR tipo LIKE ?)";
        if (filtroTipo != null && !filtroTipo.isEmpty()) {
            sql += " AND tipo = ?";
        }
        sql += " ORDER BY id_categoria DESC";
        try (Connection conexao = ConectaDB.conectar();
            PreparedStatement ps = conexao.prepareStatement(sql)) {
            String filtro = "%" + (busca == null ? "" : busca) + "%";
            ps.setString(1, filtro);
            ps.setString(2, filtro);
            if (filtroTipo != null && !filtroTipo.isEmpty()) {
                ps.setString(3, filtroTipo);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Categoria categoria = new Categoria(
                        rs.getInt("id_categoria"),
                        rs.getString("nome"),
                        rs.getString("tipo")
                    );
                    lista.add(categoria);
                }
            }
        } catch (SQLException ex) {
            System.err.println("Erro ao consultar categorias: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }
        return lista;
    }

    public Categoria consultarPorId(int id) throws ClassNotFoundException {
        String sql = "SELECT * FROM categoria WHERE id_categoria = ?";
        try (Connection conexao = ConectaDB.conectar();
            PreparedStatement ps = conexao.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Categoria(
                        rs.getInt("id_categoria"),
                        rs.getString("nome"),
                        rs.getString("tipo")
                    );
                }
            }
        } catch (SQLException ex) {
            System.err.println("Erro ao consultar categoria por ID: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }
        return null;
    }

    public boolean inserir(Categoria categoria) throws ClassNotFoundException {
        String sql = "INSERT INTO categoria (nome, tipo) VALUES (?, ?)";
        try (Connection conexao = ConectaDB.conectar();
            PreparedStatement ps = conexao.prepareStatement(sql)) {
            ps.setString(1, categoria.getNome());
            ps.setString(2, categoria.getTipo());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Erro ao inserir categoria: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }
    }

    public boolean alterar(Categoria categoria) throws ClassNotFoundException {
        String sql = "UPDATE categoria SET nome = ?, tipo = ? WHERE id_categoria = ?";
        try (Connection conexao = ConectaDB.conectar();
            PreparedStatement ps = conexao.prepareStatement(sql)) {
            ps.setString(1, categoria.getNome());
            ps.setString(2, categoria.getTipo());
            ps.setInt(3, categoria.getId_categoria());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Erro ao alterar categoria: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }
    }

    public boolean excluirPorId(int id) throws ClassNotFoundException {
        String sql = "DELETE FROM categoria WHERE id_categoria = ?";
        try (Connection conexao = ConectaDB.conectar();
            PreparedStatement ps = conexao.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Erro ao excluir categoria: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }
    }

    public List<Categoria> consultarComBuscaPaginado(String busca, String filtroTipo, int offset, int limite) throws ClassNotFoundException {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT * FROM categoria WHERE (nome LIKE ? OR tipo LIKE ?)";
        if (filtroTipo != null && !filtroTipo.isEmpty()) {
            sql += " AND tipo = ?";
        }
        sql += " ORDER BY id_categoria DESC LIMIT ? OFFSET ?";
        try (Connection conexao = ConectaDB.conectar();
            PreparedStatement ps = conexao.prepareStatement(sql)) {
            String filtro = "%" + (busca == null ? "" : busca) + "%";
            ps.setString(1, filtro);
            ps.setString(2, filtro);
            int paramIndex = 3;
            if (filtroTipo != null && !filtroTipo.isEmpty()) {
                ps.setString(paramIndex++, filtroTipo);
            }
            ps.setInt(paramIndex++, limite);
            ps.setInt(paramIndex, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Categoria categoria = new Categoria(
                        rs.getInt("id_categoria"),
                        rs.getString("nome"),
                        rs.getString("tipo")
                    );
                    lista.add(categoria);
                }
            }
        } catch (SQLException ex) {
            System.err.println("Erro ao consultar categorias paginadas: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }
        return lista;
    }
}
