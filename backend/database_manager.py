import sqlite3
from sqlite3 import Error

def create_connection():
    """ Cria uma conexão com o banco de dados SQLite """
    conn = None
    try:
        # O arquivo poupe_pc.db será criado na raiz do projeto
        conn = sqlite3.connect('poupe_pc.db')
        return conn
    except Error as e:
        print(f"Erro ao conectar: {e}")
    return conn

def init_db():
    """ Inicializa as tabelas do sistema """
    conn = create_connection()
    if conn is not None:
        cursor = conn.cursor()
        
        # Tabela de Usuários
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL,
            data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
        );
        """)
        
        conn.commit()
        conn.close()
        print("Banco de dados inicializado com sucesso!")

def cadastrar_usuario(nome, email, senha):
    """ Exemplo de função para cadastrar um novo usuário """
    conn = create_connection()
    try:
        cursor = conn.cursor()
        sql = "INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)"
        cursor.execute(sql, (nome, email, senha))
        conn.commit()
        return True
    except sqlite3.IntegrityError:
        print("Erro: Este e-mail já está cadastrado.")
        return False
    finally:
        conn.close()

def verificar_login(email, senha):
    """ Função para validar o login na plataforma """
    conn = create_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM usuarios WHERE email = ? AND senha = ?", (email, senha))
    usuario = cursor.fetchone()
    conn.close()
    return usuario # Retorna os dados se o login for válido

# Inicializa o banco ao rodar o script
if __name__ == '__main__':
    init_db()