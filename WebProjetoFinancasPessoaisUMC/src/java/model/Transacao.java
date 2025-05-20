package model;

import java.time.LocalDate;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Henrique Vieira de Almeida
 */
public class Transacao {
    private int id_transacao;
    private int id_usuario;
    private int id_categoria;
    private LocalDate data;
    private double valor;
    private TipoTransacao tipo;
    private String mesAno;
    
    public enum TipoTransacao {
        receita, despesa
    }

    public Transacao() {}
    
    public Transacao(int id_transacao, int id_usuario, int id_categoria, LocalDate data, double valor, TipoTransacao tipo, String mesAno) {
        this.id_transacao = id_transacao;
        this.id_usuario = id_usuario;
        this.id_categoria = id_categoria;
        this.data = data;
        this.valor = valor;
        this.tipo = tipo;
        this.mesAno = mesAno;
    }
    
    public int getId_transacao() {
        return id_transacao;
    }

    public int getId_usuario() {
        return id_usuario;
    }

    public int getId_categoria() {
        return id_categoria;
    }

    public LocalDate getData() {
        return data;
    }

    public double getValor() {
        return valor;
    }

    public TipoTransacao getTipo() {
        return tipo;
    }

    public String getMesAno() {
        return mesAno;
    }

    public void setId_transacao(int id_transacao) {
        this.id_transacao = id_transacao;
    }

    public void setId_usuario(int id_usuario) {
        this.id_usuario = id_usuario;
    }

    public void setId_categoria(int id_categoria) {
        this.id_categoria = id_categoria;
    }

    public void setData(LocalDate data) {
        this.data = data;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }

    public void setTipo(TipoTransacao tipo) {
        this.tipo = tipo;
    }

    public void setMesAno(String mesAno) {
        this.mesAno = mesAno;
    }   
}
