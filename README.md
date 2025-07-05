```
~/.config/nvim/
├── init.lua          -- File khởi động chính, chỉ gọi các module khác
└── lua/
    └── user/
        ├── core/
        │   ├── options.lua -- Các tùy chỉnh `vim.opt` cơ bản
        │   └── keymaps.lua -- Các phím tắt toàn cục
        └── plugins/
            ├── config.lua      -- File setup chính của lazy.nvim
            └── list/           -- Thư mục chứa các file cấu hình plugin
                ├── 1_ui.lua    -- Các plugin về giao diện (theme, cây thư mục)
                ├── 2_core.lua  -- Các plugin chức năng cốt lõi (LSP, format, tìm kiếm)
                └── 3_utils.lua -- Các plugin tiện ích khác (git, treesitter)
```

