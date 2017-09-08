package om.haxe;

private typedef Position = {
    var start : Int;
    var end : Int;
}

/**
    Haxe compiler error message.
*/
class ErrorMessage {

    public static var PATTERN(default,null) = ~/^\s*(.+):([0-9]+):\s*(characters*|lines)\s([0-9]+)(-([0-9]+))?\s:\s(.+)$/i;

    public var path : String;
    public var line : Int;
    public var lines : Position;
    public var character : Null<Int>;
    public var characters : Position;
    public var content : String;

    public inline function new() {}

    public function toString() : String {
        var str = '$path:$line: ';
        if( lines != null )
            str += 'lines ${lines.start}-${lines.end}';
        else if( character != null )
            str += 'character $character';
        else if( characters != null )
            str += 'characters ${characters.start}-${characters.end}';
        str += ' : $content';
        return str;
    }

    public function toObject() {
        return {
            path: path,
            line: line,
            lines: lines,
            character: character,
            characters: characters,
            content: content
        };
    }

    public static function parse( str : String ) : ErrorMessage {
        if( PATTERN.match( str ) ) {
            var e = new ErrorMessage();
            e.path = PATTERN.matched(1);
            e.line = Std.parseInt( PATTERN.matched(2) );
            var posType = PATTERN.matched(3);
            //trace(posType);
            switch posType {
            case 'character':
                e.character = Std.parseInt( PATTERN.matched(4) );
                e.content = PATTERN.matched(7);
            case 'characters':
                e.characters = {
                    start: Std.parseInt(PATTERN.matched(4)),
                    end: Std.parseInt(PATTERN.matched(6))
                };
                e.content = PATTERN.matched(7);
            case 'lines':
                e.lines = {
                    start: Std.parseInt(PATTERN.matched(4)),
                    end: Std.parseInt(PATTERN.matched(6))
                };
                e.content = PATTERN.matched(7);
            }
            return e;
        }
        return null;
    }
}
