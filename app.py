import os

from dotenv import load_dotenv
from flask import Flask, flash, redirect, render_template, request, url_for
from flask_wtf.csrf import CSRFProtect
from mysql.connector import Error

from db import execute_insert, execute_query
from validacoes.validacoes_perfil import validar_perfil

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY')
CSRFProtect(app)


# ================== PÁGINAS PRINCIPAIS ==================

@app.route('/')
def index():
    return redirect(url_for('login'))


@app.route('/login')
def login():
    return render_template('login.html')


@app.route('/dashboard')
def dashboard():
    return render_template('dashboard.html')


# ================== TELAS DE EXEMPLO (só o visual, sem banco) ==================

@app.route('/usuarios')
def listar_usuarios():
    return render_template('usuarios/listar.html')


@app.route('/usuarios/cadastrar')
def cadastrar_usuario():
    return render_template('usuarios/cadastrar.html')


@app.route('/filmes')
def listar_filmes():
    return render_template('filmes/listar.html')


@app.route('/filmes/cadastrar')
def cadastrar_filme():
    return render_template('filmes/cadastrar.html')


@app.route('/sessoes')
def listar_sessoes():
    return render_template('sessoes/listar.html')


@app.route('/sessoes/cadastrar')
def cadastrar_sessao():
    return render_template('sessoes/cadastrar.html')


# ================== PERFIS ==================

@app.route('/perfis')
def listar_perfis():
    perfis = execute_query(
        'SELECT id_perfil, nome, descricao, criado_em FROM perfis ORDER BY nome',
        fetch=True,
    )
    return render_template('perfis/listar.html', perfis=perfis)


@app.route('/perfis/inserir', methods=['GET', 'POST'])
def inserir_perfil():
    nome = ''
    descricao = ''

    if request.method == 'POST':
        nome = request.form.get('nome', '').strip()
        descricao = request.form.get('descricao', '').strip() or None

        erros = validar_perfil(nome, descricao)

        if erros:
            for mensagem in erros:
                flash(mensagem, 'danger')
        else:
            try:
                novo_id = execute_insert(
                    'INSERT INTO perfis (nome, descricao) VALUES (%s, %s)',
                    (nome, descricao),
                )
                flash(f'Perfil "{nome}" cadastrado (código {novo_id}).', 'success')
                return redirect(url_for('listar_perfis'))
            except Error as erro:
                if erro.errno == 1062:
                    flash('Já existe um perfil com este nome.', 'danger')
                else:
                    raise

    return render_template('perfis/cadastrar.html', nome=nome, descricao=descricao)


# ================== ERROS ==================

@app.errorhandler(404)
def pagina_nao_encontrada(erro):
    return render_template('404.html'), 404


@app.errorhandler(500)
def erro_no_servidor(erro):
    return render_template('500.html'), 500


if __name__ == '__main__':
    app.run(debug=True)
