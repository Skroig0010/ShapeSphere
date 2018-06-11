package src.parser;

class XLexer{
    public var counter(default, null) : Int;
    var text : String;
    var length : Int;
    var token : XVal;
    var log = new List<XVal>();

    public function showLog(){
        for(tok in log){
            trace(tok);
        }
    }

    public function new(text : String){
        this.text = text;
        length = text.length;
        counter = 0;
        moveNext();
    }

    public function getToken() : XVal{
        return token;
    }

    public function moveNext() : Bool{
        if(log.length > 50){
            log.pop();
        }
        log.add(token);
        while(length > counter){
            switch(text.charAt(counter)){
                case "{" :
                    counter++;
                    token = LBrace;
                    return true;
                case "}" :
                    counter++;
                    token = RBrace;
                    return true;
                case ";" :
                    counter++;
                    token = SemiColon;
                    return true;
                case "," :
                    counter++;
                    token = Comma;
                    return true;
                case "\"" :
                    token = getString();
                    return true;
                case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-" :
                    token = getNumber();
                    return true;
                case " ", "\t", "\n", "\r":
                    counter++;
                    continue;
                    case "/" :
                    if(text.charAt(counter + 1) == "/"){
                        skipComment();
                        continue;
                    }else{
                        throw "what is this / char at " + (counter + 1);
                    }
                default :
                    token = getSymbol();
                    return true;
            }
        }
        token = null;
        return false;
    }

    function getString() : XVal{
        if(text.charAt(counter) != "\""){
            return null;
        }
        var s = "";
        var prevChar = "";
        counter++;
        while(length > counter){
            if(text.charAt(counter) == "\""){
                if(prevChar != "\\")break;
            }
            prevChar = text.charAt(counter);
            s += prevChar;
            counter++;
        }
        if(text.charAt(counter) != "\""){
            return null;
        }
        counter++;
        return StringVal(s);
    }

    function getNumber() : XVal{
        var number = text.charAt(counter);
        var isNegative = false;
        var isFloat = false;
        var reg = ~/[0-9]|\./;

        if(number == "-"){
            isNegative = true;
            number = "";
        }else{ 
            if(!reg.match(number)){
                return null;
            }
        }
        counter++;

        while(length > counter){
            if(!reg.match(text.charAt(counter))){
                break;
            }
            if(text.charAt(counter) == "."){
                isFloat = true;
            }
            number += text.charAt(counter);
            counter++;
        }

        if(isFloat){
            var f = Std.parseFloat(number);
            if(Math.isNaN(f))return null;
            if(isNegative)f = -f;
            return FloatVal(f);
        }else{
            var i = Std.parseInt(number);
            if(i == null)return null;
            if(isNegative)i = -i;
            return IntVal(i);
        }
    }

    function getSymbol() : XVal{
        var symbol = text.charAt(counter);
        counter++;
        while(length > counter){
            switch(text.charAt(counter)){
                case " ", "\t", "\n", "\r", "(", ")", "{", "}":
                    break;
                default :
                    symbol += text.charAt(counter);
                    counter++;
            }
        }
        return Symbol(symbol);
    }

    function skipComment(){
        while(length > counter){
            switch(text.charAt(counter)){
                case "\r", "\n" :
                    break;
            }
            counter++;
        }
    }

}
