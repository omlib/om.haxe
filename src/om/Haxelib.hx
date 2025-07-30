package om;

#if sys
import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

using StringTools;
#end

typedef Description = {
	name:String,
	version:String,
	description:String,
	url:String,
	tags:Array<String>,
	license:String,
	classPath:String,
	main:String,
	releasenote:String,
	contributors:Array<String>,
	dependencies:Dynamic,
	documentation:{defines:String, metadata:String}
}

/**
	Tools to gather information on haxelib libraries.
**/
class Haxelib {
	public static inline var ENV_VAR = 'HAXELIB_PATH';
	public static inline var FILE_DESCRIPTION = 'haxelib.json';
	public static inline var FILE_CURRENT = '.current';
	public static inline var FILE_DEV = '.dev';

	#if sys
	/**
		Haxelib path (defined by HAXELIB_PATH).
	**/
	public static var path(default, null) = Sys.getEnv(ENV_VAR);

	/**
		Returns the library path (without checking existence).
	**/
	public static inline function getPath(lib:String):String {
		return Path.join([path, lib.replace('.', ',')]);
	}

	/**
		Checks if the given library is installed.
	**/
	public static inline function isInstalled(lib:String):Bool {
		final p = getPath(lib);
		return FileSystem.exists(p) && FileSystem.isDirectory(p);
	}

	/**
		Returns the library path, also checks if exists in file system.

		If active is set true the full path to active library is returned.
		If the library is in **dev** mode the path to development directory is returned.
	**/
	public static function resolvePath(lib:String, active = false):String {
		var p = getPath(lib);
		if (active) {
			final a = getActiveVersion(lib);
			p = a == "dev" ? File.getContent(Path.join([p, FILE_DEV])).trim() : Path.join([p, a]);
		}
		return FileSystem.exists(p) ? p : null;
	}

	/**
		Returns available library versions.
	**/
	public static function getVersions(lib:String):Array<String> {
		var p = getPath(lib);
		if (!FileSystem.exists(p) || !FileSystem.isDirectory(p))
			return [];
		return FileSystem.readDirectory(p).filter(e -> {
			final ep = Path.join([p, e]);
			return FileSystem.isDirectory(ep) && switch e {
				case FILE_DEV, FILE_CURRENT: false;
				default: true;
			}}).map(v -> v.replace(",", "."));
	}

	/**
		Returns the active version of the library.
	**/
	public static function getActiveVersion(lib:String):String {
		var p = getPath(lib);
		if (FileSystem.exists(Path.join([p, FILE_DEV])))
			return "dev";
		final cur = Path.join([p, FILE_CURRENT]);
		if (FileSystem.exists(cur))
			return File.getContent(cur).trim();
		return null;
	}

	/**
		Returns the json of the description of the libray.
	**/
	public static inline function getDescription(lib:String):Description {
		var p = resolvePath(lib, true);
		return p == null ? null : Json.parse(File.getContent(Path.join([p, FILE_DESCRIPTION])));
	}
	#end
}
