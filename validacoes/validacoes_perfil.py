from db import execute_one


def validar_perfil(nome, descricao):
    erros = []

    if not nome:
        erros.append('Informe o nome do perfil.')
    elif len(nome) < 3:
        erros.append('O nome deve ter pelo menos 3 caracteres.')
    elif len(nome) > 100:
        erros.append('O nome deve ter no máximo 100 caracteres.')

    if descricao and len(descricao) > 255:
        erros.append('A descrição deve ter no máximo 255 caracteres.')

    if not erros:
        existente = execute_one('SELECT id_perfil FROM perfis WHERE nome = %s', (nome,))
        if existente:
            erros.append('Já existe um perfil com este nome.')

    return erros
