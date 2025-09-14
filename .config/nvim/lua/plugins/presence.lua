return {
  "vyfor/cord.nvim",
  build = "pnpm install", -- or npm/yarn/bun install depending on your package manager
  config = function()
    require("cord").setup({
      
      client_id = "1233042620165787728", -- Default cord.nvim application ID

      -- Presence settings
      auto_update = true, -- Automatically update presence
      update_interval = 15000, -- Update interval in milliseconds (15 seconds)
      show_problems = true, -- Show LSP problems count
      show_workspace = true, -- Show workspace name
      show_cursor_position = true, -- Show cursor position (line number)

      -- Blacklist certain filetypes or buftypes
      blacklist = {
        filetypes = {
          "neo-tree", -- Add neo-tree to blacklist so it doesn't show when browsing files
          "TelescopePrompt",
          "packer",
          "",
        },
        buftypes = {
          "nofile",
          "prompt",
          "help"
        }
      },

      -- Logging
      log_level = "warn", 

      -- Debouncing (prevents rapid updates)
      debounce_time = 10000, -- 10 seconds

      -- Neovim image
      neovim_image = "neovim", -- The image key for Neovim
      neovim_image_text = "Neovim", -- The text shown when hovering over the Neovim image

      -- Workspace detection
      workspace = function()
        local cwd = vim.fn.getcwd()
        local project_name = vim.fn.fnamemodify(cwd, ":t")
        return project_name
      end
    })

    -- Optional: Manual control commands
    vim.keymap.set("n", "<leader>dce", "<cmd>CordEnable<cr>", { desc = "Enable Discord RPC" })
    vim.keymap.set("n", "<leader>dcd", "<cmd>CordDisable<cr>", { desc = "Disable Discord RPC" })
    vim.keymap.set("n", "<leader>dct", "<cmd>CordToggle<cr>", { desc = "Toggle Discord RPC" })
    vim.keymap.set("n", "<leader>dcs", "<cmd>CordStatus<cr>", { desc = "Show Discord RPC status" })
  end
}