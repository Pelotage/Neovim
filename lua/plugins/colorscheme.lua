-- Theme/Colorscheme (uncomment section for whichever theme you prefer or use your own)
-- Kanagawa Theme (Custom Palette - More Vibrant Text)
return {
  'rebelot/kanagawa.nvim',
  lazy = false,    -- Load immediately when Neovim starts
  priority = 1000, -- Load before other plugins to ensure colorscheme is set first
  opts = {
    -- Use the "wave" variant for dark backgrounds
    background = {
      dark = "wave",
    },
    colors = {
      palette = {
        -- BACKGROUND COLORS (darkest to lightest)
        -- These control the main editor background and UI elements
        deepestBackground = "#161616",    -- Original: sumiInk0 - deepest background
        primaryBackground = "#181818",    -- Original: sumiInk1 - main editor background
        secondaryBackground = "#1a1a1a",  -- Original: sumiInk2 - secondary backgrounds
        tertiary_background = "#1F1F1F",  -- Original: sumiInk3 - tertiary backgrounds
        lightBackground = "#2A2A2A",      -- Original: sumiInk4 - lighter background areas
        lighterBackground = "#363636",    -- Original: sumiInk5 - even lighter backgrounds
        lightestBackground = "#545454",   -- Original: sumiInk6 - lightest background
        
        -- POPUP AND FLOAT WINDOW BACKGROUNDS
        floatWindowBackground = "#322C47", -- Original: waveBlue1 - popup/float backgrounds
        floatWindowBorder = "#4c4464",     -- Original: waveBlue2 - popup borders
        
        -- GIT DIFF BACKGROUNDS
        gitAddedBackground = "#2B3328",    -- Original: winterGreen - git added lines
        gitChangedBackground = "#49443C",  -- Original: winterYellow - git changed lines
        gitRemovedBackground = "#43242B",  -- Original: winterRed - git removed lines
        gitInfoBackground = "#252535",     -- Original: winterBlue - git info
        
        -- GIT DIFF FOREGROUND COLORS
        gitAddedForeground = "#76A56A",    -- Original: autumnGreen - vibrant green
        gitRemovedForeground = "#C34043",  -- Original: autumnRed - error red
        gitChangedForeground = "#DCA561",  -- Original: autumnYellow - warning yellow
        
        -- DIAGNOSTIC COLORS
        errorColor = "#E82424",            -- Original: samuraiRed - errors
        warningColor = "#FF9E3B",          -- Original: roninYellow - warnings
        infoColor = "#7E9CD8",             -- Original: waveAqua1 - information
        hintColor = "#7FB4CA",             -- Original: dragonBlue - hints
        
        -- TEXT COLORS (enhanced for visibility)
        primaryText = "#E8E5D4",           -- Original: oldWhite - main text (brightened)
        brightWhiteText = "#FFFBF0",       -- Original: fujiWhite - bright white (enhanced)
        commentText = "#8B8B8B",           -- Original: fujiGray - comments (brightened)
        
        -- SYNTAX HIGHLIGHTING COLORS (more vibrant)
        keywordColor = "#C7A8FF",          -- Original: oniViolet - keywords (brightened)
        functionColor = "#D3C1FF",         -- Original: oniViolet2 - functions (brightened)
        typeColor = "#9BC6FF",             -- Original: crystalBlue - types (brightened)
        variableColor = "#A599C7",         -- Original: springViolet1 - variables
        parameterColor = "#ABC8E8",        -- Original: springViolet2 - parameters
        stringColor = "#8FD4FF",           -- Original: springBlue - strings (brightened)
        numberColor = "#88CCFF",           -- Original: waveAqua2 - numbers (brightened)
        commentColor = "#A8DD6C",          -- Original: springGreen - enhanced comments
        
        -- SPECIAL SYNTAX COLORS
        constantColor = "#B3996E",         -- Original: boatYellow1 - constants
        operatorColor = "#D8BA83",         -- Original: boatYellow2 - operators
        escapeSequenceColor = "#FFFF66",   -- Original: carpYellow - escape sequences (much brighter)
        tagColor = "#FF99B8",              -- Original: sakuraPink - HTML/XML tags (brightened)
        attributeColor = "#FF7A8C",        -- Original: waveRed - attributes (brightened)
        delimiterColor = "#FF6B70",        -- Original: peachRed - delimiters (brighter)
        specialCharColor = "#FFB855",      -- Original: surimiOrange - special characters (brighter)
        inactiveColor = "#8A9999",         -- Original: katanaGray - inactive/disabled elements
      },
    },
  },
  config = function(_, opts)
    require('kanagawa').setup(opts)
    vim.cmd("colorscheme kanagawa")
    
    -- CUSTOM DIFF COLORS (high contrast for Git diffs)
    -- These override the default diff colors with more vibrant versions
    vim.cmd([[
      autocmd VimEnter * hi DiffAdd guifg=#00FF00 guibg=#005500    " Added lines: bright green on dark green
      autocmd VimEnter * hi DiffDelete guifg=#FF0000 guibg=#550000  " Deleted lines: bright red on dark red
      autocmd VimEnter * hi DiffChange guifg=#CCCCCC guibg=#555555  " Changed lines: light gray on dark gray
      autocmd VimEnter * hi DiffText guifg=#00FF00 guibg=#005500    " Changed text: bright green on dark green
    ]])
    
    -- FLOATING WINDOW STYLING 
    -- Ensures popups, LSP windows, and completion menus have consistent styling 
    vim.cmd([[
      autocmd ColorScheme * hi NormalFloat guifg=#F9E7C0 guibg=#1F1F1F  " Float window text and background
      autocmd ColorScheme * hi FloatBorder guifg=#F9E7C0 guibg=#1F1F1F  " Float window borders
    ]])
  end
}




-- Kanagawa Theme (Original)
--[[ return {
   -- https://github.com/rebelot/kanagawa.nvim
   'rebelot/kanagawa.nvim', -- You can replace this with your favorite colorscheme
   lazy = false, -- We want the colorscheme to load immediately when starting Neovim
   priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
   opts = {
     -- Replace this with your scheme-specific settings or remove to use the defaults
     -- transparent = true,
     background = {
       -- light = "lotus",
       dark = "wave", -- "wave, dragon"
     },
   },
   config = function(_, opts)
     require('kanagawa').setup(opts) -- Replace this with your favorite colorscheme
     vim.cmd("colorscheme kanagawa-wave") -- Replace this with your favorite colorscheme
   end
 } ]]--
