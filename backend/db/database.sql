-- Tabela de Usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    senha TEXT NOT NULL, -- em produção, use hash de senha
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Favoritos
CREATE TABLE IF NOT EXISTS favoritos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER,
    nome_produto TEXT NOT NULL,
    url_produto TEXT,
    preco_alvo REAL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);