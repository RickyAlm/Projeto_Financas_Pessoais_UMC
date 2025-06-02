/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import model.DadosMensais;
import util.ConectaDB;

/**
 *
 * @author Henrique Vieira de Almeida
 */
public class DadosMensaisDAO {
    public DadosMensais buscarPorUsuarioEMes(int idUsuario, String mesAno) {
        DadosMensais dados = null;
        try (Connection con = ConectaDB.conectar()) {
            String sql = "SELECT * FROM dados_mensais WHERE id_usuario = ? AND mes_ano = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setString(2, mesAno);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                dados = new DadosMensais(
                    rs.getInt("id_dados_mensais"),
                    rs.getInt("id_usuario"),
                    rs.getString("mes_ano"),
                    rs.getDouble("meta"),
                    rs.getDouble("renda_mensal"),
                    rs.getDouble("total_receitas"),
                    rs.getDouble("total_despesas"),
                    rs.getDouble("economia")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dados;
    }

    public boolean inserir(DadosMensais dados) {
        try (Connection con = ConectaDB.conectar()) {
            String sql = "INSERT INTO dados_mensais (id_usuario, mes_ano, meta, renda_mensal, total_receitas, total_despesas, economia) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, dados.getId_usuario());
            ps.setString(2, dados.getMes_ano());
            ps.setDouble(3, dados.getMeta());
            ps.setDouble(4, dados.getRenda_mensal());
            ps.setDouble(5, dados.getTotal_receitas());
            ps.setDouble(6, dados.getTotal_despesas());
            ps.setDouble(7, dados.getEconomia());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizarRendaMensal(int idUsuario, String mesAno, double rendaMensal) {
        try (Connection con = ConectaDB.conectar()) {
            String sql = "UPDATE dados_mensais SET renda_mensal = ? WHERE id_usuario = ? AND mes_ano = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDouble(1, rendaMensal);
            ps.setInt(2, idUsuario);
            ps.setString(3, mesAno);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizarTotais(int idUsuario, String mesAno, double totalReceitas, double totalDespesas, double economia) {
        try (Connection con = ConectaDB.conectar()) {
            String sql = "UPDATE dados_mensais SET total_receitas = ?, total_despesas = ?, economia = ? WHERE id_usuario = ? AND mes_ano = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDouble(1, totalReceitas);
            ps.setDouble(2, totalDespesas);
            ps.setDouble(3, economia);
            ps.setInt(4, idUsuario);
            ps.setString(5, mesAno);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizarMeta(int idUsuario, String mesAno, double meta) {
        try (Connection con = ConectaDB.conectar()) {
            String sql = "UPDATE dados_mensais SET meta = ? WHERE id_usuario = ? AND mes_ano = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDouble(1, meta);
            ps.setInt(2, idUsuario);
            ps.setString(3, mesAno);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
