package src.graphics.shader;

class ShaderProgramCache{
    var programCache : Map<String, Shader>;
    var gd : GraphicsDevice;

    public function new(gd : GraphicsDevice){
        this.gd = gd;
        programCache = new Map<String, Shader>();
    }

    public function getProgram(vert : String, frag : String) : Shader{
        var key = vert + "/" + frag;
        if(!programCache.exists(key)){
            programCache.set(key, link(vert, frag));
        }
        return programCache[key];
    }

    function link(vert : String, frag : String) : Shader{
        var v = haxe.Http.requestUrl("shader/" + vert + ".vert");
        var f = haxe.Http.requestUrl("shader/" + frag + ".frag");
        return new Shader(v, f);
    }
}
