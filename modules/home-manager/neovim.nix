{ config, pkgs, ... }:

{

    programs.neovim =
    let
        toLua = str: "lua << EOF\n${str}\nEOF\n";
        toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
    {
        enable = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraPackages = with pkgs;
        [
          lua-language-server
          xclip
          wl-clipboard
          ripgrep
          tree-sitter
          fd
        ];

        plugins = with pkgs.vimPlugins;
        [
            cmp-zsh
            cmp-git
            telescope-fzf-native-nvim
            cmp_luasnip
            cmp-nvim-lsp
            luasnip
            friendly-snippets
            lualine-nvim
            nvim-web-devicons
            vim-nix
            neodev-nvim

            {
                plugin = nvim-lspconfig;
                config = toLuaFile ./nvim/plugin/lsp.lua;
            }

            {
                plugin = telescope-nvim;
                config = toLuaFile ./nvim/plugin/telescope.lua;
            }

            {
                plugin = (nvim-treesitter.withPlugins (p: [
                p.tree-sitter-nix
                p.tree-sitter-vim
                p.tree-sitter-bash
                p.tree-sitter-lua
                p.tree-sitter-python
                p.tree-sitter-json
            ]));

            config = toLuaFile ./nvim/plugin/treesitter.lua;

            }


        ];
    };
}
