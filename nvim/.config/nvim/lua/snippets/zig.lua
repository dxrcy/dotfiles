local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

--- Reuse text from node.
local function recall_node(index)
    return ls.function_node(function(args)
        return args[1][1]
    end, { index }, {})
end

ls.add_snippets("all", {
    ls.snippet("importstd", {
        ls.text_node([[const std = @import("std");]]),
    }),

    ls.snippet("importfile",
        fmt([[const {} = @import("{}.zig");]], {
            recall_node(1),
            ls.insert_node(1),
        })
    ),

    ls.snippet("importchild",
        fmt([[const {} = {}.{};]], {
            recall_node(2),
            ls.insert_node(1),
            ls.insert_node(2),
        })
    ),

    ls.snippet("debugprint",
        fmt([[std.debug.print("{}", .{{{}}});]], {
            ls.insert_node(2),
            ls.insert_node(1),
        })
    ),

    ls.snippet("debugallocator", {
        ls.text_node({
            [[var gpa = std.heap.DebugAllocator(.{}){};]],
            [[defer _ = gpa.deinit();]],
            [[const allocator = gpa.allocator();]],
        }),
    }),
})
