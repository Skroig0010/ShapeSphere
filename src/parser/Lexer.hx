package src.parser;

class Lexer<T>{
    var tokenTypeList : List<TokenType<T>>;
    var text : String = "";
    var offset : Int = 0;
    public function new(tokenTypeList : List<TokenType<T>>, text : String){
        this.tokenTypeList = tokenTypeList;
    }
    
    function skipWhiteSpace(text : String){
        var first = text.charAt(0);
        // " \t\n"は飛ばす
        while(first == " " ||
                first == "\n" ||
                first == "\t"){
            text = text.substr(1);
            first = text.charAt(0);
        }
        return text;
    }

    function skipComment(text : String){
        var first = text.charAt(0);
        if(first == "/"){
            if(text.charAt(1) == "/"){
                // 行末までカット
                while(first != "\n"){
                    text = text.substr(1);
                    first = text.charAt(0);
                }
                text.substr(1);
            }else if(text.charAt(1) == "*"){
                // */までカット
                var second = text.charAt(1);
                while(!(first == "*" && second == "/")){
                    text = text.substr(1);
                    first = text.charAt(0);
                    second = text.charAt(1);
                }
                text = text.substr(2);
            }
        }
        return text;
    }

    public function nextToken(){
        if(text == "")return null;
        var word = "";
        var token = new Token<T>(null, offset, 0, "");

        // 空白文字、コメントは飛ばす
        var length = text.length;
        do{
            text = skipComment(text);
            text = skipWhiteSpace(text);
        }while(text.length != length);

        for(i in 0 ... length){
            var isMatched = false;
            var isMatchedWithNextChar = false;
            var nextChar = text.charAt(0);
            for(tokenType in tokenTypeList){
                // 一つでもマッチしたら保留
                if(tokenType.regExp.match(word)){
                    isMatched = true;
                    if(tokenType.regExp.match(word + nextChar)){
                    // マッチする文字がまだあるなら続ける
                        isMatchedWithNextChar = true;
                    }else{
                    // 次の文字を読むとマッチしないならば終わり
                        token.kind = tokenType.kind;
                        token.offsetEnd = offset + i;
                        token.lexeme = word;
                    }
                }
            }
            if(isMatched && !isMatchedWithNextChar)break;
            text = text.substr(1);
            word += nextChar;
        }
        offset = token.offsetEnd;
        return token;
    }

}
