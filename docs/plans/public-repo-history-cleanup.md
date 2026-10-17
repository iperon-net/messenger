# Чистка публичной истории репозитория `iperon-net/messenger`

Статус: план, не начато. Дата: 2026-10-17.

## Зачем

Репозиторий приложения должен оставаться **публичным** — для внешних проверок
безопасности. При этом в нём с первого коммита лежат `CLAUDE.md` (16.08) и
`docs/plans/` (с 5.09) — внутренние заметки и планы, которые посторонним видеть
не нужно. Плюс в 9 коммитах строка `Co-Authored-By: Claude Opus 4.8 …`.

Сделать приватным нельзя (нужен публичный для проверок), поэтому — переписать
историю без этих файлов и выложить её **в новый репозиторий**.

## Что выяснили (2026-10-17)

- `iperon-net/messenger` — public, 616 коммитов (608 без merge), 392 тега,
  звёзд/форков 0. Contributors — только `kostyaten`.
- Сервер `iperon-net/iperon` — private, его не трогаем.
- Явных секретов в истории нет (искали токены Grafana `glsa_`, ключи Google
  `AIza…`, приватные ключи PEM, `ROBOKASSA_*`). `.mcp.json` дважды попадал в
  коммиты, но только со ссылкой `${GRAFANA_SERVICE_ACCOUNT_TOKEN}`, без значения.
- **Почему просто переписать `main` нельзя:** `refs/pull/*` удалить или
  переписать нельзя, а страницы PR остаются публичными с вкладками Commits /
  Files changed (полный дифф). В них есть:

  | PR | `CLAUDE.md` | `docs/plans/` |
  |---|---|---|
  | #2, #3 (август) | есть | — |
  | #4 (WebRTC) | есть | 3 файла |
  | #5–#10 (Chats, Folders, Communities) | есть | 13 файлов |
  | #11 (dependabot, открыт) | есть | 13 файлов |

  Убрать их может только поддержка GitHub по заявке («Removing sensitive
  data»), долго и без гарантий. Новый репозиторий решает это: PR в нём нет.
- 19 коммитов меняли **только** `CLAUDE.md` / `docs/plans/` — после чистки
  станут пустыми.

## Решения до начала

- [ ] Пустые коммиты (19 шт.): **выкинуть** (по умолчанию в filter-repo,
      рекомендуется) или оставить пустыми ради описаний (`--prune-empty never`).
- [ ] Что ещё убрать из истории и добавить в `.gitignore` (сейчас:
      `CLAUDE.md`, `docs/plans/`). `docs/well-known/apple-app-site-association`
      **оставляем** — это публичный файл Universal Links.
- [ ] Убрать строки `Co-Authored-By:` из описаний коммитов — да.

## Шаги

### 1. Бэкап (локально)

```bash
git clone --mirror git@github.com:iperon-net/messenger.git ~/backup/messenger-$(date +%F).git
```

Плюс убедиться, что локально лежат актуальные `CLAUDE.md` и `docs/plans/`
(после чистки они останутся только на диске и в архивном репозитории).

### 2. Переписать историю (в отдельном клоне, не в рабочей папке)

```bash
brew install git-filter-repo
git clone git@github.com:iperon-net/messenger.git /tmp/messenger-clean
cd /tmp/messenger-clean
git filter-repo \
  --invert-paths --path CLAUDE.md --path docs/plans/ \
  --message-callback 'import re; return re.sub(rb"\n?Co-Authored-By:[^\n]*", b"", message)'
```

Проверить результат:

```bash
git log --all --format= --name-only | grep -E '^(CLAUDE\.md|docs/plans/)'   # должно быть пусто
git log --all --format=%B | grep -i co-authored-by                           # пусто
git rev-list --count HEAD                                                    # ~597 (616 − 19 пустых)
git tag | wc -l                                                              # 392
```

### 3. Архивировать старый репозиторий (GitHub, руками)

Settings → General:
- переименовать `messenger` → `messenger-archive`;
- Change visibility → **Private**;
- (по желанию) Archive this repository.

PR #1–#11 и полная история остаются там, доступ только у нас.

### 4. Новый публичный репозиторий

- Создать `iperon-net/messenger`, **public**, пустой (без README/лицензии).
- Залить переписанную историю:

  ```bash
  cd /tmp/messenger-clean
  git remote add origin git@github.com:iperon-net/messenger.git
  git push origin --all
  git push origin --tags
  ```

- Создание нового репозитория с тем же именем отменяет редирект GitHub со
  старого адреса на `messenger-archive` — так и нужно.

### 5. Перенести настройки (GitHub, руками)

Secrets → Actions (значения взять из исходников/менеджера паролей — из
старого репозитория их не прочитать):

- `ASC_ISSUER_ID`, `ASC_KEY_ID`, `ASC_KEY_P8_BASE64`
- `ENV_FILE_BASE64`, `FIREBASE_OPTIONS_DART_BASE64`
- `IOS_DIST_CERT_P12_BASE64`, `IOS_DIST_CERT_PASSWORD`
- `IOS_GOOGLE_SERVICE_INFO_PLIST_BASE64`
- `IOS_PROVISIONING_PROFILE_BASE64`, `IOS_NSE_PROVISIONING_PROFILE_BASE64`

Ещё:
- Actions включены; dependabot (`.github/dependabot.yml` переедет сам,
  проверить, что он запустился); Issues включены (были), Wiki/Pages — нет.
- Правила защиты `main`, если были.
- Подключить заново сервис проверки безопасности.
- Ссылки `iperon-net/messenger/.github/workflows/...@main` в
  `build_and_deploy.yaml` / `testing.yaml` и проверка
  `github.repository == 'iperon-net/messenger'` в `dependabot.yaml` остаются
  рабочими — имя то же.

### 6. Рабочая папка

У рабочей копии старая история — её больше не пушить. Либо склонировать новый
репозиторий заново и перенести неотслеживаемые файлы (`.env*`,
`firebase_options.dart`, `CLAUDE.md`, `CLAUDE.local.md`, `docs/plans/`,
`.mcp.json`), либо:

```bash
git fetch origin && git reset --hard origin/main   # после push нового репо
```

(Перед этим закоммитить/сохранить всё незакоммиченное — `reset --hard` его
сотрёт.) Добавить `CLAUDE.md` и `docs/plans/` в `.gitignore` и закоммитить.

### 7. Проверка

- [ ] В новом репозитории на GitHub нет `CLAUDE.md` и `docs/plans/` ни в
      дереве, ни в поиске по коду.
- [ ] Вкладка Pull requests пустая.
- [ ] `testing.yaml` проходит на push в `main`.
- [ ] Тег `v*` собирает и выгружает в TestFlight (секреты на месте),
      changelog для «What to Test» строится (теги перенесены).

## Что важно помнить

- Хэши всех коммитов и тегов меняются; старые ссылки на коммиты не работают.
- Восстановить удалённые файлы из нового репозитория невозможно (их нет ни в
  одном коммите); нам самим — из `messenger-archive` или локального бэкапа.
- Кто успел склонировать старый публичный репозиторий — у того копия
  останется; это ничем не исправить.
- Дальше в коммиты Claude строку `Co-Authored-By` не добавляет.
