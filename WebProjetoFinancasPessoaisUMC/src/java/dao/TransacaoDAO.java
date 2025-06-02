/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Transacao;
import util.ConectaDB;
import java.sql.*;


/**
 *
 * @author Henrique Vieira de Almeida
 */
public class TransacaoDAO {        
    public boolean inserir(Transacao p_transacao) throws ClassNotFoundException, SQLException {
        String sql = "INSERT INTO transacao (id_usuario, id_categoria, data, valor, tipo, mes_ano, nome) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (
            Connection conexao = ConectaDB.conectar();
            PreparedStatement ps = conexao.prepareStatement(sql)) {
                ps.setInt(1, p_transacao.getId_usuario());
                ps.setInt(2, p_transacao.getId_categoria());
                ps.setTimestamp(3, Timestamp.valueOf(p_transacao.getData()));
                ps.setDouble(4, p_transacao.getValor());
                ps.setString(5, p_transacao.getTipo().toString());
                ps.setString(6, p_transacao.getMesAno());
                ps.setString(7, p_transacao.getNome());
                
                return ps.executeUpdate() > 0;
        } catch(SQLException ex) {
            System.out.println("Erro SQL ao inserir: " + ex);
            return false;
        }        
    }
    
    public List<Transacao> consultarTodos() throws ClassNotFoundException {
        List<Transacao> lista = new ArrayList<>();
        String sql = "SELECT * FROM transacao ORDER BY data ASC";

        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Transacao transacao = new Transacao();
                transacao.setId_transacao(rs.getInt("id_transacao"));
                transacao.setId_usuario(rs.getInt("id_usuario"));
                transacao.setId_categoria(rs.getInt("id_categoria"));
                transacao.setData(rs.getTimestamp("data").toLocalDateTime());
                transacao.setValor(rs.getDouble("valor"));

                String tipoStr = rs.getString("tipo");
                try {
                    transacao.setTipo(Transacao.TipoTransacao.valueOf(tipoStr.toLowerCase()));
                } catch (IllegalArgumentException e) {
                    transacao.setTipo(Transacao.TipoTransacao.despesa);
                    System.err.println("Tipo de transação desconhecido: " + tipoStr);
                }
                transacao.setMesAno(rs.getString("mes_ano"));
                transacao.setNome(rs.getString("nome"));

                lista.add(transacao);
            }
        } catch (SQLException ex) {
            System.err.println("Erro ao consultar transações: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }
        return lista;
    }

    public List<Transacao> consultarPorUsuarioEMes(int idUsuario, String mesAno) throws ClassNotFoundException {
        List<Transacao> lista = new ArrayList<>();
        String sql = "SELECT * FROM transacao WHERE id_usuario = ? AND mes_ano = ? ORDER BY data ASC";

        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setString(2, mesAno);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transacao transacao = new Transacao();
                    transacao.setId_transacao(rs.getInt("id_transacao"));
                    transacao.setId_usuario(rs.getInt("id_usuario"));
                    transacao.setId_categoria(rs.getInt("id_categoria"));
                    transacao.setNome(rs.getString("nome"));
                    transacao.setData(rs.getTimestamp("data").toLocalDateTime());
                    transacao.setValor(rs.getDouble("valor"));
                    transacao.setTipo(Transacao.TipoTransacao.valueOf(rs.getString("tipo")));
                    transacao.setMesAno(rs.getString("mes_ano"));

                    lista.add(transacao);
                }
            }
        } catch (SQLException ex) {
            System.err.println("Erro ao consultar transações: " + ex.getMessage());
            throw new ClassNotFoundException("Erro ao acessar o banco de dados", ex);
        }

        return lista;
    }
    
    public boolean deletarPorId(int idTransacao) throws ClassNotFoundException {
        String sql = "DELETE FROM transacao WHERE id_transacao = ?";

        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {

            ps.setInt(1, idTransacao);
            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            System.err.println("Erro ao deletar transação: " + ex.getMessage());
            return false;
        }
    }

    public boolean atualizar(Transacao transacao) throws ClassNotFoundException {
        String sql = "UPDATE transacao SET id_usuario = ?, id_categoria = ?, valor = ?, tipo = ?, mes_ano = ?, nome = ? WHERE id_transacao = ?";
        try (Connection conexao = ConectaDB.conectar();
             PreparedStatement ps = conexao.prepareStatement(sql)) {

            ps.setInt(1, transacao.getId_usuario());
            ps.setInt(2, transacao.getId_categoria());
            ps.setDouble(3, transacao.getValor());
            ps.setString(4, transacao.getTipo().toString());
            ps.setString(5, transacao.getMesAno());
            ps.setString(6, transacao.getNome());
            ps.setInt(7, transacao.getId_transacao());

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Erro ao atualizar transação: " + ex.getMessage());
            return false;
        }
    }
}
