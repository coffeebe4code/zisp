const Token = @import("token").Token;
const Span = @import("span").Span;

pub const AstTag = enum {
    Atom,
    Func,
    Number,
    Data,
    List,
};

pub const Ast = union(AstTag) {
    BinOp: struct { *Ast, Span, *Ast },
    UnOp: struct { *Ast, Span },
    Ident: Span,
    Num: Span,
};

//pub fn make_binop(left: *Ast, op: Span, right: *Ast) Ast {
//    return Ast{
//        .BinOp = .{ left, op, right },
//    };
//}
//
//pub fn make_unop(expr: *Ast, op: Span) Ast {
//    return Ast{
//        .UnOp = .{ expr, op },
//    };
//}
//
//pub fn make_ident(span: *Span) Ast {
//    return Ast{
//        .Ident = span,
//    };
//}
//
//pub fn make_num(span: Span) Ast {
//    return Ast{
//        .Num = span,
//    };
//}
