const Token = @import("token").Token;
const TokenError = @import("token").TokenError;
const Lexer = @import("lexer").Lexer;
const Ast = @import("ast").Ast;
const ast = @import("ast");
const Span = @import("span").Span;
const AstTag = @import("ast").AstTag;
const Allocator = @import("std").mem.Allocator;
const std = @import("std");
const ArrayList = @import("std").ArrayList;
const testing = @import("std").testing;

const stdout = std.io.getStdOut().writer();

const ParserError = error{
    InvalidExpectedToken,
    ExpectedOneOfFound,
};

const Parser = struct {
    lexer: Lexer,
    asts: ArrayList(Ast),
    allocator: Allocator,

    pub fn init(lexer: Lexer, allocator: Allocator) anyerror!Parser {
        const asts: ArrayList(Ast) = std.ArrayList(Ast).init(allocator);
        return Parser{
            .lexer = lexer,
            .asts = asts,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Parser) void {
        self.asts.deinit();
        for (0..self.envs.items.len) |i| {
            i.deinit();
        }
        self.envs.deinit();
    }

    pub fn parse_sexpr(self: *Parser) anyerror!?usize {
        const atom = try self.parse_atom();
        if (atom) |a| {
            return a;
        }
        const oparen = try self.lexer.collect_if(Token.OParen);
        _ = try expect_span(oparen, "expected one of '('");

        var env: ArrayList(*Ast) = std.ArrayList(*Ast).init(self.allocator);
        while (true) {
            const m_cparen = try self.lexer.collect_if(Token.CParen);
            if (m_cparen) |_| {
                break;
            }
            const m_expr = try self.parse_sexpr();
            const expr = try expect_ast(m_expr, "expected s-expression");

            try env.append(expr);
        }
        const local = ast.make_list(&env.items, self.envs.items.len - 1);
        try self.envs.append(env);
        try self.asts.append(local);
        return self.get_last();
    }

    pub fn parse_atom(self: *Parser) anyerror!?usize {
        const span = try self.lexer.collect_if_of(&[2]Token{
            Token.Num,
            Token.Symbol,
        });
        if (span) |capture| {
            const local = ast.make_atom(capture);
            try self.asts.append(local);
            return self.get_current_index();
        }
        return null;
    }
    fn get_current(self: Parser) *Ast {
        return &self.asts.items[self.asts.items.len - 1];
    }
    fn get_current_index(self: Parser) usize {
        return self.asts.items.len - 1;
    }
    pub fn get_ast_by_index(self: Parser, idx: usize) *Ast {
        return &self.asts.items[idx];
    }
};

fn expect_span(expr: ?Span, message: []const u8) anyerror!Span {
    return expr orelse {
        try stdout.print("{s}\n", .{message});
        return ParserError.ExpectedOneOfFound;
    };
}

fn expect_ast(expr: anyerror!?*Ast, message: []const u8) anyerror!*Ast {
    return expr catch {
        try stdout.print("{s}\n", .{message});
        return ParserError.ExpectedOneOfFound;
    } orelse {
        try stdout.print("{s}\n", .{message});
        return ParserError.ExpectedOneOfFound;
    };
}

test "parse s-expr" {
    const buf = "(5 5)";
    const lex = Lexer.new(buf, .{ .skip = true });
    var parser = try Parser.init(lex, std.testing.allocator);

    defer parser.deinit();
    const result = try parser.parse_sexpr();
    const left = result.?.*.List.val.*[0].*.Atom;
    const right = result.?.*.List.val.*[1].*.Atom;

    try testing.expect(std.mem.eql(u8, left.slice, buf[1..2]));
    try testing.expect(left.token == Token.Num);
    try testing.expect(std.mem.eql(u8, right.slice, buf[3..4]));
    try testing.expect(right.token == Token.Num);
}

test "parse atom" {
    const buf = "5";
    const lex = Lexer.new(buf, .{});
    var parser = try Parser.init(lex, std.testing.allocator);
    defer parser.deinit();
    const result = try parser.parse_atom();

    try testing.expect(result.?.*.Atom.token == Token.Num);
}
