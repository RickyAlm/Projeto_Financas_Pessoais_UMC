/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Henrique Vieira de Almeida
 */
public class DadosMensais {
    private int id_dados_mensais;
    private int id_usuario;
    private String mes_ano;
    private double meta;
    private double renda_mensal;
    private double total_receitas;
    private double total_despesas;
    private double economia;

    public DadosMensais() {}

    public DadosMensais(int id_dados_mensais, int id_usuario, String mes_ano, double meta, double renda_mensal) {
        this.id_dados_mensais = id_dados_mensais;
        this.id_usuario = id_usuario;
        this.mes_ano = mes_ano;
        this.meta = meta;
        this.renda_mensal = renda_mensal;
    }

    public DadosMensais(
        int id_dados_mensais, int id_usuario, String mes_ano, double meta, double renda_mensal, 
        double total_receitas, double total_despesas, double economia
    ) {
        this.id_dados_mensais = id_dados_mensais;
        this.id_usuario = id_usuario;
        this.mes_ano = mes_ano;
        this.meta = meta;
        this.renda_mensal = renda_mensal;
        this.total_receitas = total_receitas;
        this.total_despesas = total_despesas;
        this.economia = economia;
    }

    public int getId_dados_mensais() {
        return id_dados_mensais;
    }

    public int getId_usuario() {
        return id_usuario;
    }

    public String getMes_ano() {
        return mes_ano;
    }

    public double getMeta() {
        return meta;
    }

    public double getRenda_mensal() {
        return renda_mensal;
    }

    public double getTotal_receitas() {
        return total_receitas;
    }

    public double getTotal_despesas() {
        return total_despesas;
    }

    public double getEconomia() {
        return economia;
    }

    public void setId_dados_mensais(int id_dados_mensais) {
        this.id_dados_mensais = id_dados_mensais;
    }

    public void setId_usuario(int id_usuario) {
        this.id_usuario = id_usuario;
    }

    public void setMes_ano(String mes_ano) {
        this.mes_ano = mes_ano;
    }

    public void setMeta(double meta) {
        this.meta = meta;
    }

    public void setRenda_mensal(double renda_mensal) {
        this.renda_mensal = renda_mensal;
    }

    public void setTotal_receitas(double total_receitas) {
        this.total_receitas = total_receitas;
    }

    public void setTotal_despesas(double total_despesas) {
        this.total_despesas = total_despesas;
    }

    public void setEconomia(double economia) {
        this.economia = economia;
    } 
}
