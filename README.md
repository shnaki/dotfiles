# dotfiles

個人用 dotfiles 管理リポジトリです。

## セットアップ

### 1. リポジトリを配置

任意の場所に clone します。

```bash
git clone https://github.com/shnaki/dotfiles.git
cd dotfiles
```

### 2. インストールシェルを実行

`install.sh` は以下を実行します。

- `dot` コマンドを `~/.dot` に clone
- `dotlink` に基づいて各種 dotfiles を配置
- `etc/init_zed.sh` を呼び出して Zed 設定を反映

実行コマンド:

```bash
bash ./install.sh
```

## Windows 向け補助

Windows では `etc/mklink.bat` でリンクを作成します（コピーは行いません）。

- ファイル: ハードリンク優先（失敗時はシンボリックリンク）
- ディレクトリ: ジャンクション優先（失敗時はシンボリックリンク）

```bat
etc\mklink.bat
```

一度リンクを作成すれば、`git pull` で dotfiles 側が更新されたときに実体も自動で最新版になります。

## Zed 設定の管理

このリポジトリでは以下を管理します。

- `.config/zed/settings.json`
- `.config/zed/keymap.json`

反映先:

- `AppData/Roaming/Zed/settings.json`
- `AppData/Roaming/Zed/keymap.json`

手動反映:

```bash
bash ./etc/init_zed.sh
```

`init_zed.sh` はリンクのみ作成します（copy はしません）。

## 更新手順

1. リポジトリ内の対象ファイルを編集
2. 必要に応じて `bash ./etc/init_zed.sh` で反映
3. `git add` / `git commit` で変更を管理
