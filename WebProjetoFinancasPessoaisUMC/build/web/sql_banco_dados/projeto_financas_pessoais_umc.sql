/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/SQLTemplate.sql to edit this template
 */
/**
 * Author:  Henrique Vieira de Almeida
 * Created: 6 de jun. de 2025
 */

CREATE DATABASE `projeto_financas_pessoais_umc`;
USE `projeto_financas_pessoais_umc`;

CREATE TABLE `usuario`(
    `id_usuario` INT PRIMARY KEY AUTO_INCREMENT,
    `nome` VARCHAR(50) NOT NULL,
    `sobrenome` VARCHAR(50) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `telefone` VARCHAR(15) NOT NULL,
    `data_nascimento` DATE NOT NULL,
    `senha` CHAR(60) NOT NULL,
    `tipo` ENUM('admin', 'comum') DEFAULT 'comum',
    `renda_mensal` DECIMAL(10,2),
    `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `ativo` BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `categoria` (
    `id_categoria` INT PRIMARY KEY AUTO_INCREMENT,
    `nome` VARCHAR(50) NOT NULL,
    `tipo` ENUM('receita', 'despesa') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `transacao` (
    `id_transacao` INT PRIMARY KEY AUTO_INCREMENT,
    `id_usuario` INT NOT NULL,
    `id_categoria` INT NOT NULL,
    `data` DATE NOT NULL,
    `valor` DECIMAL(10,2) NOT NULL,
    `tipo` ENUM('receita', 'despesa') NOT NULL,
    `mes_ano` CHAR(7) NOT NULL,
    FOREIGN KEY (`id_usuario`) REFERENCES `usuario`(`id_usuario`) ON DELETE CASCADE,
    FOREIGN KEY (`id_categoria`) REFERENCES `categoria`(`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `dados_mensais`(
    `id_dados_mensais` INT PRIMARY KEY AUTO_INCREMENT,
    `id_usuario` INT NOT NULL,
    `mes_ano` CHAR(7) NOT NULL,
    `meta` DECIMAL(15,2) NOT NULL DEFAULT 0,
    `renda_mensal` DECIMAL(15,2) NOT NULL DEFAULT 0,
    `total_receitas` DOUBLE(15,2) DEFAULT 0,
    `total_despesas` DOUBLE(15,2) DEFAULT 0,
    `economia` DOUBLE(15,2) DEFAULT 0,
    CONSTRAINT `unq_usuario_mes` UNIQUE (`id_usuario`, `mes_ano`),
    FOREIGN KEY (`id_usuario`) REFERENCES `usuario`(`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;