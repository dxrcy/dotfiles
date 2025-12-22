local ls = require("luasnip")

--- Reuse text from node.
local function recall_node(index)
    return ls.function_node(function(args)
        return args[1][1]
    end, { index }, {})
end

ls.add_snippets("all", {
    ls.snippet("debugprint", {
        ls.text_node([[std.debug.print("]]),
        ls.insert_node(1),
        ls.text_node([[\n", .{]]),
        ls.insert_node(2),
        ls.text_node([[});]]),
    }),

    ls.snippet("importstd", {
        ls.text_node([[const std = @import("std");]]),
    }),

    ls.snippet("importchild", {
        ls.text_node([[const ]]),
        ls.insert_node(1),
        ls.text_node([[ = ]]),
        ls.insert_node(2),
        ls.text_node([[.]]),
        recall_node(1),
        ls.text_node([[;]]),
    }),
})
