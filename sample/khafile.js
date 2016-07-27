var project = new Project('mammoth-sample');

project.windowOptions = {
	width : 960,
	height : 540
};

project.addSources('src');

project.addLibrary("mammoth");
project.addLibrary("edge");

//project.addShaders('src/shaders/**');
project.addAssets('assets/**');

/*var libDir = "C:\\Users\\Kenton\\Projects\\mammoth\\";
var shadersDir = libDir + "src\\assets\\shaders";
var shaders = fs.readdirSync(shadersDir);
console.log(shaders);*/

project.addDefine('debug');
project.addDefine('source-map-content');

return project;