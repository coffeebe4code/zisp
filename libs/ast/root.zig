const Token = @import("token").Token;
const Span = @import("span").Span;

pub const AstTag = enum {
    Atom,
    List,
};

pub const Ast = union(AstTag) {
    Atom: Span,
    List: struct { val: *[]const *Ast, parent: usize },
};

pub fn make_list(val: [*]Ast, parent: [*]usize) Ast {
    return Ast{
        .List = .{
            .val = val,
            .parent = parent,
        },
    };
}

pub fn make_atom(span: Span) Ast {
    return Ast{
        .Atom = span,
    };
}
