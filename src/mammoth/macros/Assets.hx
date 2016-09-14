package mammoth.macros;

import Sys;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

using StringTools;

class Assets {
    private static function copy(sourceDir:String, targetDir:String):Int {
        var numCopied:Int = 0;

        if(!FileSystem.exists(targetDir))
            FileSystem.createDirectory(targetDir);

        for(entry in FileSystem.readDirectory(sourceDir)) {
            var srcFile:String = Path.join([sourceDir, entry]);
            var dstFile:String = Path.join([targetDir, entry]);

            if(FileSystem.isDirectory(srcFile))
                numCopied += copy(srcFile, dstFile);
            else {
                File.copy(srcFile, dstFile);
                numCopied++;
            }
        }
        return numCopied;
    }

    // TODO: different for different platforms?
    private static var type:String = "html5";

    public static function copyDefaultAssets() {
        var listings:Array<String> =
            new sys.io.Process("haxelib", ["path", "mammoth"])
            .stdout
            .readAll()
            .toString()
            .replace('\r', '')
            .split('\n');

        // find our directory
        var mammothDir:String = ".";
        for(listing in listings) {
            if(    listing.startsWith("--macro ")
                || listing.startsWith("-D ")
                || listing.startsWith("-lib "))
                continue;
            mammothDir = listing.trim();
            break;
        }

        // get our absolute folder locations
        var assetSrcFolder = Path.join([mammothDir, "assets"]);
        var assetsDstFolder = Path.join([Sys.getCwd(), type, "assets"]);

        // make sure the assets folder exists
        if(!FileSystem.exists(assetsDstFolder))
            FileSystem.createDirectory(assetsDstFolder);

        // copy it!
        var numCopied = copy(assetSrcFolder, assetsDstFolder);
        Sys.print('[mammoth] copied ${numCopied} default assets to build!');
    }

    public static function copyProjectAssets() {
        var cwd:String = Sys.getCwd();
        var assetSrcFolder = Path.join([cwd, "..", "src", "assets"]);
        var assetsDstFolder = Path.join([cwd, type, "assets"]);

        // make sure the assets folder exists
        if(!FileSystem.exists(assetsDstFolder))
            FileSystem.createDirectory(assetsDstFolder);

        // copy it!
        var numCopied = copy(assetSrcFolder, assetsDstFolder);
        Sys.print('[mammoth] copied ${numCopied} project assets to build!');
    }
}