"""Inventário estático conservador. Apenas escreve CSV/Markdown; não altera assets."""
import argparse
import csv
import os
import re
from collections import Counter, defaultdict
from pathlib import Path

TEXT = {'.gd', '.tscn', '.tres', '.godot', '.json', '.shader', '.gdshader', '.cfg'}
ASSETS = {'.tscn', '.tres', '.res', '.scn', '.shader', '.gdshader', '.json',
          '.png', '.png1', '.jpg', '.jpeg', '.webp', '.svg', '.bmp', '.tga', '.gif',
          '.wav', '.ogg', '.mp3', '.flac', '.ttf', '.otf', '.woff', '.woff2',
          '.mp4', '.webm', '.ogv', '.glb', '.gltf', '.obj', '.fbx', '.blend',
          '.psd', '.xcf', '.aseprite', '.ase', '.zip', '.rar', '.7z', '.pck', '.ico', '.exr', '.hdr'}
CACHE = {'.git', '.import', '.godot', '.vs', '.codex_tmp', 'tmp', 'build', 'output', 'android'}
STRINGS = re.compile(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|#[^\n]*')
REF = re.compile(r'(ExtResource|SubResource)\(\s*"?([^\s\)"]+)"?\s*\)')
PATH = re.compile(r'res://[^"\'\r\n]+')
CATEGORIES = ['Jogo atual', 'Testes/protótipos', 'Uso incerto', 'Sem referência encontrada']


def uncomment(text):
    return STRINGS.sub(lambda m: '' if m[0].startswith('#') else m[0], text)


def uncomment_shader(text):
    tokens = re.compile(r'"(?:\\.|[^"\\])*"|//[^\n]*|/\*[\s\S]*?\*/')
    return tokens.sub(lambda m: '\n' * m[0].count('\n') if m[0].startswith('/') else m[0], text)


def scene_contexts(text):
    """Associe referências em sub-recursos aos nós que os consomem."""
    definitions, uses, contexts = {}, defaultdict(set), defaultdict(set)
    owner = ''
    for line in text.splitlines():
        if line.startswith('[ext_resource '):
            path = re.search(r'path="([^"]+)"', line)
            ident = re.search(r'id=("[^"]+"|[^\s\]]+)', line)
            if path and ident:
                definitions[('ExtResource', ident[1].strip('"'))] = path[1]
        if line.startswith('[sub_resource '):
            ident = re.search(r'id=("[^"]+"|[^\s\]]+)', line)
            owner = ('SubResource', ident[1].strip('"')) if ident else ''
        elif line.startswith('[node '):
            name = re.search(r'name="([^"]+)"', line)[1]
            parent = re.search(r'parent="([^"]+)"', line)
            owner = name if not parent else parent[1].rstrip('/') + '/' + name
        elif line.startswith('[resource]'):
            owner = 'resource'
        if '=' in line and not line.startswith('['):
            prop = line.split('=', 1)[0].strip()
            for kind, ident in REF.findall(line):
                uses[(kind, ident)].add((owner, prop))
            for path in PATH.findall(line):
                key = ('literal', path)
                definitions[key] = path
                uses[key].add((owner, prop))
        if line.startswith('[node '):
            for kind, ident in REF.findall(line):
                uses[(kind, ident)].add((owner, 'instance'))
    def consumers(key, seen):
        if key in seen:
            return set()
        result = set()
        for owner, prop in uses[key]:
            if isinstance(owner, tuple):
                for node, outer in consumers(owner, seen | {key}):
                    result.add((node, outer + ' → ' + prop))
            else:
                result.add((owner, prop))
        return result
    for key, path in definitions.items():
        contexts[path].update(consumers(key, set()))
    return contexts


def scan(root):
    files, excluded, imports, nested = {}, Counter(), Counter(), []
    for base, dirs, names in os.walk(root):
        dirs[:] = sorted(d for d in dirs if d != '.git')
        folder = Path(base)
        if folder != root and 'project.godot' in names:
            nested.append(folder.relative_to(root).as_posix())
        for name in sorted(names):
            path = folder / name
            rel = path.relative_to(root).as_posix()
            bucket = next((part for part in Path(rel).parts if part in CACHE), '')
            size = path.stat().st_size
            if bucket:
                excluded[bucket] += size
            elif name.endswith('.import'):
                imports['bytes'] += size
                imports['count'] += 1
            else:
                files['res://' + rel] = (path, size)
    texts = {key: path.read_text(encoding='utf-8-sig', errors='replace')
             for key, (path, _) in files.items() if path.suffix.lower() in TEXT}
    classes = {}
    for key, text in texts.items():
        match = re.search(r'^class_name\s+(\w+)', uncomment(text), re.M)
        if match:
            classes[match[1]] = key
    graph, incoming, dynamic, unresolved = defaultdict(set), defaultdict(set), [], []
    for source, raw in sorted(texts.items()):
        text = (uncomment(raw) if source.endswith('.gd') else uncomment_shader(raw)
                if source.endswith(('.shader', '.gdshader')) else raw)
        if source == 'res://project.godot':
            # Registros de class_name não são entradas executadas automaticamente.
            start = text.index('[application]')
            text = '\n' * text[:start].count('\n') + text[start:]
        contexts = scene_contexts(text) if source.endswith(('.tscn', '.tres')) else {}
        project_folder = next((folder for folder in sorted(nested, key=len, reverse=True)
                               if source[6:].startswith(folder + '/')), '')
        for number, line in enumerate(text.splitlines(), 1):
            for match in PATH.finditer(line):
                original = match[0]
                target = 'res://' + project_folder + '/' + original[6:] if project_folder else original
                where = source + ':' + str(number)
                if target in files:
                    graph[source].add(target)
                    ctx = '; '.join(node + ' [' + prop + ']' for node, prop in sorted(contexts.get(original, [])))
                    incoming[target].add((where, ctx, 'Referência literal'))
                elif '%' in target or target.endswith('/') or (root / target[6:]).is_dir():
                    prefix = target.split('%', 1)[0]
                    dynamic.append((source, number, target, prefix))
                else:
                    unresolved.append((source, number, target))
            if source.endswith('.gd'):
                for word in set(re.findall(r'\b\w+\b', STRINGS.sub('', line))):
                    if word in classes and classes[word] != source:
                        graph[source].add(classes[word])
                if re.search(r'\b(?:load|preload|load_interactive|play_path)\(', line) and 'res://' not in line:
                    dynamic.append((source, number, line.strip(), ''))
    seeds = ['res://project.godot']
    if 'res://default_bus_layout.tres' in files:
        seeds.append('res://default_bus_layout.tres')
    return files, texts, graph, incoming, dynamic, unresolved, seeds, excluded, imports, nested


def reachable(graph, seeds):
    seen, todo = set(), list(seeds)
    while todo:
        source = todo.pop()
        if source not in seen:
            seen.add(source)
            todo.extend(graph.get(source, ()))
    return seen


def resolved_character_paths(text):
    """Expansões finitas conferidas em CharacterController; mudanças deixam de resolver."""
    result = []
    def add(anchor, paths):
        if anchor in text:
            number = text[:text.index(anchor)].count('\n') + 1
            result.extend((number, path) for path in paths)
    faces = re.search(r'const FACE_IDS = \[([^\]]+)\]', text)
    if faces:
        ids = re.findall(r'"([^"]+)"', faces[1])
        add('const FACE_PATH = "res://assets/SpritesV4/Feicoes/%s.png"',
            ['res://assets/SpritesV4/Feicoes/' + face + '.png' for face in ids])
    # Valores de gênero/cabelo/roupa e intervalos conferidos nos seletores e neste script.
    for folder, gender in [('Menino', 'boy'), ('Menina', 'girl')]:
        add('return load("res://assets/SpritesV4/Cabecas/%s/%s.png"',
            [f'res://assets/SpritesV4/Cabecas/{folder}/{gender}{n}.png' for n in (1, 2)])
        add('return load("res://assets/SpritesV4/Cabecas/%s/%s_noface.png"',
            [f'res://assets/SpritesV4/Cabecas/{folder}/{gender}{n}_noface.png' for n in (1, 2)])
        add('var happy_head = "res://assets/SpritesV4/Cabecas/%s/%s1.png"',
            [f'res://assets/SpritesV4/Cabecas/{folder}/{gender}1.png'])
        add('plataform.sleeping = load("res://assets/SpritesV4/RoupasNormais/%s/dormindo-%s.png"',
            [f'res://assets/SpritesV4/RoupasNormais/{folder}/dormindo-{hair}.png' for hair in ('a', 'b')])
        if 'for frame in range(1, 6):' in text and '"girlsc-1-%d.png" % (frame + 1)' in text:
            for variation in (1, 2):
                base = f'res://assets/SpritesV4/RoupasNormais/{folder}/Variacao{variation}/'
                names = ['sentado.png', 'sentado-s.png']
                names += ([f'girlsc-1-{n}.png' for n in range(1, 7)] if gender == 'girl' and variation == 2
                          else [f'm{n}{dirty}.png' for n in range(6) for dirty in ('', '-s')])
                add('var normal_path = "res://assets/SpritesV4/RoupasNormais/%s/%s/"', [base + name for name in names])
        if 'for bath_frame in range(1, 6):' in text:
            add('var bath_path = "res://assets/Sprites-v3/%s-banho/%s-banho-"',
                [f'res://assets/Sprites-v3/{gender}-banho/{gender}-banho-m{n}{dirty}.png'
                 for n in range(6) for dirty in ('', '-s')])
    if 'for frame in range(1, 8):' in text:
        for anchor, pattern in [('"res://assets/SpritesV4/RoupasEspeciais/Chuva/Correndo/boy_rc_%d.png" % frame',
                                 'res://assets/SpritesV4/RoupasEspeciais/Chuva/Correndo/boy_rc_%d.png'),
                                ('"res://assets/SpritesV4/RoupasEspeciais/Neve/Correndo/correrneve-%d.png" % frame',
                                 'res://assets/SpritesV4/RoupasEspeciais/Neve/Correndo/correrneve-%d.png')]:
            add(anchor, [pattern % frame for frame in range(1, 8)])
    return result


def inventory(root):
    files, texts, graph, incoming, dynamic, missing, seeds, excluded, imports, nested = scan(root)
    source = 'res://src/CharacterController.gd'
    for number, target in resolved_character_paths(uncomment(texts.get(source, ''))):
        if target in files:
            graph[source].add(target)
            incoming[target].add((source + ':' + str(number), '', 'Caminho dinâmico resolvido: escolhas/frames finitos'))
        else:
            missing.append((source, number, target))
    game = reachable(graph, seeds)
    assets = {p for p, (file, _) in files.items() if file.suffix.lower() in ASSETS}
    other_seeds = [p for p in texts if p not in game and p.endswith(('.gd', '.tscn', '.tres', '.godot'))]
    other = reachable(graph, other_seeds)
    uncertain = set()
    for source, number, pattern, prefix in dynamic:
        if source not in game or not prefix:
            continue
        # ponytail: prefixo conservador; interpretar expressões GDScript se a revisão exigir precisão maior.
        for asset in assets:
            if asset.startswith(prefix):
                uncertain.add(asset)
                incoming[asset].add((source + ':' + str(number), '', 'Possível caminho dinâmico: ' + pattern))
    uncertain = reachable(graph, uncertain) - game
    rows = []
    for asset in sorted(assets):
        category = ('Jogo atual' if asset in game else 'Uso incerto' if asset in uncertain
                    else 'Testes/protótipos' if asset in other else 'Sem referência encontrada')
        refs = sorted(incoming[asset])
        notes = sorted({kind for _, _, kind in refs})
        location = next((p for p in nested if asset[6:].startswith(p + '/')), '')
        if location:
            notes.append('Projeto aninhado: ' + location)
        if asset in game:
            notes.append('Alcançável estaticamente; execução de cada ramo não comprovada')
        rows.append({'caminho': asset, 'tamanho_bytes': files[asset][1], 'classificacao': category,
                     'origem_referencia': ' | '.join(sorted({where for where, _, _ in refs})),
                     'cena_no_propriedade': ' | '.join(where + ' → ' + ctx for where, ctx, _ in refs if ctx),
                     'observacoes': ' | '.join(notes)})
    return rows, game, dynamic, missing, excluded, imports, nested


def summary(rows, game, dynamic, missing, excluded, imports, nested):
    lines = ['<!-- BEGIN INVENTARIO GERADO -->', '## Resultado do rastreamento estático',
             '', 'Gerado por `tools/inventory_assets.py`; tamanhos dos arquivos-fonte, em MiB (1.048.576 bytes).',
             '', '| Classificação | Arquivos | MiB |', '|---|---:|---:|']
    for category in CATEGORIES:
        selected = [r for r in rows if r['classificacao'] == category]
        lines.append(f"| {category} | {len(selected)} | {sum(r['tamanho_bytes'] for r in selected)/1048576:.2f} |")
    lines += [f"| **Total** | **{len(rows)}** | **{sum(r['tamanho_bytes'] for r in rows)/1048576:.2f}** |", '',
              '### Por pasta e classificação', '', '| Pasta | Classificação | Arquivos | MiB |', '|---|---|---:|---:|']
    groups = defaultdict(list)
    for row in rows:
        parts = row['caminho'][6:].split('/')
        groups[('/'.join(parts[:2]) if len(parts) > 2 else parts[0] if len(parts) > 1 else '(raiz)', row['classificacao'])].append(row)
    for (folder, category), selected in sorted(groups.items()):
        lines.append(f"| `{folder}` | {category} | {len(selected)} | {sum(r['tamanho_bytes'] for r in selected)/1048576:.2f} |")
    lines += ['', '### Maiores candidatos à revisão', '', '| Caminho | Classificação | MiB |', '|---|---|---:|']
    for row in sorted((r for r in rows if r['classificacao'] != 'Jogo atual'), key=lambda r: (-r['tamanho_bytes'], r['caminho']))[:25]:
        lines.append(f"| `{row['caminho']}` | {row['classificacao']} | {row['tamanho_bytes']/1048576:.2f} |")
    lines += ['', '### Maiores assets do jogo atual', '', '| Caminho | MiB |', '|---|---:|']
    for row in sorted((r for r in rows if r['classificacao'] == 'Jogo atual'), key=lambda r: (-r['tamanho_bytes'], r['caminho']))[:10]:
        lines.append(f"| `{row['caminho']}` | {row['tamanho_bytes']/1048576:.2f} |")
    lines += ['', '### Armazenamento separado', '', 'Estes arquivos não entram no total de assets-fonte acima; `.git` não foi medido.', '', '| Área | MiB |', '|---|---:|']
    for folder, size in sorted(excluded.items()):
        lines.append(f'| `{folder}` | {size/1048576:.2f} |')
    lines += [f"| Metadados `.import` ({imports['count']} arquivos) | {imports['bytes']/1048576:.2f} |", '',
              'Projetos aninhados: ' + ', '.join('`' + p + '`' for p in nested) + '.', '',
              '### Padrões e carregamentos dinâmicos no jogo', '',
              'Prefixos mantêm candidatos como uso incerto. Chamadas sem prefixo exigem leitura do produtor do caminho; referências literais e catálogos alcançáveis já entram no grafo.', '',
              '| Origem | Expressão / padrão |', '|---|---|']
    for source, number, pattern, _ in sorted(set(dynamic)):
        if source in game:
            lines.append(f'| `{source}:{number}` | `{pattern.replace("|", "&#124;")}` |')
    lines += ['', '### Referências literais sem arquivo correspondente', '',
              'Inclui todos os contextos analisados. Caminhos de pastas/padrões ficam na seção dinâmica. Não são falhas comprovadas em execução.', '',
              '| Origem | Caminho | Contexto |', '|---|---|---|']
    for source, number, target in sorted(set(missing)):
        lines.append(f'| `{source}:{number}` | `{target}` | {"Jogo atual" if source in game else "Fora do fluxo atual"} |')
    lines += ['', '<!-- END INVENTARIO GERADO -->']
    return '\n'.join(lines)


def self_check():
    import tempfile
    assert uncomment('var color = "#fff" # ignored') == 'var color = "#fff" '
    assert uncomment_shader('"res://kept.png" // res://ignored.png\n/* res://ignored2.png */') == '"res://kept.png" \n'
    with tempfile.TemporaryDirectory() as temp:
        root = Path(temp)
        (root / 'project.godot').write_text('[application]\nrun/main_scene="res://main.tscn"\n')
        (root / 'main.tscn').write_text('[ext_resource path="res://material.tres" id=1]\n[node name="Root"]\nmaterial = ExtResource( 1 )\n')
        (root / 'material.tres').write_text('[resource]\nnext="res://main.tscn"\ntexture="res://used, asset.png"\nscript="res://code.gd"\n')
        (root / 'code.gd').write_text('# load("res://unused.png")\nvar p="res://dynamic/%s.png"\n')
        (root / 'dynamic').mkdir()
        for name in ['used, asset.png', 'unused.png', 'dynamic/a.png']:
            (root / name).write_bytes(b'asset')
        rows, *_ = inventory(root)
        states = {r['caminho']: r['classificacao'] for r in rows}
        assert states['res://used, asset.png'] == 'Jogo atual'
        assert states['res://unused.png'] == 'Sem referência encontrada'
        assert states['res://dynamic/a.png'] == 'Uso incerto'
        assert next(r for r in rows if r['caminho'] == 'res://material.tres')['cena_no_propriedade']
        ctx = scene_contexts('[ext_resource path="res://tex.png" id=1]\n[sub_resource type="Material" id=2]\ntexture = ExtResource( 1 )\n[node name="Root"]\nmaterial = SubResource( 2 )\n')
        assert ('Root', 'material → texture') in ctx['res://tex.png']
        assert scene_contexts('[node name="Dialog"]\njson_path="res://dialog.json"')['res://dialog.json'] == {('Dialog', 'json_path')}
        finite = resolved_character_paths('const FACE_IDS = ["feliz", "dor"]\nconst FACE_PATH = "res://assets/SpritesV4/Feicoes/%s.png"\n')
        assert finite == [(2, 'res://assets/SpritesV4/Feicoes/feliz.png'), (2, 'res://assets/SpritesV4/Feicoes/dor.png')]
        (root / 'nested').mkdir()
        (root / 'nested/project.godot').write_text('[application]\nrun/main_scene="res://main.tscn"\n')
        (root / 'nested/main.tscn').write_text('[ext_resource path="res://local.png" id=1]\n')
        (root / 'nested/local.png').write_bytes(b'asset')
        rows, *_ = inventory(root)
        assert next(r for r in rows if r['caminho'] == 'res://nested/local.png')['classificacao'] == 'Testes/protótipos'
    print('Self-check OK: dependências indiretas, ciclos, comentários, contexto de nós e caminhos dinâmicos.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--self-check', action='store_true')
    parser.add_argument('--check', action='store_true', help='Verifica entregáveis sem reescrevê-los')
    args = parser.parse_args()
    if args.self_check:
        self_check()
        return
    root = Path(__file__).resolve().parents[1]
    rows, *details = inventory(root)
    report = root / 'docs/tecnico/MAPA_ASSETS_E_SAVE.md'
    csv_path = report.with_name('inventario_assets.csv')
    section = summary(rows, *details)
    current = report.read_text(encoding='utf-8')
    updated = re.sub(r'<!-- BEGIN INVENTARIO GERADO -->.*?<!-- END INVENTARIO GERADO -->', lambda _: section, current, flags=re.S)
    assert updated != current or '<!-- BEGIN INVENTARIO GERADO -->' in current
    if args.check:
        with csv_path.open(encoding='utf-8-sig', newline='') as stream:
            saved = list(csv.DictReader(stream))
        assert saved == [{k: str(v) for k, v in row.items()} for row in rows], 'CSV desatualizado'
        assert updated == current, 'Resumo desatualizado'
        assert all((root / row['caminho'][6:]).is_file() for row in rows)
        print(f'Check OK: {len(rows)} assets, caminhos existentes e totais reproduzíveis.')
    else:
        with csv_path.open('w', encoding='utf-8-sig', newline='') as stream:
            writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
            writer.writeheader()
            writer.writerows(rows)
        report.write_text(updated, encoding='utf-8', newline='\n')
        print(f'Gerados {csv_path.name} e resumo: {len(rows)} assets.')


if __name__ == '__main__':
    main()
