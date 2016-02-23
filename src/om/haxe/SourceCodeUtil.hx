package om.haxe;

class SourceCodeUtil {

    public static var ENDS_WITH_DOT_IDENTIFIER(default,null) = ~/\.([a-zA-Z_0-9]*)$/;
    public static var ENDS_WITH_DOT_NUMBER(default,null) = ~/[^a-zA-Z0-9_\]\)]([\.0-9]+)$/;
    public static var ENDS_WITH_PARTIAL_PACKAGE_DECL(default,null) = ~/[^a-zA-Z0-9_]package\s+([a-zA-Z_0-9]+(\.[a-zA-Z_0-9]+)*)\.([a-zA-Z_0-9]*)$/;
    //static var REGEX_ENDS_WITH_DOT_NUMBER = ~/^.*\.[0-9]*$/;
    //static var REGEX_BEGINS_WITH_KEY = ~/^([a-zA-Z0-9_]+)\s*:/;
    public static var ENDS_WITH_ALPHANUMERIC(default,null) = ~/([A-Za-z0-9_]+)$/;
    public static var PACKAGE(default,null) = ~/^package\s*([a-zA-Z0-9_]*(\.[a-zA-Z0-9_]+)*)/;

    public static function extractPackage( code : String ) : String {
        //TODO
        if( !PACKAGE.match( code ) )
            return null;
        return PACKAGE.matched(1);
    }

    public static function replacePackage( code : String, newPackageName : String ) : String {
        //TODO
        code = PACKAGE.map( code, function(reg){
            return newPackageName;
        });
        return code;
    }
}
