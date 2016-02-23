package om.haxe;

using Lambda;
using StringTools;

class Hxml {

    //public static function stripComments( str : String ) : String {

    public static function hasToken( str : String, token : String ) : Bool {
        var expr = ~/ +/g;
        for( line in str.split( '\n' ) ) {
            if( (line = stripLine( line )).length == 0 )
                continue;
            if( expr.split( line ).has( token ) )
                return true;
        }
        return false;
    }

    public static function parseTokens( str : String ) : Array<String> {
        var parts = new Array<String>();
        var expr = ~/ +/g;
        for( line in str.split( '\n' ) ) {
            if( (line = stripLine( line )).length == 0 )
                continue;
            parts = parts.concat( expr.split( line ) );
        }
        return parts;
    }

    public static function parseDefines( str : String ) : Array<String> {
        var tokens = parseTokens( str );
        var defines = new Array<String>();
        var i = 0;
        for( token in tokens )
            if( token == '-D' ) defines.push( tokens[++i] ) else i++;
        return defines;
    }

    public static function parseDefine( str : String ) : { key : String, value : String } {
        var expr = ~/\-D\s*([a-zA-Z0-9_]+)(=([a-zA-Z0-9_]+))*$/;
        if( expr.match( str ) ) {
            return {
                key: expr.matched(1),
                value: expr.matched(3)
            }
        }
        return null;
    }

    public static function stripLine( str : String ) : String {
        str = str.trim();
        var i = str.indexOf( '#' );
        return (i != -1) ? str.substring( 0, i-1 ) : str;
    }

}
