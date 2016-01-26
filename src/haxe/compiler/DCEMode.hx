package haxe.compiler;

@:enum abstract DCEMode(String) from String to String {
    var std = 'std';
    var full = 'full';
    var no = 'no';
}
