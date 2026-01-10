local ls = require("luasnip")
local snippet = ls.snippet
local insert = ls.insert_node
local text = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

--- Reuse text from node.
local function recall(index)
    return ls.function_node(function(args)
        return args[1][1]
    end, { index }, {})
end

ls.add_snippets("all", {
    snippet("importstd", {
        text([[const std = @import("std");]]),
    }),

    snippet("importfile",
        fmt([[const {} = @import("{}{}.zig"){};]], {
            insert(1),
            insert(2),
            recall(1),
            insert(3),
        })
    ),

    snippet("importchild",
        fmt([[const {} = {}.{};]], {
            insert(1),
            insert(2),
            recall(1),
        })
    ),

    snippet("debugprint",
        fmt([[std.debug.print("{}", .{{{}}});]], {
            insert(1),
            insert(2),
        })
    ),

    snippet("debugallocator", {
        text({
            [[var gpa = std.heap.DebugAllocator(.{}){};]],
            [[defer _ = gpa.deinit();]],
            [[const allocator = gpa.allocator();]],
        }),
    }),

    snippet("selfthis", {
        text([[const Self = @This();]]),
        text([[]]),
    }),

    snippet("logscoped",
        fmt([[const log = std.log.scoped(.{});]], {
            insert(1),
        })
    ),
})
