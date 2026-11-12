-- DROP DATABASE IF EXISTS cineclub;   -- tire o "--" só se quiser apagar tudo e recomeçar do zero

CREATE DATABASE IF NOT EXISTS cineclub
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE cineclub;

-- perfis vem antes de usuarios, porque usuarios aponta para ele (chave estrangeira).
CREATE TABLE IF NOT EXISTS perfis (
    id_perfil     BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL UNIQUE,
    descricao     VARCHAR(255),
    criado_em     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(255) NOT NULL,
    email           VARCHAR(255) NOT NULL UNIQUE,
    senha           VARCHAR(255) NOT NULL,      -- guarda o HASH, nunca a senha
    celular         VARCHAR(20),
    data_nascimento DATE,
    cpf             VARCHAR(14) UNIQUE,         -- gravado como 000.000.000-00
    perfil_id       BIGINT UNSIGNED NOT NULL,
    cep             VARCHAR(9),
    endereco        VARCHAR(255),
    numero          VARCHAR(20),
    complemento     VARCHAR(100),
    cidade          VARCHAR(100),
    estado          CHAR(2),
    criado_em       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_perfis
        FOREIGN KEY (perfil_id) REFERENCES perfis (id_perfil)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Tema do projeto: filmes e sessões (no lugar de produtos).
CREATE TABLE IF NOT EXISTS filmes (
    id_filme      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titulo        VARCHAR(255) NOT NULL,
    diretor       VARCHAR(255) NOT NULL,
    genero        VARCHAR(100) NOT NULL,
    ano           SMALLINT UNSIGNED NOT NULL,
    duracao       SMALLINT UNSIGNED NOT NULL,   -- em minutos
    criado_em     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- filmes vem antes de sessoes, porque sessoes aponta para ele (chave estrangeira).
CREATE TABLE IF NOT EXISTS sessoes (
    id_sessao     BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    filme_id      BIGINT UNSIGNED NOT NULL,
    sala          VARCHAR(50) NOT NULL,
    data_sessao   DATE NOT NULL,
    horario       TIME NOT NULL,
    valor         DECIMAL(10,2) NOT NULL,
    criado_em     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_sessoes_filmes
        FOREIGN KEY (filme_id) REFERENCES filmes (id_filme)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
