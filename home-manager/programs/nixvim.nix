{...}: {
  programs.nixvim = {
    enable = false;

    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };

    globals = {
      mapleader = " ";
    };

    plugins = {
      # UI
      noice.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      neo-tree.enable = true;
      web-devicons.enable = true;

      # Development
      lsp = {
        enable = true;
        servers.nil_ls.enable = true; # Nix用LSP
      };
      treesitter.enable = true;
      telescope.enable = true;

      # Assistants
      which-key.enable = true;
      gitsigns.enable = true;
      copilot-vim.enable = true;
    };

    colorschemes.dracula = {
      enable = true;
      autoLoad = true;
    };
  };
}
