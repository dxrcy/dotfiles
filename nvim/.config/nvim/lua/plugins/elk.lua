return {
    "twhlynch/elk.nvim",

    opts = {
        binary = "elk",
        debounce = 50,
        filetypes = { "asm", "lc3" },
        level = "info",
        permit = {},
        trap_aliases = {
            getc   = 0x20,
            out    = 0x21,
            puts   = 0x22,
            ["in"] = 0x23,
            putsp  = 0x24,
            halt   = 0x25,
            putn   = 0x26,
            reg    = 0x27,
            chat   = 0x28,
            getp   = 0x29,
            setp   = 0x2a,
            getb   = 0x2b,
            setb   = 0x2c,
            geth   = 0x2d,
        }
    },
}
