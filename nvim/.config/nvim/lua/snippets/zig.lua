local ls = require("luasnip")

ls.add_snippets("all", {
    ls.snippet("debugprint", {
        ls.text_node([[std.debug.print("]]),
        ls.insert_node(1),
        ls.text_node([[\n", .{]]),
        ls.insert_node(2),
        ls.text_node([[});]]),
    }),
})
