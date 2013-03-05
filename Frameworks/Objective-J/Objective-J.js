var ObjectiveJ={};
(function(_1,_2){
if(!this.JSON){
JSON={};
}
(function(){
function f(n){
return n<10?"0"+n:n;
};
if(typeof Date.prototype.toJSON!=="function"){
Date.prototype.toJSON=function(_3){
return this.getUTCFullYear()+"-"+f(this.getUTCMonth()+1)+"-"+f(this.getUTCDate())+"T"+f(this.getUTCHours())+":"+f(this.getUTCMinutes())+":"+f(this.getUTCSeconds())+"Z";
};
String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(_4){
return this.valueOf();
};
}
var cx=new RegExp("[\\u0000\\u00ad\\u0600-\\u0604\\u070f\\u17b4\\u17b5\\u200c-\\u200f\\u2028-\\u202f\\u2060-\\u206f\\ufeff\\ufff0-\\uffff]","g");
var _5=new RegExp("[\\\\\\\"\\x00-\\x1f\\x7f-\\x9f\\u00ad\\u0600-\\u0604\\u070f\\u17b4\\u17b5\\u200c-\\u200f\\u2028-\\u202f\\u2060-\\u206f\\ufeff\\ufff0-\\uffff]","g");
var _6,_7,_8={"\b":"\\b","\t":"\\t","\n":"\\n","\f":"\\f","\r":"\\r","\"":"\\\"","\\":"\\\\"},_9;
function _a(_b){
_5.lastIndex=0;
return _5.test(_b)?"\""+_b.replace(_5,function(a){
var c=_8[a];
return typeof c==="string"?c:"\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4);
})+"\"":"\""+_b+"\"";
};
function _c(_d,_e){
var i,k,v,_f,_10=_6,_11,_12=_e[_d];
if(_12&&typeof _12==="object"&&typeof _12.toJSON==="function"){
_12=_12.toJSON(_d);
}
if(typeof _9==="function"){
_12=_9.call(_e,_d,_12);
}
switch(typeof _12){
case "string":
return _a(_12);
case "number":
return isFinite(_12)?String(_12):"null";
case "boolean":
case "null":
return String(_12);
case "object":
if(!_12){
return "null";
}
_6+=_7;
_11=[];
if(Object.prototype.toString.apply(_12)==="[object Array]"){
_f=_12.length;
for(i=0;i<_f;i+=1){
_11[i]=_c(i,_12)||"null";
}
v=_11.length===0?"[]":_6?"[\n"+_6+_11.join(",\n"+_6)+"\n"+_10+"]":"["+_11.join(",")+"]";
_6=_10;
return v;
}
if(_9&&typeof _9==="object"){
_f=_9.length;
for(i=0;i<_f;i+=1){
k=_9[i];
if(typeof k==="string"){
v=_c(k,_12);
if(v){
_11.push(_a(k)+(_6?": ":":")+v);
}
}
}
}else{
for(k in _12){
if(Object.hasOwnProperty.call(_12,k)){
v=_c(k,_12);
if(v){
_11.push(_a(k)+(_6?": ":":")+v);
}
}
}
}
v=_11.length===0?"{}":_6?"{\n"+_6+_11.join(",\n"+_6)+"\n"+_10+"}":"{"+_11.join(",")+"}";
_6=_10;
return v;
}
};
if(typeof JSON.stringify!=="function"){
JSON.stringify=function(_13,_14,_15){
var i;
_6="";
_7="";
if(typeof _15==="number"){
for(i=0;i<_15;i+=1){
_7+=" ";
}
}else{
if(typeof _15==="string"){
_7=_15;
}
}
_9=_14;
if(_14&&typeof _14!=="function"&&(typeof _14!=="object"||typeof _14.length!=="number")){
throw new Error("JSON.stringify");
}
return _c("",{"":_13});
};
}
if(typeof JSON.parse!=="function"){
JSON.parse=function(_16,_17){
var j;
function _18(_19,key){
var k,v,_1a=_19[key];
if(_1a&&typeof _1a==="object"){
for(k in _1a){
if(Object.hasOwnProperty.call(_1a,k)){
v=_18(_1a,k);
if(v!==_29){
_1a[k]=v;
}else{
delete _1a[k];
}
}
}
}
return _17.call(_19,key,_1a);
};
cx.lastIndex=0;
if(cx.test(_16)){
_16=_16.replace(cx,function(a){
return "\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4);
});
}
if(/^[\],:{}\s]*$/.test(_16.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]").replace(/(?:^|:|,)(?:\s*\[)+/g,""))){
j=eval("("+_16+")");
return typeof _17==="function"?_18({"":j},""):j;
}
throw new SyntaxError("JSON.parse");
};
}
}());
var _1b=new RegExp("([^%]+|%(?:\\d+\\$)?[\\+\\-\\ \\#0]*[0-9\\*]*(.[0-9\\*]+)?[hlL]?[cbBdieEfgGosuxXpn%@])","g");
var _1c=new RegExp("(%)(?:(\\d+)\\$)?([\\+\\-\\ \\#0]*)([0-9\\*]*)((?:.[0-9\\*]+)?)([hlL]?)([cbBdieEfgGosuxXpn%@])");
_2.sprintf=function(_1d){
var _1d=arguments[0],_1e=_1d.match(_1b),_1f=0,_20="",arg=1;
for(var i=0;i<_1e.length;i++){
var t=_1e[i];
if(_1d.substring(_1f,_1f+t.length)!=t){
return _20;
}
_1f+=t.length;
if(t.charAt(0)!=="%"){
_20+=t;
}else{
if(t==="%%"){
_20+="%";
}else{
var _21=t.match(_1c);
if(_21.length!=8||_21[0]!=t){
return _20;
}
var _22=_21[1],_23=_21[2],_24=_21[3],_25=_21[4],_26=_21[5],_27=_21[6],_28=_21[7];
if(_23===_29||_23===null||_23===""){
_23=arg++;
}else{
_23=Number(_23);
}
var _2a=null;
if(_25=="*"){
_2a=arguments[_23];
}else{
if(_25!=""){
_2a=Number(_25);
}
}
var _2b=null;
if(_26==".*"){
_2b=arguments[_23];
}else{
if(_26!=""){
_2b=Number(_26.substring(1));
}
}
var _2c=(_24.indexOf("-")>=0);
var _2d=(_24.indexOf("0")>=0);
var _2e="";
if(RegExp("[bBdiufeExXo]").test(_28)){
var num=Number(arguments[_23]);
var _2f="";
if(num<0){
_2f="-";
}else{
if(_24.indexOf("+")>=0){
_2f="+";
}else{
if(_24.indexOf(" ")>=0){
_2f=" ";
}
}
}
if(_28=="d"||_28=="i"||_28=="u"){
var _30=String(Math.abs(Math.floor(num)));
_2e=_31(_2f,"",_30,"",_2a,_2c,_2d);
}
if(_28=="f"){
var _30=String((_2b!=null)?Math.abs(num).toFixed(_2b):Math.abs(num));
var _32=(_24.indexOf("#")>=0&&_30.indexOf(".")<0)?".":"";
_2e=_31(_2f,"",_30,_32,_2a,_2c,_2d);
}
if(_28=="e"||_28=="E"){
var _30=String(Math.abs(num).toExponential(_2b!=null?_2b:21));
var _32=(_24.indexOf("#")>=0&&_30.indexOf(".")<0)?".":"";
_2e=_31(_2f,"",_30,_32,_2a,_2c,_2d);
}
if(_28=="x"||_28=="X"){
var _30=String(Math.abs(num).toString(16));
var _33=(_24.indexOf("#")>=0&&num!=0)?"0x":"";
_2e=_31(_2f,_33,_30,"",_2a,_2c,_2d);
}
if(_28=="b"||_28=="B"){
var _30=String(Math.abs(num).toString(2));
var _33=(_24.indexOf("#")>=0&&num!=0)?"0b":"";
_2e=_31(_2f,_33,_30,"",_2a,_2c,_2d);
}
if(_28=="o"){
var _30=String(Math.abs(num).toString(8));
var _33=(_24.indexOf("#")>=0&&num!=0)?"0":"";
_2e=_31(_2f,_33,_30,"",_2a,_2c,_2d);
}
if(RegExp("[A-Z]").test(_28)){
_2e=_2e.toUpperCase();
}else{
_2e=_2e.toLowerCase();
}
}else{
var _2e="";
if(_28=="%"){
_2e="%";
}else{
if(_28=="c"){
_2e=String(arguments[_23]).charAt(0);
}else{
if(_28=="s"||_28=="@"){
_2e=String(arguments[_23]);
}else{
if(_28=="p"||_28=="n"){
_2e="";
}
}
}
}
_2e=_31("","",_2e,"",_2a,_2c,false);
}
_20+=_2e;
}
}
}
return _20;
};
function _31(_34,_35,_36,_37,_38,_39,_3a){
var _3b=(_34.length+_35.length+_36.length+_37.length);
if(_39){
return _34+_35+_36+_37+pad(_38-_3b," ");
}else{
if(_3a){
return _34+_35+pad(_38-_3b,"0")+_36+_37;
}else{
return pad(_38-_3b," ")+_34+_35+_36+_37;
}
}
};
function pad(n,ch){
return Array(MAX(0,n)+1).join(ch);
};
CPLogDisable=false;
var _3c="Cappuccino";
var _3d=["fatal","error","warn","info","debug","trace"];
var _3e=_3d[3];
var _3f={};
for(var i=0;i<_3d.length;i++){
_3f[_3d[i]]=i;
}
var _40={};
CPLogRegister=function(_41,_42,_43){
CPLogRegisterRange(_41,_3d[0],_42||_3d[_3d.length-1],_43);
};
CPLogRegisterRange=function(_44,_45,_46,_47){
var min=_3f[_45];
var max=_3f[_46];
if(min!==_29&&max!==_29&&min<=max){
for(var i=min;i<=max;i++){
CPLogRegisterSingle(_44,_3d[i],_47);
}
}
};
CPLogRegisterSingle=function(_48,_49,_4a){
if(!_40[_49]){
_40[_49]=[];
}
for(var i=0;i<_40[_49].length;i++){
if(_40[_49][i][0]===_48){
_40[_49][i][1]=_4a;
return;
}
}
_40[_49].push([_48,_4a]);
};
CPLogUnregister=function(_4b){
for(var _4c in _40){
for(var i=0;i<_40[_4c].length;i++){
if(_40[_4c][i][0]===_4b){
_40[_4c].splice(i--,1);
}
}
}
};
function _4d(_4e,_4f,_50){
if(_50==_29){
_50=_3c;
}
if(_4f==_29){
_4f=_3e;
}
var _51=(typeof _4e[0]=="string"&&_4e.length>1)?_2.sprintf.apply(null,_4e):String(_4e[0]);
if(_40[_4f]){
for(var i=0;i<_40[_4f].length;i++){
var _52=_40[_4f][i];
_52[0](_51,_4f,_50,_52[1]);
}
}
};
CPLog=function(){
_4d(arguments);
};
for(var i=0;i<_3d.length;i++){
CPLog[_3d[i]]=(function(_53){
return function(){
_4d(arguments,_53);
};
})(_3d[i]);
}
var _54=function(_55,_56,_57){
var now=new Date(),_58;
if(_56===null){
_56="";
}else{
_56=_56||"info";
_56="["+CPLogColorize(_56,_56)+"]";
}
_57=_57||"";
if(_57&&_56){
_57+=" ";
}
_58=_57+_56;
if(_58){
_58+=": ";
}
if(typeof _2.sprintf=="function"){
return _2.sprintf("%4d-%02d-%02d %02d:%02d:%02d.%03d %s%s",now.getFullYear(),now.getMonth()+1,now.getDate(),now.getHours(),now.getMinutes(),now.getSeconds(),now.getMilliseconds(),_58,_55);
}else{
return now+" "+_58+": "+_55;
}
};
CPLogConsole=function(_59,_5a,_5b,_5c){
if(typeof console!="undefined"){
var _5d=(_5c||_54)(_59,_5a,_5b),_5e={"fatal":"error","error":"error","warn":"warn","info":"info","debug":"debug","trace":"debug"}[_5a];
if(_5e&&console[_5e]){
console[_5e](_5d);
}else{
if(console.log){
console.log(_5d);
}
}
}
};
CPLogColorize=function(_5f,_60){
return _5f;
};
CPLogAlert=function(_61,_62,_63,_64){
if(typeof alert!="undefined"&&!CPLogDisable){
var _65=(_64||_54)(_61,_62,_63);
CPLogDisable=!confirm(_65+"\n\n(Click cancel to stop log alerts)");
}
};
var _66=null;
CPLogPopup=function(_67,_68,_69,_6a){
try{
if(CPLogDisable||window.open==_29){
return;
}
if(!_66||!_66.document){
_66=window.open("","_blank","width=600,height=400,status=no,resizable=yes,scrollbars=yes");
if(!_66){
CPLogDisable=!confirm(_67+"\n\n(Disable pop-up blocking for CPLog window; Click cancel to stop log alerts)");
return;
}
_6b(_66);
}
var _6c=_66.document.createElement("div");
_6c.setAttribute("class",_68||"fatal");
var _6d=(_6a||_54)(_67,_6a?_68:null,_69);
_6c.appendChild(_66.document.createTextNode(_6d));
_66.log.appendChild(_6c);
if(_66.focusEnabled.checked){
_66.focus();
}
if(_66.blockEnabled.checked){
_66.blockEnabled.checked=_66.confirm(_6d+"\nContinue blocking?");
}
if(_66.scrollEnabled.checked){
_66.scrollToBottom();
}
}
catch(e){
}
};
var _6e="<style type=\"text/css\" media=\"screen\"> body{font:10px Monaco,Courier,\"Courier New\",monospace,mono;padding-top:15px;} div > .fatal,div > .error,div > .warn,div > .info,div > .debug,div > .trace{display:none;overflow:hidden;white-space:pre;padding:0px 5px 0px 5px;margin-top:2px;-moz-border-radius:5px;-webkit-border-radius:5px;} div[wrap=\"yes\"] > div{white-space:normal;} .fatal{background-color:#ffb2b3;} .error{background-color:#ffe2b2;} .warn{background-color:#fdffb2;} .info{background-color:#e4ffb2;} .debug{background-color:#a0e5a0;} .trace{background-color:#99b9ff;} .enfatal .fatal,.enerror .error,.enwarn .warn,.eninfo .info,.endebug .debug,.entrace .trace{display:block;} div#header{background-color:rgba(240,240,240,0.82);position:fixed;top:0px;left:0px;width:100%;border-bottom:1px solid rgba(0,0,0,0.33);text-align:center;} ul#enablers{display:inline-block;margin:1px 15px 0 15px;padding:2px 0 2px 0;} ul#enablers li{display:inline;padding:0px 5px 0px 5px;margin-left:4px;-moz-border-radius:5px;-webkit-border-radius:5px;} [enabled=\"no\"]{opacity:0.25;} ul#options{display:inline-block;margin:0 15px 0px 15px;padding:0 0px;} ul#options li{margin:0 0 0 0;padding:0 0 0 0;display:inline;} </style>";
function _6b(_6f){
var doc=_6f.document;
doc.writeln("<html><head><title></title>"+_6e+"</head><body></body></html>");
doc.title=_3c+" Run Log";
var _70=doc.getElementsByTagName("head")[0];
var _71=doc.getElementsByTagName("body")[0];
var _72=window.location.protocol+"//"+window.location.host+window.location.pathname;
_72=_72.substring(0,_72.lastIndexOf("/")+1);
var div=doc.createElement("div");
div.setAttribute("id","header");
_71.appendChild(div);
var ul=doc.createElement("ul");
ul.setAttribute("id","enablers");
div.appendChild(ul);
for(var i=0;i<_3d.length;i++){
var li=doc.createElement("li");
li.setAttribute("id","en"+_3d[i]);
li.setAttribute("class",_3d[i]);
li.setAttribute("onclick","toggle(this);");
li.setAttribute("enabled","yes");
li.appendChild(doc.createTextNode(_3d[i]));
ul.appendChild(li);
}
var ul=doc.createElement("ul");
ul.setAttribute("id","options");
div.appendChild(ul);
var _73={"focus":["Focus",false],"block":["Block",false],"wrap":["Wrap",false],"scroll":["Scroll",true],"close":["Close",true]};
for(o in _73){
var li=doc.createElement("li");
ul.appendChild(li);
_6f[o+"Enabled"]=doc.createElement("input");
_6f[o+"Enabled"].setAttribute("id",o);
_6f[o+"Enabled"].setAttribute("type","checkbox");
if(_73[o][1]){
_6f[o+"Enabled"].setAttribute("checked","checked");
}
li.appendChild(_6f[o+"Enabled"]);
var _74=doc.createElement("label");
_74.setAttribute("for",o);
_74.appendChild(doc.createTextNode(_73[o][0]));
li.appendChild(_74);
}
_6f.log=doc.createElement("div");
_6f.log.setAttribute("class","enerror endebug enwarn eninfo enfatal entrace");
_71.appendChild(_6f.log);
_6f.toggle=function(_75){
var _76=(_75.getAttribute("enabled")=="yes")?"no":"yes";
_75.setAttribute("enabled",_76);
if(_76=="yes"){
_6f.log.className+=" "+_75.id;
}else{
_6f.log.className=_6f.log.className.replace(new RegExp("[\\s]*"+_75.id,"g"),"");
}
};
_6f.scrollToBottom=function(){
_6f.scrollTo(0,_71.offsetHeight);
};
_6f.wrapEnabled.addEventListener("click",function(){
_6f.log.setAttribute("wrap",_6f.wrapEnabled.checked?"yes":"no");
},false);
_6f.addEventListener("keydown",function(e){
var e=e||_6f.event;
if(e.keyCode==75&&(e.ctrlKey||e.metaKey)){
while(_6f.log.firstChild){
_6f.log.removeChild(_6f.log.firstChild);
}
e.preventDefault();
}
},"false");
window.addEventListener("unload",function(){
if(_6f&&_6f.closeEnabled&&_6f.closeEnabled.checked){
CPLogDisable=true;
_6f.close();
}
},false);
_6f.addEventListener("unload",function(){
if(!CPLogDisable){
CPLogDisable=!confirm("Click cancel to stop logging");
}
},false);
};
CPLogDefault=(typeof window==="object"&&window.console)?CPLogConsole:CPLogPopup;
var _29;
if(typeof window!=="undefined"){
window.setNativeTimeout=window.setTimeout;
window.clearNativeTimeout=window.clearTimeout;
window.setNativeInterval=window.setInterval;
window.clearNativeInterval=window.clearInterval;
}
NO=false;
YES=true;
nil=null;
Nil=null;
NULL=null;
ABS=Math.abs;
ASIN=Math.asin;
ACOS=Math.acos;
ATAN=Math.atan;
ATAN2=Math.atan2;
SIN=Math.sin;
COS=Math.cos;
TAN=Math.tan;
EXP=Math.exp;
POW=Math.pow;
CEIL=Math.ceil;
FLOOR=Math.floor;
ROUND=Math.round;
MIN=Math.min;
MAX=Math.max;
RAND=Math.random;
SQRT=Math.sqrt;
E=Math.E;
LN2=Math.LN2;
LN10=Math.LN10;
LOG=Math.log;
LOG2E=Math.LOG2E;
LOG10E=Math.LOG10E;
PI=Math.PI;
PI2=Math.PI*2;
PI_2=Math.PI/2;
SQRT1_2=Math.SQRT1_2;
SQRT2=Math.SQRT2;
function _77(_78){
this._eventListenersForEventNames={};
this._owner=_78;
};
_77.prototype.addEventListener=function(_79,_7a){
var _7b=this._eventListenersForEventNames;
if(!_7c.call(_7b,_79)){
var _7d=[];
_7b[_79]=_7d;
}else{
var _7d=_7b[_79];
}
var _7e=_7d.length;
while(_7e--){
if(_7d[_7e]===_7a){
return;
}
}
_7d.push(_7a);
};
_77.prototype.removeEventListener=function(_7f,_80){
var _81=this._eventListenersForEventNames;
if(!_7c.call(_81,_7f)){
return;
}
var _82=_81[_7f],_83=_82.length;
while(_83--){
if(_82[_83]===_80){
return _82.splice(_83,1);
}
}
};
_77.prototype.dispatchEvent=function(_84){
var _85=_84.type,_86=this._eventListenersForEventNames;
if(_7c.call(_86,_85)){
var _87=this._eventListenersForEventNames[_85],_88=0,_89=_87.length;
for(;_88<_89;++_88){
_87[_88](_84);
}
}
var _8a=(this._owner||this)["on"+_85];
if(_8a){
_8a(_84);
}
};
var _8b=0,_8c=null,_8d=[];
function _8e(_8f){
var _90=_8b;
if(_8c===null){
window.setNativeTimeout(function(){
var _91=_8d,_92=0,_93=_8d.length;
++_8b;
_8c=null;
_8d=[];
for(;_92<_93;++_92){
_91[_92]();
}
},0);
}
return function(){
var _94=arguments;
if(_8b>_90){
_8f.apply(this,_94);
}else{
_8d.push(function(){
_8f.apply(this,_94);
});
}
};
};
var _95=null;
if(window.ActiveXObject!==_29){
var _96=["Msxml2.XMLHTTP.3.0","Msxml2.XMLHTTP.6.0"],_97=_96.length;
while(_97--){
try{
var _98=_96[_97];
new ActiveXObject(_98);
_95=function(){
return new ActiveXObject(_98);
};
break;
}
catch(anException){
}
}
}
if(!_95){
_95=window.XMLHttpRequest;
}
CFHTTPRequest=function(){
this._isOpen=false;
this._requestHeaders={};
this._mimeType=null;
this._eventDispatcher=new _77(this);
this._nativeRequest=new _95();
var _99=this;
this._stateChangeHandler=function(){
_ac(_99);
};
this._nativeRequest.onreadystatechange=this._stateChangeHandler;
if(CFHTTPRequest.AuthenticationDelegate!==nil){
this._eventDispatcher.addEventListener("HTTP403",function(){
CFHTTPRequest.AuthenticationDelegate(_99);
});
}
};
CFHTTPRequest.UninitializedState=0;
CFHTTPRequest.LoadingState=1;
CFHTTPRequest.LoadedState=2;
CFHTTPRequest.InteractiveState=3;
CFHTTPRequest.CompleteState=4;
CFHTTPRequest.AuthenticationDelegate=nil;
CFHTTPRequest.prototype.status=function(){
try{
return this._nativeRequest.status||0;
}
catch(anException){
return 0;
}
};
CFHTTPRequest.prototype.statusText=function(){
try{
return this._nativeRequest.statusText||"";
}
catch(anException){
return "";
}
};
CFHTTPRequest.prototype.readyState=function(){
return this._nativeRequest.readyState;
};
CFHTTPRequest.prototype.success=function(){
var _9a=this.status();
if(_9a>=200&&_9a<300){
return YES;
}
return _9a===0&&this.responseText()&&this.responseText().length;
};
CFHTTPRequest.prototype.responseXML=function(){
var _9b=this._nativeRequest.responseXML;
if(_9b&&(_95===window.XMLHttpRequest)){
return _9b;
}
return _9c(this.responseText());
};
CFHTTPRequest.prototype.responsePropertyList=function(){
var _9d=this.responseText();
if(CFPropertyList.sniffedFormatOfString(_9d)===CFPropertyList.FormatXML_v1_0){
return CFPropertyList.propertyListFromXML(this.responseXML());
}
return CFPropertyList.propertyListFromString(_9d);
};
CFHTTPRequest.prototype.responseText=function(){
return this._nativeRequest.responseText;
};
CFHTTPRequest.prototype.setRequestHeader=function(_9e,_9f){
this._requestHeaders[_9e]=_9f;
};
CFHTTPRequest.prototype.getResponseHeader=function(_a0){
return this._nativeRequest.getResponseHeader(_a0);
};
CFHTTPRequest.prototype.getAllResponseHeaders=function(){
return this._nativeRequest.getAllResponseHeaders();
};
CFHTTPRequest.prototype.overrideMimeType=function(_a1){
this._mimeType=_a1;
};
CFHTTPRequest.prototype.open=function(_a2,_a3,_a4,_a5,_a6){
this._isOpen=true;
this._URL=_a3;
this._async=_a4;
this._method=_a2;
this._user=_a5;
this._password=_a6;
return this._nativeRequest.open(_a2,_a3,_a4,_a5,_a6);
};
CFHTTPRequest.prototype.send=function(_a7){
if(!this._isOpen){
delete this._nativeRequest.onreadystatechange;
this._nativeRequest.open(this._method,this._URL,this._async,this._user,this._password);
this._nativeRequest.onreadystatechange=this._stateChangeHandler;
}
for(var i in this._requestHeaders){
if(this._requestHeaders.hasOwnProperty(i)){
this._nativeRequest.setRequestHeader(i,this._requestHeaders[i]);
}
}
if(this._mimeType&&"overrideMimeType" in this._nativeRequest){
this._nativeRequest.overrideMimeType(this._mimeType);
}
this._isOpen=false;
try{
return this._nativeRequest.send(_a7);
}
catch(anException){
this._eventDispatcher.dispatchEvent({type:"failure",request:this});
}
};
CFHTTPRequest.prototype.abort=function(){
this._isOpen=false;
return this._nativeRequest.abort();
};
CFHTTPRequest.prototype.addEventListener=function(_a8,_a9){
this._eventDispatcher.addEventListener(_a8,_a9);
};
CFHTTPRequest.prototype.removeEventListener=function(_aa,_ab){
this._eventDispatcher.removeEventListener(_aa,_ab);
};
function _ac(_ad){
var _ae=_ad._eventDispatcher;
_ae.dispatchEvent({type:"readystatechange",request:_ad});
var _af=_ad._nativeRequest,_b0=["uninitialized","loading","loaded","interactive","complete"];
if(_b0[_ad.readyState()]==="complete"){
var _b1="HTTP"+_ad.status();
_ae.dispatchEvent({type:_b1,request:_ad});
var _b2=_ad.success()?"success":"failure";
_ae.dispatchEvent({type:_b2,request:_ad});
_ae.dispatchEvent({type:_b0[_ad.readyState()],request:_ad});
}else{
_ae.dispatchEvent({type:_b0[_ad.readyState()],request:_ad});
}
};
function _b3(_b4,_b5,_b6){
var _b7=new CFHTTPRequest();
if(_b4.pathExtension()==="plist"){
_b7.overrideMimeType("text/xml");
}
if(_2.asyncLoader){
_b7.onsuccess=_8e(_b5);
_b7.onfailure=_8e(_b6);
}else{
_b7.onsuccess=_b5;
_b7.onfailure=_b6;
}
_b7.open("GET",_b4.absoluteString(),_2.asyncLoader);
_b7.send("");
};
_2.asyncLoader=YES;
_2.Asynchronous=_8e;
_2.determineAndDispatchHTTPRequestEvents=_ac;
var _b8=0;
objj_generateObjectUID=function(){
return _b8++;
};
CFPropertyList=function(){
this._UID=objj_generateObjectUID();
};
CFPropertyList.DTDRE=/^\s*(?:<\?\s*xml\s+version\s*=\s*\"1.0\"[^>]*\?>\s*)?(?:<\!DOCTYPE[^>]*>\s*)?/i;
CFPropertyList.XMLRE=/^\s*(?:<\?\s*xml\s+version\s*=\s*\"1.0\"[^>]*\?>\s*)?(?:<\!DOCTYPE[^>]*>\s*)?<\s*plist[^>]*\>/i;
CFPropertyList.FormatXMLDTD="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">";
CFPropertyList.Format280NorthMagicNumber="280NPLIST";
CFPropertyList.FormatOpenStep=1,CFPropertyList.FormatXML_v1_0=100,CFPropertyList.FormatBinary_v1_0=200,CFPropertyList.Format280North_v1_0=-1000;
CFPropertyList.sniffedFormatOfString=function(_b9){
if(_b9.match(CFPropertyList.XMLRE)){
return CFPropertyList.FormatXML_v1_0;
}
if(_b9.substr(0,CFPropertyList.Format280NorthMagicNumber.length)===CFPropertyList.Format280NorthMagicNumber){
return CFPropertyList.Format280North_v1_0;
}
return NULL;
};
CFPropertyList.dataFromPropertyList=function(_ba,_bb){
var _bc=new CFMutableData();
_bc.setRawString(CFPropertyList.stringFromPropertyList(_ba,_bb));
return _bc;
};
CFPropertyList.stringFromPropertyList=function(_bd,_be){
if(!_be){
_be=CFPropertyList.Format280North_v1_0;
}
var _bf=_c0[_be];
return _bf["start"]()+_c1(_bd,_bf)+_bf["finish"]();
};
function _c1(_c2,_c3){
var _c4=typeof _c2,_c5=_c2.valueOf(),_c6=typeof _c5;
if(_c4!==_c6){
_c4=_c6;
_c2=_c5;
}
if(_c2===YES||_c2===NO){
_c4="boolean";
}else{
if(_c4==="number"){
if(FLOOR(_c2)===_c2&&(""+_c2).indexOf("e")==-1){
_c4="integer";
}else{
_c4="real";
}
}else{
if(_c4!=="string"){
if(_c2.slice){
_c4="array";
}else{
_c4="dictionary";
}
}
}
}
return _c3[_c4](_c2,_c3);
};
var _c0={};
_c0[CFPropertyList.FormatXML_v1_0]={"start":function(){
return CFPropertyList.FormatXMLDTD+"<plist version = \"1.0\">";
},"finish":function(){
return "</plist>";
},"string":function(_c7){
return "<string>"+_c8(_c7)+"</string>";
},"boolean":function(_c9){
return _c9?"<true/>":"<false/>";
},"integer":function(_ca){
return "<integer>"+_ca+"</integer>";
},"real":function(_cb){
return "<real>"+_cb+"</real>";
},"array":function(_cc,_cd){
var _ce=0,_cf=_cc.length,_d0="<array>";
for(;_ce<_cf;++_ce){
_d0+=_c1(_cc[_ce],_cd);
}
return _d0+"</array>";
},"dictionary":function(_d1,_d2){
var _d3=_d1._keys,_97=0,_d4=_d3.length,_d5="<dict>";
for(;_97<_d4;++_97){
var key=_d3[_97];
_d5+="<key>"+key+"</key>";
_d5+=_c1(_d1.valueForKey(key),_d2);
}
return _d5+"</dict>";
}};
var _d6="A",_d7="D",_d8="f",_d9="d",_da="S",_db="T",_dc="F",_dd="K",_de="E";
_c0[CFPropertyList.Format280North_v1_0]={"start":function(){
return CFPropertyList.Format280NorthMagicNumber+";1.0;";
},"finish":function(){
return "";
},"string":function(_df){
return _da+";"+_df.length+";"+_df;
},"boolean":function(_e0){
return (_e0?_db:_dc)+";";
},"integer":function(_e1){
var _e2=""+_e1;
return _d9+";"+_e2.length+";"+_e2;
},"real":function(_e3){
var _e4=""+_e3;
return _d8+";"+_e4.length+";"+_e4;
},"array":function(_e5,_e6){
var _e7=0,_e8=_e5.length,_e9=_d6+";";
for(;_e7<_e8;++_e7){
_e9+=_c1(_e5[_e7],_e6);
}
return _e9+_de+";";
},"dictionary":function(_ea,_eb){
var _ec=_ea._keys,_97=0,_ed=_ec.length,_ee=_d7+";";
for(;_97<_ed;++_97){
var key=_ec[_97];
_ee+=_dd+";"+key.length+";"+key;
_ee+=_c1(_ea.valueForKey(key),_eb);
}
return _ee+_de+";";
}};
var _ef="xml",_f0="#document",_f1="plist",_f2="key",_f3="dict",_f4="array",_f5="string",_f6="date",_f7="true",_f8="false",_f9="real",_fa="integer",_fb="data";
var _fc=function(_fd){
var _fe="",_97=0,_ff=_fd.length;
for(;_97<_ff;++_97){
var node=_fd[_97];
if(node.nodeType===3||node.nodeType===4){
_fe+=node.nodeValue;
}else{
if(node.nodeType!==8){
_fe+=_fc(node.childNodes);
}
}
}
return _fe;
};
var _100=function(_101,_102,_103){
var node=_101;
node=(node.firstChild);
if(node!==NULL&&((node.nodeType)===8||(node.nodeType)===3)){
while((node=(node.nextSibling))&&((node.nodeType)===8||(node.nodeType)===3)){
}
}
if(node){
return node;
}
if((String(_101.nodeName))===_f4||(String(_101.nodeName))===_f3){
_103.pop();
}else{
if(node===_102){
return NULL;
}
node=_101;
while((node=(node.nextSibling))&&((node.nodeType)===8||(node.nodeType)===3)){
}
if(node){
return node;
}
}
node=_101;
while(node){
var next=node;
while((next=(next.nextSibling))&&((next.nodeType)===8||(next.nodeType)===3)){
}
if(next){
return next;
}
var node=(node.parentNode);
if(_102&&node===_102){
return NULL;
}
_103.pop();
}
return NULL;
};
CFPropertyList.propertyListFromData=function(_104,_105){
return CFPropertyList.propertyListFromString(_104.rawString(),_105);
};
CFPropertyList.propertyListFromString=function(_106,_107){
if(!_107){
_107=CFPropertyList.sniffedFormatOfString(_106);
}
if(_107===CFPropertyList.FormatXML_v1_0){
return CFPropertyList.propertyListFromXML(_106);
}
if(_107===CFPropertyList.Format280North_v1_0){
return _108(_106);
}
return NULL;
};
var _d6="A",_d7="D",_d8="f",_d9="d",_da="S",_db="T",_dc="F",_dd="K",_de="E";
function _108(_109){
var _10a=new _10b(_109),_10c=NULL,key="",_10d=NULL,_10e=NULL,_10f=[],_110=NULL;
while(_10c=_10a.getMarker()){
if(_10c===_de){
_10f.pop();
continue;
}
var _111=_10f.length;
if(_111){
_110=_10f[_111-1];
}
if(_10c===_dd){
key=_10a.getString();
_10c=_10a.getMarker();
}
switch(_10c){
case _d6:
_10d=[];
_10f.push(_10d);
break;
case _d7:
_10d=new CFMutableDictionary();
_10f.push(_10d);
break;
case _d8:
_10d=parseFloat(_10a.getString());
break;
case _d9:
_10d=parseInt(_10a.getString(),10);
break;
case _da:
_10d=_10a.getString();
break;
case _db:
_10d=YES;
break;
case _dc:
_10d=NO;
break;
default:
throw new Error("*** "+_10c+" marker not recognized in Plist.");
}
if(!_10e){
_10e=_10d;
}else{
if(_110){
if(_110.slice){
_110.push(_10d);
}else{
_110.setValueForKey(key,_10d);
}
}
}
}
return _10e;
};
function _c8(_112){
return _112.replace(/&/g,"&amp;").replace(/"/g,"&quot;").replace(/'/g,"&apos;").replace(/</g,"&lt;").replace(/>/g,"&gt;");
};
function _113(_114){
return _114.replace(/&quot;/g,"\"").replace(/&apos;/g,"'").replace(/&lt;/g,"<").replace(/&gt;/g,">").replace(/&amp;/g,"&");
};
function _9c(_115){
if(window.DOMParser){
return (new window.DOMParser().parseFromString(_115,"text/xml").documentElement);
}else{
if(window.ActiveXObject){
XMLNode=new ActiveXObject("Microsoft.XMLDOM");
var _116=_115.match(CFPropertyList.DTDRE);
if(_116){
_115=_115.substr(_116[0].length);
}
XMLNode.loadXML(_115);
return XMLNode;
}
}
return NULL;
};
CFPropertyList.propertyListFromXML=function(_117){
var _118=_117;
if(_117.valueOf&&typeof _117.valueOf()==="string"){
_118=_9c(_117);
}
while(((String(_118.nodeName))===_f0)||((String(_118.nodeName))===_ef)){
_118=(_118.firstChild);
}
if(_118!==NULL&&((_118.nodeType)===8||(_118.nodeType)===3)){
while((_118=(_118.nextSibling))&&((_118.nodeType)===8||(_118.nodeType)===3)){
}
}
if(((_118.nodeType)===10)){
while((_118=(_118.nextSibling))&&((_118.nodeType)===8||(_118.nodeType)===3)){
}
}
if(!((String(_118.nodeName))===_f1)){
return NULL;
}
var key="",_119=NULL,_11a=NULL,_11b=_118,_11c=[],_11d=NULL;
while(_118=_100(_118,_11b,_11c)){
var _11e=_11c.length;
if(_11e){
_11d=_11c[_11e-1];
}
if((String(_118.nodeName))===_f2){
key=(_118.textContent||(_118.textContent!==""&&_fc([_118])));
while((_118=(_118.nextSibling))&&((_118.nodeType)===8||(_118.nodeType)===3)){
}
}
switch(String((String(_118.nodeName)))){
case _f4:
_119=[];
_11c.push(_119);
break;
case _f3:
_119=new CFMutableDictionary();
_11c.push(_119);
break;
case _f9:
_119=parseFloat((_118.textContent||(_118.textContent!==""&&_fc([_118]))));
break;
case _fa:
_119=parseInt((_118.textContent||(_118.textContent!==""&&_fc([_118]))),10);
break;
case _f5:
if((_118.getAttribute("type")==="base64")){
_119=(_118.firstChild)?CFData.decodeBase64ToString((_118.textContent||(_118.textContent!==""&&_fc([_118])))):"";
}else{
_119=_113((_118.firstChild)?(_118.textContent||(_118.textContent!==""&&_fc([_118]))):"");
}
break;
case _f6:
var _11f=Date.parseISO8601((_118.textContent||(_118.textContent!==""&&_fc([_118]))));
_119=isNaN(_11f)?new Date():new Date(_11f);
break;
case _f7:
_119=YES;
break;
case _f8:
_119=NO;
break;
case _fb:
_119=new CFMutableData();
var _120=(_118.firstChild)?CFData.decodeBase64ToArray((_118.textContent||(_118.textContent!==""&&_fc([_118]))),YES):[];
_119.setBytes(_120);
break;
default:
throw new Error("*** "+(String(_118.nodeName))+" tag not recognized in Plist.");
}
if(!_11a){
_11a=_119;
}else{
if(_11d){
if(_11d.slice){
_11d.push(_119);
}else{
_11d.setValueForKey(key,_119);
}
}
}
}
return _11a;
};
kCFPropertyListOpenStepFormat=CFPropertyList.FormatOpenStep;
kCFPropertyListXMLFormat_v1_0=CFPropertyList.FormatXML_v1_0;
kCFPropertyListBinaryFormat_v1_0=CFPropertyList.FormatBinary_v1_0;
kCFPropertyList280NorthFormat_v1_0=CFPropertyList.Format280North_v1_0;
CFPropertyListCreate=function(){
return new CFPropertyList();
};
CFPropertyListCreateFromXMLData=function(data){
return CFPropertyList.propertyListFromData(data,CFPropertyList.FormatXML_v1_0);
};
CFPropertyListCreateXMLData=function(_121){
return CFPropertyList.dataFromPropertyList(_121,CFPropertyList.FormatXML_v1_0);
};
CFPropertyListCreateFrom280NorthData=function(data){
return CFPropertyList.propertyListFromData(data,CFPropertyList.Format280North_v1_0);
};
CFPropertyListCreate280NorthData=function(_122){
return CFPropertyList.dataFromPropertyList(_122,CFPropertyList.Format280North_v1_0);
};
CPPropertyListCreateFromData=function(data,_123){
return CFPropertyList.propertyListFromData(data,_123);
};
CPPropertyListCreateData=function(_124,_125){
return CFPropertyList.dataFromPropertyList(_124,_125);
};
CFDictionary=function(_126){
this._keys=[];
this._count=0;
this._buckets={};
this._UID=objj_generateObjectUID();
};
var _127=Array.prototype.indexOf,_7c=Object.prototype.hasOwnProperty;
CFDictionary.prototype.copy=function(){
return this;
};
CFDictionary.prototype.mutableCopy=function(){
var _128=new CFMutableDictionary(),keys=this._keys,_129=this._count;
_128._keys=keys.slice();
_128._count=_129;
var _12a=0,_12b=this._buckets,_12c=_128._buckets;
for(;_12a<_129;++_12a){
var key=keys[_12a];
_12c[key]=_12b[key];
}
return _128;
};
CFDictionary.prototype.containsKey=function(aKey){
return _7c.apply(this._buckets,[aKey]);
};
CFDictionary.prototype.containsValue=function(_12d){
var keys=this._keys,_12e=this._buckets,_97=0,_12f=keys.length;
for(;_97<_12f;++_97){
if(_12e[keys[_97]]===_12d){
return YES;
}
}
return NO;
};
CFDictionary.prototype.count=function(){
return this._count;
};
CFDictionary.prototype.countOfKey=function(aKey){
return this.containsKey(aKey)?1:0;
};
CFDictionary.prototype.countOfValue=function(_130){
var keys=this._keys,_131=this._buckets,_97=0,_132=keys.length,_133=0;
for(;_97<_132;++_97){
if(_131[keys[_97]]===_130){
++_133;
}
}
return _133;
};
CFDictionary.prototype.keys=function(){
return this._keys.slice();
};
CFDictionary.prototype.valueForKey=function(aKey){
var _134=this._buckets;
if(!_7c.apply(_134,[aKey])){
return nil;
}
return _134[aKey];
};
CFDictionary.prototype.toString=function(){
var _135="{\n",keys=this._keys,_97=0,_136=this._count;
for(;_97<_136;++_97){
var key=keys[_97];
_135+="\t"+key+" = \""+String(this.valueForKey(key)).split("\n").join("\n\t")+"\"\n";
}
return _135+"}";
};
CFMutableDictionary=function(_137){
CFDictionary.apply(this,[]);
};
CFMutableDictionary.prototype=new CFDictionary();
CFMutableDictionary.prototype.copy=function(){
return this.mutableCopy();
};
CFMutableDictionary.prototype.addValueForKey=function(aKey,_138){
if(this.containsKey(aKey)){
return;
}
++this._count;
this._keys.push(aKey);
this._buckets[aKey]=_138;
};
CFMutableDictionary.prototype.removeValueForKey=function(aKey){
var _139=-1;
if(_127){
_139=_127.call(this._keys,aKey);
}else{
var keys=this._keys,_97=0,_13a=keys.length;
for(;_97<_13a;++_97){
if(keys[_97]===aKey){
_139=_97;
break;
}
}
}
if(_139===-1){
return;
}
--this._count;
this._keys.splice(_139,1);
delete this._buckets[aKey];
};
CFMutableDictionary.prototype.removeAllValues=function(){
this._count=0;
this._keys=[];
this._buckets={};
};
CFMutableDictionary.prototype.replaceValueForKey=function(aKey,_13b){
if(!this.containsKey(aKey)){
return;
}
this._buckets[aKey]=_13b;
};
CFMutableDictionary.prototype.setValueForKey=function(aKey,_13c){
if(_13c===nil||_13c===_29){
this.removeValueForKey(aKey);
}else{
if(this.containsKey(aKey)){
this.replaceValueForKey(aKey,_13c);
}else{
this.addValueForKey(aKey,_13c);
}
}
};
CFData=function(){
this._rawString=NULL;
this._propertyList=NULL;
this._propertyListFormat=NULL;
this._JSONObject=NULL;
this._bytes=NULL;
this._base64=NULL;
};
CFData.prototype.propertyList=function(){
if(!this._propertyList){
this._propertyList=CFPropertyList.propertyListFromString(this.rawString());
}
return this._propertyList;
};
CFData.prototype.JSONObject=function(){
if(!this._JSONObject){
try{
this._JSONObject=JSON.parse(this.rawString());
}
catch(anException){
}
}
return this._JSONObject;
};
CFData.prototype.rawString=function(){
if(this._rawString===NULL){
if(this._propertyList){
this._rawString=CFPropertyList.stringFromPropertyList(this._propertyList,this._propertyListFormat);
}else{
if(this._JSONObject){
this._rawString=JSON.stringify(this._JSONObject);
}else{
if(this._bytes){
this._rawString=CFData.bytesToString(this._bytes);
}else{
if(this._base64){
this._rawString=CFData.decodeBase64ToString(this._base64,true);
}else{
throw new Error("Can't convert data to string.");
}
}
}
}
}
return this._rawString;
};
CFData.prototype.bytes=function(){
if(this._bytes===NULL){
var _13d=CFData.stringToBytes(this.rawString());
this.setBytes(_13d);
}
return this._bytes;
};
CFData.prototype.base64=function(){
if(this._base64===NULL){
var _13e;
if(this._bytes){
_13e=CFData.encodeBase64Array(this._bytes);
}else{
_13e=CFData.encodeBase64String(this.rawString());
}
this.setBase64String(_13e);
}
return this._base64;
};
CFMutableData=function(){
CFData.call(this);
};
CFMutableData.prototype=new CFData();
function _13f(_140){
this._rawString=NULL;
this._propertyList=NULL;
this._propertyListFormat=NULL;
this._JSONObject=NULL;
this._bytes=NULL;
this._base64=NULL;
};
CFMutableData.prototype.setPropertyList=function(_141,_142){
_13f(this);
this._propertyList=_141;
this._propertyListFormat=_142;
};
CFMutableData.prototype.setJSONObject=function(_143){
_13f(this);
this._JSONObject=_143;
};
CFMutableData.prototype.setRawString=function(_144){
_13f(this);
this._rawString=_144;
};
CFMutableData.prototype.setBytes=function(_145){
_13f(this);
this._bytes=_145;
};
CFMutableData.prototype.setBase64String=function(_146){
_13f(this);
this._base64=_146;
};
var _147=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/","="],_148=[];
for(var i=0;i<_147.length;i++){
_148[_147[i].charCodeAt(0)]=i;
}
CFData.decodeBase64ToArray=function(_149,_14a){
if(_14a){
_149=_149.replace(/[^A-Za-z0-9\+\/\=]/g,"");
}
var pad=(_149[_149.length-1]=="="?1:0)+(_149[_149.length-2]=="="?1:0),_14b=_149.length,_14c=[];
var i=0;
while(i<_14b){
var bits=(_148[_149.charCodeAt(i++)]<<18)|(_148[_149.charCodeAt(i++)]<<12)|(_148[_149.charCodeAt(i++)]<<6)|(_148[_149.charCodeAt(i++)]);
_14c.push((bits&16711680)>>16);
_14c.push((bits&65280)>>8);
_14c.push(bits&255);
}
if(pad>0){
return _14c.slice(0,-1*pad);
}
return _14c;
};
CFData.encodeBase64Array=function(_14d){
var pad=(3-(_14d.length%3))%3,_14e=_14d.length+pad,_14f=[];
if(pad>0){
_14d.push(0);
}
if(pad>1){
_14d.push(0);
}
var i=0;
while(i<_14e){
var bits=(_14d[i++]<<16)|(_14d[i++]<<8)|(_14d[i++]);
_14f.push(_147[(bits&16515072)>>18]);
_14f.push(_147[(bits&258048)>>12]);
_14f.push(_147[(bits&4032)>>6]);
_14f.push(_147[bits&63]);
}
if(pad>0){
_14f[_14f.length-1]="=";
_14d.pop();
}
if(pad>1){
_14f[_14f.length-2]="=";
_14d.pop();
}
return _14f.join("");
};
CFData.decodeBase64ToString=function(_150,_151){
return CFData.bytesToString(CFData.decodeBase64ToArray(_150,_151));
};
CFData.decodeBase64ToUtf16String=function(_152,_153){
return CFData.bytesToUtf16String(CFData.decodeBase64ToArray(_152,_153));
};
CFData.bytesToString=function(_154){
return String.fromCharCode.apply(NULL,_154);
};
CFData.stringToBytes=function(_155){
var temp=[];
for(var i=0;i<_155.length;i++){
temp.push(_155.charCodeAt(i));
}
return temp;
};
CFData.encodeBase64String=function(_156){
var temp=[];
for(var i=0;i<_156.length;i++){
temp.push(_156.charCodeAt(i));
}
return CFData.encodeBase64Array(temp);
};
CFData.bytesToUtf16String=function(_157){
var temp=[];
for(var i=0;i<_157.length;i+=2){
temp.push(_157[i+1]<<8|_157[i]);
}
return String.fromCharCode.apply(NULL,temp);
};
CFData.encodeBase64Utf16String=function(_158){
var temp=[];
for(var i=0;i<_158.length;i++){
var c=_158.charCodeAt(i);
temp.push(c&255);
temp.push((c&65280)>>8);
}
return CFData.encodeBase64Array(temp);
};
var _159,_15a,_15b=0;
function _15c(){
if(++_15b!==1){
return;
}
_159={};
_15a={};
};
function _15d(){
_15b=MAX(_15b-1,0);
if(_15b!==0){
return;
}
delete _159;
delete _15a;
};
var _15e=new RegExp("^"+"(?:"+"([^:/?#]+):"+")?"+"(?:"+"(//)"+"("+"(?:"+"("+"([^:@]*)"+":?"+"([^:@]*)"+")?"+"@"+")?"+"([^:/?#]*)"+"(?::(\\d*))?"+")"+")?"+"([^?#]*)"+"(?:\\?([^#]*))?"+"(?:#(.*))?");
var _15f=["url","scheme","authorityRoot","authority","userInfo","user","password","domain","portNumber","path","queryString","fragment"];
function _160(aURL){
if(aURL._parts){
return aURL._parts;
}
var _161=aURL.string(),_162=_161.match(/^mhtml:/);
if(_162){
_161=_161.substr("mhtml:".length);
}
if(_15b>0&&_7c.call(_15a,_161)){
aURL._parts=_15a[_161];
return aURL._parts;
}
aURL._parts={};
var _163=aURL._parts,_164=_15e.exec(_161),_97=_164.length;
while(_97--){
_163[_15f[_97]]=_164[_97]||NULL;
}
_163.portNumber=parseInt(_163.portNumber,10);
if(isNaN(_163.portNumber)){
_163.portNumber=-1;
}
_163.pathComponents=[];
if(_163.path){
var _165=_163.path.split("/"),_166=_163.pathComponents,_167=_165.length;
for(_97=0;_97<_167;++_97){
var _168=_165[_97];
if(_168){
_166.push(_168);
}else{
if(_97===0){
_166.push("/");
}
}
}
_163.pathComponents=_166;
}
if(_162){
_163.url="mhtml:"+_163.url;
_163.scheme="mhtml:"+_163.scheme;
}
if(_15b>0){
_15a[_161]=_163;
}
return _163;
};
CFURL=function(aURL,_169){
aURL=aURL||"";
if(aURL instanceof CFURL){
if(!_169){
return new CFURL(aURL.absoluteString());
}
var _16a=aURL.baseURL();
if(_16a){
_169=new CFURL(_16a.absoluteURL(),_169);
}
aURL=aURL.string();
}
if(_15b>0){
var _16b=aURL+" "+(_169&&_169.UID()||"");
if(_7c.call(_159,_16b)){
return _159[_16b];
}
_159[_16b]=this;
}
if(aURL.match(/^data:/)){
var _16c={},_97=_15f.length;
while(_97--){
_16c[_15f[_97]]="";
}
_16c.url=aURL;
_16c.scheme="data";
_16c.pathComponents=[];
this._parts=_16c;
this._standardizedURL=this;
this._absoluteURL=this;
}
this._UID=objj_generateObjectUID();
this._string=aURL;
this._baseURL=_169;
};
CFURL.prototype.UID=function(){
return this._UID;
};
var _16d={};
CFURL.prototype.mappedURL=function(){
return _16d[this.absoluteString()]||this;
};
CFURL.setMappedURLForURL=function(_16e,_16f){
_16d[_16e.absoluteString()]=_16f;
};
CFURL.prototype.schemeAndAuthority=function(){
var _170="",_171=this.scheme();
if(_171){
_170+=_171+":";
}
var _172=this.authority();
if(_172){
_170+="//"+_172;
}
return _170;
};
CFURL.prototype.absoluteString=function(){
if(this._absoluteString===_29){
this._absoluteString=this.absoluteURL().string();
}
return this._absoluteString;
};
CFURL.prototype.toString=function(){
return this.absoluteString();
};
function _173(aURL){
aURL=aURL.standardizedURL();
var _174=aURL.baseURL();
if(!_174){
return aURL;
}
var _175=((aURL)._parts||_160(aURL)),_176,_177=_174.absoluteURL(),_178=((_177)._parts||_160(_177));
if(_175.scheme||_175.authority){
_176=_175;
}else{
_176={};
_176.scheme=_178.scheme;
_176.authority=_178.authority;
_176.userInfo=_178.userInfo;
_176.user=_178.user;
_176.password=_178.password;
_176.domain=_178.domain;
_176.portNumber=_178.portNumber;
_176.queryString=_175.queryString;
_176.fragment=_175.fragment;
var _179=_175.pathComponents;
if(_179.length&&_179[0]==="/"){
_176.path=_175.path;
_176.pathComponents=_179;
}else{
var _17a=_178.pathComponents,_17b=_17a.concat(_179);
if(!_174.hasDirectoryPath()&&_17a.length){
_17b.splice(_17a.length-1,1);
}
if(_179.length&&(_179[0]===".."||_179[0]===".")){
_17c(_17b,YES);
}
_176.pathComponents=_17b;
_176.path=_17d(_17b,_179.length<=0||aURL.hasDirectoryPath());
}
}
var _17e=_17f(_176),_180=new CFURL(_17e);
_180._parts=_176;
_180._standardizedURL=_180;
_180._standardizedString=_17e;
_180._absoluteURL=_180;
_180._absoluteString=_17e;
return _180;
};
function _17d(_181,_182){
var path=_181.join("/");
if(path.length&&path.charAt(0)==="/"){
path=path.substr(1);
}
if(_182){
path+="/";
}
return path;
};
function _17c(_183,_184){
var _185=0,_186=0,_187=_183.length,_188=_184?_183:[],_189=NO;
for(;_185<_187;++_185){
var _18a=_183[_185];
if(_18a===""){
continue;
}
if(_18a==="."){
_189=_186===0;
continue;
}
if(_18a!==".."||_186===0||_188[_186-1]===".."){
_188[_186]=_18a;
_186++;
continue;
}
if(_186>0&&_188[_186-1]!=="/"){
--_186;
}
}
if(_189&&_186===0){
_188[_186++]=".";
}
_188.length=_186;
return _188;
};
function _17f(_18b){
var _18c="",_18d=_18b.scheme;
if(_18d){
_18c+=_18d+":";
}
var _18e=_18b.authority;
if(_18e){
_18c+="//"+_18e;
}
_18c+=_18b.path;
var _18f=_18b.queryString;
if(_18f){
_18c+="?"+_18f;
}
var _190=_18b.fragment;
if(_190){
_18c+="#"+_190;
}
return _18c;
};
CFURL.prototype.absoluteURL=function(){
if(this._absoluteURL===_29){
this._absoluteURL=_173(this);
}
return this._absoluteURL;
};
CFURL.prototype.standardizedURL=function(){
if(this._standardizedURL===_29){
var _191=((this)._parts||_160(this)),_192=_191.pathComponents,_193=_17c(_192,NO);
var _194=_17d(_193,this.hasDirectoryPath());
if(_191.path===_194){
this._standardizedURL=this;
}else{
var _195=_196(_191);
_195.pathComponents=_193;
_195.path=_194;
var _197=new CFURL(_17f(_195),this.baseURL());
_197._parts=_195;
_197._standardizedURL=_197;
this._standardizedURL=_197;
}
}
return this._standardizedURL;
};
function _196(_198){
var _199={},_19a=_15f.length;
while(_19a--){
var _19b=_15f[_19a];
_199[_19b]=_198[_19b];
}
return _199;
};
CFURL.prototype.string=function(){
return this._string;
};
CFURL.prototype.authority=function(){
var _19c=((this)._parts||_160(this)).authority;
if(_19c){
return _19c;
}
var _19d=this.baseURL();
return _19d&&_19d.authority()||"";
};
CFURL.prototype.hasDirectoryPath=function(){
var _19e=this._hasDirectoryPath;
if(_19e===_29){
var path=this.path();
if(!path){
return NO;
}
if(path.charAt(path.length-1)==="/"){
return YES;
}
var _19f=this.lastPathComponent();
_19e=_19f==="."||_19f==="..";
this._hasDirectoryPath=_19e;
}
return _19e;
};
CFURL.prototype.hostName=function(){
return this.authority();
};
CFURL.prototype.fragment=function(){
return ((this)._parts||_160(this)).fragment;
};
CFURL.prototype.lastPathComponent=function(){
if(this._lastPathComponent===_29){
var _1a0=this.pathComponents(),_1a1=_1a0.length;
if(!_1a1){
this._lastPathComponent="";
}else{
this._lastPathComponent=_1a0[_1a1-1];
}
}
return this._lastPathComponent;
};
CFURL.prototype.path=function(){
return ((this)._parts||_160(this)).path;
};
CFURL.prototype.createCopyDeletingLastPathComponent=function(){
var _1a2=((this)._parts||_160(this)),_1a3=_17c(_1a2.pathComponents,NO);
if(_1a3.length>0){
if(_1a3.length>1||_1a3[0]!=="/"){
_1a3.pop();
}
}
var _1a4=_1a3.length===1&&_1a3[0]==="/";
_1a2.pathComponents=_1a3;
_1a2.path=_1a4?"/":_17d(_1a3,NO);
return new CFURL(_17f(_1a2));
};
CFURL.prototype.pathComponents=function(){
return ((this)._parts||_160(this)).pathComponents;
};
CFURL.prototype.pathExtension=function(){
var _1a5=this.lastPathComponent();
if(!_1a5){
return NULL;
}
_1a5=_1a5.replace(/^\.*/,"");
var _1a6=_1a5.lastIndexOf(".");
return _1a6<=0?"":_1a5.substring(_1a6+1);
};
CFURL.prototype.queryString=function(){
return ((this)._parts||_160(this)).queryString;
};
CFURL.prototype.scheme=function(){
var _1a7=this._scheme;
if(_1a7===_29){
_1a7=((this)._parts||_160(this)).scheme;
if(!_1a7){
var _1a8=this.baseURL();
_1a7=_1a8&&_1a8.scheme();
}
this._scheme=_1a7;
}
return _1a7;
};
CFURL.prototype.user=function(){
return ((this)._parts||_160(this)).user;
};
CFURL.prototype.password=function(){
return ((this)._parts||_160(this)).password;
};
CFURL.prototype.portNumber=function(){
return ((this)._parts||_160(this)).portNumber;
};
CFURL.prototype.domain=function(){
return ((this)._parts||_160(this)).domain;
};
CFURL.prototype.baseURL=function(){
return this._baseURL;
};
CFURL.prototype.asDirectoryPathURL=function(){
if(this.hasDirectoryPath()){
return this;
}
var _1a9=this.lastPathComponent();
if(_1a9!=="/"){
_1a9="./"+_1a9;
}
return new CFURL(_1a9+"/",this);
};
function _1aa(aURL){
if(!aURL._resourcePropertiesForKeys){
aURL._resourcePropertiesForKeys=new CFMutableDictionary();
}
return aURL._resourcePropertiesForKeys;
};
CFURL.prototype.resourcePropertyForKey=function(aKey){
return _1aa(this).valueForKey(aKey);
};
CFURL.prototype.setResourcePropertyForKey=function(aKey,_1ab){
_1aa(this).setValueForKey(aKey,_1ab);
};
CFURL.prototype.staticResourceData=function(){
var data=new CFMutableData();
data.setRawString(_1ac.resourceAtURL(this).contents());
return data;
};
function _10b(_1ad){
this._string=_1ad;
var _1ae=_1ad.indexOf(";");
this._magicNumber=_1ad.substr(0,_1ae);
this._location=_1ad.indexOf(";",++_1ae);
this._version=_1ad.substring(_1ae,this._location++);
};
_10b.prototype.magicNumber=function(){
return this._magicNumber;
};
_10b.prototype.version=function(){
return this._version;
};
_10b.prototype.getMarker=function(){
var _1af=this._string,_1b0=this._location;
if(_1b0>=_1af.length){
return null;
}
var next=_1af.indexOf(";",_1b0);
if(next<0){
return null;
}
var _1b1=_1af.substring(_1b0,next);
if(_1b1==="e"){
return null;
}
this._location=next+1;
return _1b1;
};
_10b.prototype.getString=function(){
var _1b2=this._string,_1b3=this._location;
if(_1b3>=_1b2.length){
return null;
}
var next=_1b2.indexOf(";",_1b3);
if(next<0){
return null;
}
var size=parseInt(_1b2.substring(_1b3,next),10),text=_1b2.substr(next+1,size);
this._location=next+1+size;
return text;
};
var _1b4=0,_1b5=1<<0,_1b6=1<<1,_1b7=1<<2,_1b8=1<<3,_1b9=1<<4;
var _1ba={},_1bb={},_1bc=new Date().getTime(),_1bd=0,_1be=0;
CFBundle=function(aURL){
aURL=_1bf(aURL).asDirectoryPathURL();
var _1c0=aURL.absoluteString(),_1c1=_1ba[_1c0];
if(_1c1){
return _1c1;
}
_1ba[_1c0]=this;
this._bundleURL=aURL;
this._resourcesDirectoryURL=new CFURL("Resources/",aURL);
this._staticResource=NULL;
this._isValid=NO;
this._loadStatus=_1b4;
this._loadRequests=[];
this._infoDictionary=new CFDictionary();
this._eventDispatcher=new _77(this);
};
CFBundle.environments=function(){
return ["Browser","ObjJ"];
};
CFBundle.bundleContainingURL=function(aURL){
aURL=new CFURL(".",_1bf(aURL));
var _1c2,_1c3=aURL.absoluteString();
while(!_1c2||_1c2!==_1c3){
var _1c4=_1ba[_1c3];
if(_1c4&&_1c4._isValid){
return _1c4;
}
aURL=new CFURL("..",aURL);
_1c2=_1c3;
_1c3=aURL.absoluteString();
}
return NULL;
};
CFBundle.mainBundle=function(){
return new CFBundle(_1c5);
};
function _1c6(_1c7,_1c8){
if(_1c8){
_1bb[_1c7.name]=_1c8;
}
};
function _1c9(){
_1ba={};
_1bb={};
_1bd=0;
_1be=0;
};
CFBundle.bundleForClass=function(_1ca){
return _1bb[_1ca.name]||CFBundle.mainBundle();
};
CFBundle.prototype.bundleURL=function(){
return this._bundleURL;
};
CFBundle.prototype.resourcesDirectoryURL=function(){
return this._resourcesDirectoryURL;
};
CFBundle.prototype.resourceURL=function(_1cb,_1cc,_1cd){
if(_1cc){
_1cb=_1cb+"."+_1cc;
}
if(_1cd){
_1cb=_1cd+"/"+_1cb;
}
var _1ce=(new CFURL(_1cb,this.resourcesDirectoryURL())).mappedURL();
return _1ce.absoluteURL();
};
CFBundle.prototype.mostEligibleEnvironmentURL=function(){
if(this._mostEligibleEnvironmentURL===_29){
this._mostEligibleEnvironmentURL=new CFURL(this.mostEligibleEnvironment()+".environment/",this.bundleURL());
}
return this._mostEligibleEnvironmentURL;
};
CFBundle.prototype.executableURL=function(){
if(this._executableURL===_29){
var _1cf=this.valueForInfoDictionaryKey("CPBundleExecutable");
if(!_1cf){
this._executableURL=NULL;
}else{
this._executableURL=new CFURL(_1cf,this.mostEligibleEnvironmentURL());
}
}
return this._executableURL;
};
CFBundle.prototype.infoDictionary=function(){
return this._infoDictionary;
};
CFBundle.prototype.valueForInfoDictionaryKey=function(aKey){
return this._infoDictionary.valueForKey(aKey);
};
CFBundle.prototype.hasSpritedImages=function(){
var _1d0=this._infoDictionary.valueForKey("CPBundleEnvironmentsWithImageSprites")||[],_97=_1d0.length,_1d1=this.mostEligibleEnvironment();
while(_97--){
if(_1d0[_97]===_1d1){
return YES;
}
}
return NO;
};
CFBundle.prototype.environments=function(){
return this._infoDictionary.valueForKey("CPBundleEnvironments")||["ObjJ"];
};
CFBundle.prototype.mostEligibleEnvironment=function(_1d2){
_1d2=_1d2||this.environments();
var _1d3=CFBundle.environments(),_97=0,_1d4=_1d3.length,_1d5=_1d2.length;
for(;_97<_1d4;++_97){
var _1d6=0,_1d7=_1d3[_97];
for(;_1d6<_1d5;++_1d6){
if(_1d7===_1d2[_1d6]){
return _1d7;
}
}
}
return NULL;
};
CFBundle.prototype.isLoading=function(){
return this._loadStatus&_1b5;
};
CFBundle.prototype.isLoaded=function(){
return !!(this._loadStatus&_1b9);
};
CFBundle.prototype.load=function(_1d8){
if(this._loadStatus!==_1b4){
return;
}
this._loadStatus=_1b5|_1b6;
var self=this,_1d9=this.bundleURL(),_1da=new CFURL("..",_1d9);
if(_1da.absoluteString()===_1d9.absoluteString()){
_1da=_1da.schemeAndAuthority();
}
_1ac.resolveResourceAtURL(_1da,YES,function(_1db){
var _1dc=_1d9.absoluteURL().lastPathComponent();
self._staticResource=_1db._children[_1dc]||new _1ac(_1d9,_1db,YES,NO);
function _1dd(_1de){
self._loadStatus&=~_1b6;
var _1df=_1de.request.responsePropertyList();
self._isValid=!!_1df||CFBundle.mainBundle()===self;
if(_1df){
self._infoDictionary=_1df;
}
if(!self._infoDictionary){
_1e1(self,new Error("Could not load bundle at \""+path+"\""));
return;
}
if(self===CFBundle.mainBundle()&&self.valueForInfoDictionaryKey("CPApplicationSize")){
_1be=self.valueForInfoDictionaryKey("CPApplicationSize").valueForKey("executable")||0;
}
_1e5(self,_1d8);
};
function _1e0(){
self._isValid=CFBundle.mainBundle()===self;
self._loadStatus=_1b4;
_1e1(self,new Error("Could not load bundle at \""+self.bundleURL()+"\""));
};
new _b3(new CFURL("Info.plist",self.bundleURL()),_1dd,_1e0);
});
};
function _1e1(_1e2,_1e3){
_1e4(_1e2._staticResource);
_1e2._eventDispatcher.dispatchEvent({type:"error",error:_1e3,bundle:_1e2});
};
function _1e5(_1e6,_1e7){
if(!_1e6.mostEligibleEnvironment()){
return _1e8();
}
_1e9(_1e6,_1ea,_1e8);
_1eb(_1e6,_1ea,_1e8);
if(_1e6._loadStatus===_1b5){
return _1ea();
}
function _1e8(_1ec){
var _1ed=_1e6._loadRequests,_1ee=_1ed.length;
while(_1ee--){
_1ed[_1ee].abort();
}
this._loadRequests=[];
_1e6._loadStatus=_1b4;
_1e1(_1e6,_1ec||new Error("Could not recognize executable code format in Bundle "+_1e6));
};
function _1ea(){
if((typeof CPApp==="undefined"||!CPApp||!CPApp._finishedLaunching)&&typeof OBJJ_PROGRESS_CALLBACK==="function"&&_1be){
OBJJ_PROGRESS_CALLBACK(MAX(MIN(1,_1bd/_1be),0),_1be,_1e6.bundlePath());
}
if(_1e6._loadStatus===_1b5){
_1e6._loadStatus=_1b9;
}else{
return;
}
_1e4(_1e6._staticResource);
function _1ef(){
_1e6._eventDispatcher.dispatchEvent({type:"load",bundle:_1e6});
};
if(_1e7){
_1f0(_1e6,_1ef);
}else{
_1ef();
}
};
};
function _1e9(_1f1,_1f2,_1f3){
var _1f4=_1f1.executableURL();
if(!_1f4){
return;
}
_1f1._loadStatus|=_1b7;
new _b3(_1f4,function(_1f5){
try{
_1bd+=_1f5.request.responseText().length;
_1f6(_1f1,_1f5.request.responseText(),_1f4);
_1f1._loadStatus&=~_1b7;
_1f2();
}
catch(anException){
_1f3(anException);
}
},_1f3);
};
function _1f7(_1f8){
return "mhtml:"+new CFURL("MHTMLTest.txt",_1f8.mostEligibleEnvironmentURL());
};
function _1f9(_1fa){
if(_1fb===_1fc){
return new CFURL("dataURLs.txt",_1fa.mostEligibleEnvironmentURL());
}
if(_1fb===_1fd||_1fb===_1fe){
return new CFURL("MHTMLPaths.txt",_1fa.mostEligibleEnvironmentURL());
}
return NULL;
};
function _1eb(_1ff,_200,_201){
if(!_1ff.hasSpritedImages()){
return;
}
_1ff._loadStatus|=_1b8;
if(!_202()){
return _203(_1f7(_1ff),function(){
_1eb(_1ff,_200,_201);
});
}
var _204=_1f9(_1ff);
if(!_204){
_1ff._loadStatus&=~_1b8;
return _200();
}
new _b3(_204,function(_205){
try{
_1bd+=_205.request.responseText().length;
_1f6(_1ff,_205.request.responseText(),_204);
_1ff._loadStatus&=~_1b8;
}
catch(anException){
_201(anException);
}
_200();
},_201);
};
var _206=[],_1fb=-1,_207=0,_1fc=1,_1fd=2,_1fe=3;
function _202(){
return _1fb!==-1;
};
function _203(_208,_209){
if(_202()){
return;
}
_206.push(_209);
if(_206.length>1){
return;
}
_206.push(function(){
var size=0,_20a=CFBundle.mainBundle().valueForInfoDictionaryKey("CPApplicationSize");
if(!_20a){
return;
}
switch(_1fb){
case _1fc:
size=_20a.valueForKey("data");
break;
case _1fd:
case _1fe:
size=_20a.valueForKey("mhtml");
break;
}
_1be+=size;
});
_20b([_1fc,"data:image/gif;base64,R0lGODlhAQABAIAAAMc9BQAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==",_1fd,_208+"!test",_1fe,_208+"?"+_1bc+"!test"]);
};
function _20c(){
var _20d=_206.length;
while(_20d--){
_206[_20d]();
}
};
function _20b(_20e){
if(!("Image" in _1)||_20e.length<2){
_1fb=_207;
_20c();
return;
}
var _20f=new Image();
_20f.onload=function(){
if(_20f.width===1&&_20f.height===1){
_1fb=_20e[0];
_20c();
}else{
_20f.onerror();
}
};
_20f.onerror=function(){
_20b(_20e.slice(2));
};
_20f.src=_20e[1];
};
function _1f0(_210,_211){
var _212=[_210._staticResource];
function _213(_214){
for(;_214<_212.length;++_214){
var _215=_212[_214];
if(_215.isNotFound()){
continue;
}
if(_215.isFile()){
var _216=new _4e3(_215.URL());
if(_216.hasLoadedFileDependencies()){
_216.execute();
}else{
_216.loadFileDependencies(function(){
_213(_214);
});
return;
}
}else{
if(_215.URL().absoluteString()===_210.resourcesDirectoryURL().absoluteString()){
continue;
}
var _217=_215.children();
for(var name in _217){
if(_7c.call(_217,name)){
_212.push(_217[name]);
}
}
}
}
_211();
};
_213(0);
};
var _218="@STATIC",_219="p",_21a="u",_21b="c",_21c="t",_21d="I",_21e="i";
function _1f6(_21f,_220,_221){
var _222=new _10b(_220);
if(_222.magicNumber()!==_218){
throw new Error("Could not read static file: "+_221);
}
if(_222.version()!=="1.0"){
throw new Error("Could not read static file: "+_221);
}
var _223,_224=_21f.bundleURL(),file=NULL;
while(_223=_222.getMarker()){
var text=_222.getString();
if(_223===_219){
var _225=new CFURL(text,_224),_226=_1ac.resourceAtURL(new CFURL(".",_225),YES);
file=new _1ac(_225,_226,NO,YES);
}else{
if(_223===_21a){
var URL=new CFURL(text,_224),_227=_222.getString();
if(_227.indexOf("mhtml:")===0){
_227="mhtml:"+new CFURL(_227.substr("mhtml:".length),_224);
if(_1fb===_1fe){
var _228=_227.indexOf("!"),_229=_227.substring(0,_228),_22a=_227.substring(_228);
_227=_229+"?"+_1bc+_22a;
}
}
CFURL.setMappedURLForURL(URL,new CFURL(_227));
var _226=_1ac.resourceAtURL(new CFURL(".",URL),YES);
new _1ac(URL,_226,NO,YES);
}else{
if(_223===_21c){
file.write(text);
}
}
}
}
};
CFBundle.prototype.addEventListener=function(_22b,_22c){
this._eventDispatcher.addEventListener(_22b,_22c);
};
CFBundle.prototype.removeEventListener=function(_22d,_22e){
this._eventDispatcher.removeEventListener(_22d,_22e);
};
CFBundle.prototype.onerror=function(_22f){
throw _22f.error;
};
CFBundle.prototype.bundlePath=function(){
return this._bundleURL.absoluteURL().path();
};
CFBundle.prototype.path=function(){
CPLog.warn("CFBundle.prototype.path is deprecated, use CFBundle.prototype.bundlePath instead.");
return this.bundlePath.apply(this,arguments);
};
CFBundle.prototype.pathForResource=function(_230){
return this.resourceURL(_230).absoluteString();
};
var _231={};
function _1ac(aURL,_232,_233,_234,_235){
this._parent=_232;
this._eventDispatcher=new _77(this);
var name=aURL.absoluteURL().lastPathComponent()||aURL.schemeAndAuthority();
this._name=name;
this._URL=aURL;
this._isResolved=!!_234;
this._filenameTranslateDictionary=_235;
if(_233){
this._URL=this._URL.asDirectoryPathURL();
}
if(!_232){
_231[name]=this;
}
this._isDirectory=!!_233;
this._isNotFound=NO;
if(_232){
_232._children[name]=this;
}
if(_233){
this._children={};
}else{
this._contents="";
}
};
_1ac.rootResources=function(){
return _231;
};
function _236(x){
var _237=0;
for(var k in x){
if(x.hasOwnProperty(k)){
++_237;
}
}
return _237;
};
_1ac.resetRootResources=function(){
_231={};
};
_1ac.prototype.filenameTranslateDictionary=function(){
return this._filenameTranslateDictionary||{};
};
_2.StaticResource=_1ac;
function _1e4(_238){
_238._isResolved=YES;
_238._eventDispatcher.dispatchEvent({type:"resolve",staticResource:_238});
};
_1ac.prototype.resolve=function(){
if(this.isDirectory()){
var _239=new CFBundle(this.URL());
_239.onerror=function(){
};
_239.load(NO);
}else{
var self=this;
function _23a(_23b){
self._contents=_23b.request.responseText();
_1e4(self);
};
function _23c(){
self._isNotFound=YES;
_1e4(self);
};
var url=this.URL(),_23d=this.filenameTranslateDictionary();
if(_23d){
var _23e=url.toString(),_23f=url.lastPathComponent(),_240=_23e.substring(0,_23e.length-_23f.length),_241=_23d[_23f];
if(_241&&_23e.slice(-_241.length)!==_241){
url=new CFURL(_240+_241);
}
}
new _b3(url,_23a,_23c);
}
};
_1ac.prototype.name=function(){
return this._name;
};
_1ac.prototype.URL=function(){
return this._URL;
};
_1ac.prototype.contents=function(){
return this._contents;
};
_1ac.prototype.children=function(){
return this._children;
};
_1ac.prototype.parent=function(){
return this._parent;
};
_1ac.prototype.isResolved=function(){
return this._isResolved;
};
_1ac.prototype.write=function(_242){
this._contents+=_242;
};
function _243(_244){
var _245=_244.schemeAndAuthority(),_246=_231[_245];
if(!_246){
_246=new _1ac(new CFURL(_245),NULL,YES,YES);
}
return _246;
};
_1ac.resourceAtURL=function(aURL,_247){
aURL=_1bf(aURL).absoluteURL();
var _248=_243(aURL),_249=aURL.pathComponents(),_97=0,_24a=_249.length;
for(;_97<_24a;++_97){
var name=_249[_97];
if(_7c.call(_248._children,name)){
_248=_248._children[name];
}else{
if(_247){
if(name!=="/"){
name="./"+name;
}
_248=new _1ac(new CFURL(name,_248.URL()),_248,YES,YES);
}else{
throw new Error("Static Resource at "+aURL+" is not resolved (\""+name+"\")");
}
}
}
return _248;
};
_1ac.prototype.resourceAtURL=function(aURL,_24b){
return _1ac.resourceAtURL(new CFURL(aURL,this.URL()),_24b);
};
_1ac.resolveResourceAtURL=function(aURL,_24c,_24d,_24e){
aURL=_1bf(aURL).absoluteURL();
_24f(_243(aURL),_24c,aURL.pathComponents(),0,_24d,_24e);
};
_1ac.prototype.resolveResourceAtURL=function(aURL,_250,_251){
_1ac.resolveResourceAtURL(new CFURL(aURL,this.URL()).absoluteURL(),_250,_251);
};
function _24f(_252,_253,_254,_255,_256,_257){
var _258=_254.length;
for(;_255<_258;++_255){
var name=_254[_255],_259=_7c.call(_252._children,name)&&_252._children[name];
if(!_259){
_259=new _1ac(new CFURL(name,_252.URL()),_252,_255+1<_258||_253,NO,_257);
_259.resolve();
}
if(!_259.isResolved()){
return _259.addEventListener("resolve",function(){
_24f(_252,_253,_254,_255,_256,_257);
});
}
if(_259.isNotFound()){
return _256(null,new Error("File not found: "+_254.join("/")));
}
if((_255+1<_258)&&_259.isFile()){
return _256(null,new Error("File is not a directory: "+_254.join("/")));
}
_252=_259;
}
_256(_252);
};
function _25a(aURL,_25b,_25c){
var _25d=_1ac.includeURLs(),_25e=new CFURL(aURL,_25d[_25b]).absoluteURL();
_1ac.resolveResourceAtURL(_25e,NO,function(_25f){
if(!_25f){
if(_25b+1<_25d.length){
_25a(aURL,_25b+1,_25c);
}else{
_25c(NULL);
}
return;
}
_25c(_25f);
});
};
_1ac.resolveResourceAtURLSearchingIncludeURLs=function(aURL,_260){
_25a(aURL,0,_260);
};
_1ac.prototype.addEventListener=function(_261,_262){
this._eventDispatcher.addEventListener(_261,_262);
};
_1ac.prototype.removeEventListener=function(_263,_264){
this._eventDispatcher.removeEventListener(_263,_264);
};
_1ac.prototype.isNotFound=function(){
return this._isNotFound;
};
_1ac.prototype.isFile=function(){
return !this._isDirectory;
};
_1ac.prototype.isDirectory=function(){
return this._isDirectory;
};
_1ac.prototype.toString=function(_265){
if(this.isNotFound()){
return "<file not found: "+this.name()+">";
}
var _266=this.name();
if(this.isDirectory()){
var _267=this._children;
for(var name in _267){
if(_267.hasOwnProperty(name)){
var _268=_267[name];
if(_265||!_268.isNotFound()){
_266+="\n\t"+_267[name].toString(_265).split("\n").join("\n\t");
}
}
}
}
return _266;
};
var _269=NULL;
_1ac.includeURLs=function(){
if(_269!==NULL){
return _269;
}
_269=[];
if(!_1.OBJJ_INCLUDE_PATHS&&!_1.OBJJ_INCLUDE_URLS){
_269=["Frameworks","Frameworks/Debug"];
}else{
_269=(_1.OBJJ_INCLUDE_PATHS||[]).concat(_1.OBJJ_INCLUDE_URLS||[]);
}
var _26a=_269.length;
while(_26a--){
_269[_26a]=new CFURL(_269[_26a]).asDirectoryPathURL();
}
return _269;
};
var _26b="accessors",_26c="class",_26d="end",_26e="function",_26f="implementation",_270="import",_271="each",_272="outlet",_273="action",_274="new",_275="selector",_276="super",_277="var",_278="in",_279="pragma",_27a="mark",_27b="=",_27c="+",_27d="-",_27e=":",_27f=",",_280=".",_281="*",_282=";",_283="<",_284="{",_285="}",_286=">",_287="[",_288="\"",_289="@",_28a="#",_28b="]",_28c="?",_28d="(",_28e=")",_28f=/^(?:(?:\s+$)|(?:\/(?:\/|\*)))/,_290=/^[+-]?\d+(([.]\d+)*([eE][+-]?\d+))?$/,_291=/^[a-zA-Z_$](\w|$)*$/;
function _292(_293){
this._index=-1;
this._tokens=(_293+"\n").match(/\/\/.*(\r|\n)?|\/\*(?:.|\n|\r)*?\*\/|\w+\b|[+-]?\d+(([.]\d+)*([eE][+-]?\d+))?|"[^"\\]*(\\[\s\S][^"\\]*)*"|'[^'\\]*(\\[\s\S][^'\\]*)*'|\s+|./g);
this._context=[];
return this;
};
_292.prototype.push=function(){
this._context.push(this._index);
};
_292.prototype.pop=function(){
this._index=this._context.pop();
};
_292.prototype.peek=function(_294){
if(_294){
this.push();
var _295=this.skip_whitespace();
this.pop();
return _295;
}
return this._tokens[this._index+1];
};
_292.prototype.next=function(){
return this._tokens[++this._index];
};
_292.prototype.previous=function(){
return this._tokens[--this._index];
};
_292.prototype.last=function(){
if(this._index<0){
return NULL;
}
return this._tokens[this._index-1];
};
_292.prototype.skip_whitespace=function(_296){
var _297;
if(_296){
while((_297=this.previous())&&_28f.test(_297)){
}
}else{
while((_297=this.next())&&_28f.test(_297)){
}
}
return _297;
};
_2.Lexer=_292;
function _298(){
this.atoms=[];
};
_298.prototype.toString=function(){
return this.atoms.join("");
};
_2.preprocess=function(_299,aURL,_29a){
return new _29b(_299,aURL,_29a).executable();
};
_2.eval=function(_29c){
return eval(_2.preprocess(_29c).code());
};
var _29b=function(_29d,aURL,_29e){
this._URL=new CFURL(aURL);
_29d=_29d.replace(/^#[^\n]+\n/,"\n");
this._currentSelector="";
this._currentClass="";
this._currentSuperClass="";
this._currentSuperMetaClass="";
this._buffer=new _298();
this._preprocessed=NULL;
this._dependencies=[];
this._tokens=new _292(_29d);
this._flags=_29e;
this._classMethod=false;
this._executable=NULL;
this._classLookupTable={};
this._classVars={};
var _29f=new objj_class();
for(var i in _29f){
this._classVars[i]=1;
}
this.preprocess(this._tokens,this._buffer);
};
_29b.prototype.setClassInfo=function(_2a0,_2a1,_2a2){
this._classLookupTable[_2a0]={superClassName:_2a1,ivars:_2a2};
};
_29b.prototype.getClassInfo=function(_2a3){
return this._classLookupTable[_2a3];
};
_29b.prototype.allIvarNamesForClassName=function(_2a4){
var _2a5={},_2a6=this.getClassInfo(_2a4);
while(_2a6){
for(var i in _2a6.ivars){
_2a5[i]=1;
}
_2a6=this.getClassInfo(_2a6.superClassName);
}
return _2a5;
};
_2.Preprocessor=_29b;
_29b.Flags={};
_29b.Flags.IncludeDebugSymbols=1<<0;
_29b.Flags.IncludeTypeSignatures=1<<1;
_29b.prototype.executable=function(){
if(!this._executable){
this._executable=new _2a7(this._buffer.toString(),this._dependencies,this._URL);
}
return this._executable;
};
_29b.prototype.accessors=function(_2a8){
var _2a9=_2a8.skip_whitespace(),_2aa={};
if(_2a9!=_28d){
_2a8.previous();
return _2aa;
}
while((_2a9=_2a8.skip_whitespace())!=_28e){
var name=_2a9,_2ab=true;
if(!/^\w+$/.test(name)){
throw new SyntaxError(this.error_message("*** @accessors attribute name not valid."));
}
if((_2a9=_2a8.skip_whitespace())==_27b){
_2ab=_2a8.skip_whitespace();
if(!/^\w+$/.test(_2ab)){
throw new SyntaxError(this.error_message("*** @accessors attribute value not valid."));
}
if(name=="setter"){
if((_2a9=_2a8.next())!=_27e){
throw new SyntaxError(this.error_message("*** @accessors setter attribute requires argument with \":\" at end of selector name."));
}
_2ab+=":";
}
_2a9=_2a8.skip_whitespace();
}
_2aa[name]=_2ab;
if(_2a9==_28e){
break;
}
if(_2a9!=_27f){
throw new SyntaxError(this.error_message("*** Expected ',' or ')' in @accessors attribute list."));
}
}
return _2aa;
};
_29b.prototype.brackets=function(_2ac,_2ad){
var _2ae=[];
while(this.preprocess(_2ac,NULL,NULL,NULL,_2ae[_2ae.length]=[])){
}
if(_2ae[0].length===1){
_2ad.atoms[_2ad.atoms.length]="[";
_2ad.atoms[_2ad.atoms.length]=_2ae[0][0];
_2ad.atoms[_2ad.atoms.length]="]";
}else{
var _2af=new _298();
if(_2ae[0][0].atoms[0]==_276){
_2ad.atoms[_2ad.atoms.length]="objj_msgSendSuper(";
_2ad.atoms[_2ad.atoms.length]="{ receiver:self, super_class:"+(this._classMethod?this._currentSuperMetaClass:this._currentSuperClass)+" }";
}else{
_2ad.atoms[_2ad.atoms.length]="objj_msgSend(";
_2ad.atoms[_2ad.atoms.length]=_2ae[0][0];
}
_2af.atoms[_2af.atoms.length]=_2ae[0][1];
var _2b0=1,_2b1=_2ae.length,_2b2=new _298();
for(;_2b0<_2b1;++_2b0){
var pair=_2ae[_2b0];
_2af.atoms[_2af.atoms.length]=pair[1];
_2b2.atoms[_2b2.atoms.length]=", "+pair[0];
}
_2ad.atoms[_2ad.atoms.length]=", \"";
_2ad.atoms[_2ad.atoms.length]=_2af;
_2ad.atoms[_2ad.atoms.length]="\"";
_2ad.atoms[_2ad.atoms.length]=_2b2;
_2ad.atoms[_2ad.atoms.length]=")";
}
};
_29b.prototype.directive=function(_2b3,_2b4,_2b5){
var _2b6=_2b4?_2b4:new _298(),_2b7=_2b3.next();
if(_2b7.charAt(0)==_288){
_2b6.atoms[_2b6.atoms.length]=_2b7;
}else{
if(_2b7===_26c){
_2b3.skip_whitespace();
return;
}else{
if(_2b7===_26f){
this.implementation(_2b3,_2b6);
}else{
if(_2b7===_270){
this._import(_2b3);
}else{
if(_2b7===_275){
this.selector(_2b3,_2b6);
}
}
}
}
}
if(!_2b4){
return _2b6;
}
};
_29b.prototype.hash=function(_2b8,_2b9){
var _2ba=_2b9?_2b9:new _298(),_2bb=_2b8.next();
if(_2bb===_279){
_2bb=_2b8.skip_whitespace();
if(_2bb===_27a){
while((_2bb=_2b8.next()).indexOf("\n")<0){
}
}
}else{
throw new SyntaxError(this.error_message("*** Expected \"pragma\" to follow # but instead saw \""+_2bb+"\"."));
}
};
_29b.prototype.implementation=function(_2bc,_2bd){
var _2be=_2bd,_2bf="",_2c0=NO,_2c1=_2bc.skip_whitespace(),_2c2="Nil",_2c3=new _298(),_2c4=new _298();
if(!(/^\w/).test(_2c1)){
throw new Error(this.error_message("*** Expected class name, found \""+_2c1+"\"."));
}
this._currentSuperClass="objj_getClass(\""+_2c1+"\").super_class";
this._currentSuperMetaClass="objj_getMetaClass(\""+_2c1+"\").super_class";
this._currentClass=_2c1;
this._currentSelector="";
if((_2bf=_2bc.skip_whitespace())==_28d){
_2bf=_2bc.skip_whitespace();
if(_2bf==_28e){
throw new SyntaxError(this.error_message("*** Can't Have Empty Category Name for class \""+_2c1+"\"."));
}
if(_2bc.skip_whitespace()!=_28e){
throw new SyntaxError(this.error_message("*** Improper Category Definition for class \""+_2c1+"\"."));
}
_2be.atoms[_2be.atoms.length]="{\nvar the_class = objj_getClass(\""+_2c1+"\")\n";
_2be.atoms[_2be.atoms.length]="if(!the_class) throw new SyntaxError(\"*** Could not find definition for class \\\""+_2c1+"\\\"\");\n";
_2be.atoms[_2be.atoms.length]="var meta_class = the_class.isa;";
}else{
if(_2bf==_27e){
_2bf=_2bc.skip_whitespace();
if(!_291.test(_2bf)){
throw new SyntaxError(this.error_message("*** Expected class name, found \""+_2bf+"\"."));
}
_2c2=_2bf;
_2bf=_2bc.skip_whitespace();
}
_2be.atoms[_2be.atoms.length]="{var the_class = objj_allocateClassPair("+_2c2+", \""+_2c1+"\"),\nmeta_class = the_class.isa;";
if(_2bf==_284){
var _2c5={},_2c6=0,_2c7=[],_2c8,_2c9={},_2ca=[];
while((_2bf=_2bc.skip_whitespace())&&_2bf!=_285){
if(_2bf===_289){
_2bf=_2bc.next();
if(_2bf===_26b){
_2c8=this.accessors(_2bc);
}else{
if(_2bf!==_272){
throw new SyntaxError(this.error_message("*** Unexpected '@' token in ivar declaration ('@"+_2bf+"')."));
}else{
_2ca.push("@"+_2bf);
}
}
}else{
if(_2bf==_282){
if(_2c6++===0){
_2be.atoms[_2be.atoms.length]="class_addIvars(the_class, [";
}else{
_2be.atoms[_2be.atoms.length]=", ";
}
var name=_2c7[_2c7.length-1];
if(this._flags&_29b.Flags.IncludeTypeSignatures){
_2be.atoms[_2be.atoms.length]="new objj_ivar(\""+name+"\", \""+_2ca.slice(0,_2ca.length-1).join(" ")+"\")";
}else{
_2be.atoms[_2be.atoms.length]="new objj_ivar(\""+name+"\")";
}
_2c5[name]=1;
_2c7=[];
_2ca=[];
if(_2c8){
_2c9[name]=_2c8;
_2c8=NULL;
}
}else{
_2c7.push(_2bf);
_2ca.push(_2bf);
}
}
}
if(_2c7.length){
throw new SyntaxError(this.error_message("*** Expected ';' in ivar declaration, found '}'."));
}
if(_2c6){
_2be.atoms[_2be.atoms.length]="]);\n";
}
if(!_2bf){
throw new SyntaxError(this.error_message("*** Expected '}'"));
}
this.setClassInfo(_2c1,_2c2==="Nil"?null:_2c2,_2c5);
var _2c5=this.allIvarNamesForClassName(_2c1);
for(ivar_name in _2c9){
var _2cb=_2c9[ivar_name],_2cc=_2cb["property"]||ivar_name;
var _2cd=_2cb["getter"]||_2cc,_2ce="(id)"+_2cd+"\n{\nreturn "+ivar_name+";\n}";
if(_2c3.atoms.length!==0){
_2c3.atoms[_2c3.atoms.length]=",\n";
}
_2c3.atoms[_2c3.atoms.length]=this.method(new _292(_2ce),_2c5);
if(_2cb["readonly"]){
continue;
}
var _2cf=_2cb["setter"];
if(!_2cf){
var _2d0=_2cc.charAt(0)=="_"?1:0;
_2cf=(_2d0?"_":"")+"set"+_2cc.substr(_2d0,1).toUpperCase()+_2cc.substring(_2d0+1)+":";
}
var _2d1="(void)"+_2cf+"(id)newValue\n{\n";
if(_2cb["copy"]){
_2d1+="if ("+ivar_name+" !== newValue)\n"+ivar_name+" = [newValue copy];\n}";
}else{
_2d1+=ivar_name+" = newValue;\n}";
}
if(_2c3.atoms.length!==0){
_2c3.atoms[_2c3.atoms.length]=",\n";
}
_2c3.atoms[_2c3.atoms.length]=this.method(new _292(_2d1),_2c5);
}
}else{
_2bc.previous();
}
_2be.atoms[_2be.atoms.length]="objj_registerClassPair(the_class);\n";
}
if(!_2c5){
var _2c5=this.allIvarNamesForClassName(_2c1);
}
while((_2bf=_2bc.skip_whitespace())){
if(_2bf==_27c){
this._classMethod=true;
if(_2c4.atoms.length!==0){
_2c4.atoms[_2c4.atoms.length]=", ";
}
_2c4.atoms[_2c4.atoms.length]=this.method(_2bc,this._classVars);
}else{
if(_2bf==_27d){
this._classMethod=false;
if(_2c3.atoms.length!==0){
_2c3.atoms[_2c3.atoms.length]=", ";
}
_2c3.atoms[_2c3.atoms.length]=this.method(_2bc,_2c5);
}else{
if(_2bf==_28a){
this.hash(_2bc,_2be);
}else{
if(_2bf==_289){
if((_2bf=_2bc.next())==_26d){
break;
}else{
throw new SyntaxError(this.error_message("*** Expected \"@end\", found \"@"+_2bf+"\"."));
}
}
}
}
}
}
if(_2c3.atoms.length!==0){
_2be.atoms[_2be.atoms.length]="class_addMethods(the_class, [";
_2be.atoms[_2be.atoms.length]=_2c3;
_2be.atoms[_2be.atoms.length]="]);\n";
}
if(_2c4.atoms.length!==0){
_2be.atoms[_2be.atoms.length]="class_addMethods(meta_class, [";
_2be.atoms[_2be.atoms.length]=_2c4;
_2be.atoms[_2be.atoms.length]="]);\n";
}
_2be.atoms[_2be.atoms.length]="}";
this._currentClass="";
};
_29b.prototype._import=function(_2d2){
var _2d3="",_2d4=_2d2.skip_whitespace(),_2d5=(_2d4!==_283);
if(_2d4===_283){
while((_2d4=_2d2.next())&&_2d4!==_286){
_2d3+=_2d4;
}
if(!_2d4){
throw new SyntaxError(this.error_message("*** Unterminated import statement."));
}
}else{
if(_2d4.charAt(0)===_288){
_2d3=_2d4.substr(1,_2d4.length-2);
}else{
throw new SyntaxError(this.error_message("*** Expecting '<' or '\"', found \""+_2d4+"\"."));
}
}
this._buffer.atoms[this._buffer.atoms.length]="objj_executeFile(\"";
this._buffer.atoms[this._buffer.atoms.length]=_2d3;
this._buffer.atoms[this._buffer.atoms.length]=_2d5?"\", YES);":"\", NO);";
this._dependencies.push(new _2d6(new CFURL(_2d3),_2d5));
};
_29b.prototype.method=function(_2d7,_2d8){
var _2d9=new _298(),_2da,_2db="",_2dc=[],_2dd=[null];
_2d8=_2d8||{};
while((_2da=_2d7.skip_whitespace())&&_2da!==_284&&_2da!==_282){
if(_2da==_27e){
var type="";
_2db+=_2da;
_2da=_2d7.skip_whitespace();
if(_2da==_28d){
while((_2da=_2d7.skip_whitespace())&&_2da!=_28e){
type+=_2da;
}
_2da=_2d7.skip_whitespace();
}
_2dd[_2dc.length+1]=type||null;
_2dc[_2dc.length]=_2da;
if(_2da in _2d8){
CPLog.warn(this.error_message("*** Warning: Method ( "+_2db+" ) uses a parameter name that is already in use ( "+_2da+" )"));
}
}else{
if(_2da==_28d){
var type="";
while((_2da=_2d7.skip_whitespace())&&_2da!=_28e){
type+=_2da;
}
_2dd[0]=type||null;
}else{
if(_2da==_27f){
if((_2da=_2d7.skip_whitespace())!=_280||_2d7.next()!=_280||_2d7.next()!=_280){
throw new SyntaxError(this.error_message("*** Argument list expected after ','."));
}
}else{
_2db+=_2da;
}
}
}
}
if(_2da===_282){
_2da=_2d7.skip_whitespace();
if(_2da!==_284){
throw new SyntaxError(this.error_message("Invalid semi-colon in method declaration. "+"Semi-colons are allowed only to terminate the method signature, before the open brace."));
}
}
var _2de=0,_2df=_2dc.length;
_2d9.atoms[_2d9.atoms.length]="new objj_method(sel_getUid(\"";
_2d9.atoms[_2d9.atoms.length]=_2db;
_2d9.atoms[_2d9.atoms.length]="\"), function";
this._currentSelector=_2db;
if(this._flags&_29b.Flags.IncludeDebugSymbols){
_2d9.atoms[_2d9.atoms.length]=" $"+this._currentClass+"__"+_2db.replace(/:/g,"_");
}
_2d9.atoms[_2d9.atoms.length]="(self, _cmd";
for(;_2de<_2df;++_2de){
_2d9.atoms[_2d9.atoms.length]=", ";
_2d9.atoms[_2d9.atoms.length]=_2dc[_2de];
}
_2d9.atoms[_2d9.atoms.length]=")\n{ with(self)\n{";
_2d9.atoms[_2d9.atoms.length]=this.preprocess(_2d7,NULL,_285,_284);
_2d9.atoms[_2d9.atoms.length]="}\n}";
if(this._flags&_29b.Flags.IncludeDebugSymbols){
_2d9.atoms[_2d9.atoms.length]=","+JSON.stringify(_2dd);
}
_2d9.atoms[_2d9.atoms.length]=")";
this._currentSelector="";
return _2d9;
};
_29b.prototype.preprocess=function(_2e0,_2e1,_2e2,_2e3,_2e4){
var _2e5=_2e1?_2e1:new _298(),_2e6=0,_2e7="";
if(_2e4){
_2e4[0]=_2e5;
var _2e8=false,_2e9=[0,0,0];
}
while((_2e7=_2e0.next())&&((_2e7!==_2e2)||_2e6)){
if(_2e4){
if(_2e7===_28c){
++_2e9[2];
}else{
if(_2e7===_284){
++_2e9[0];
}else{
if(_2e7===_285){
--_2e9[0];
}else{
if(_2e7===_28d){
++_2e9[1];
}else{
if(_2e7===_28e){
--_2e9[1];
}else{
if((_2e7===_27e&&_2e9[2]--===0||(_2e8=(_2e7===_28b)))&&_2e9[0]===0&&_2e9[1]===0){
_2e0.push();
var _2ea=_2e8?_2e0.skip_whitespace(true):_2e0.previous(),_2eb=_28f.test(_2ea);
if(_2eb||_291.test(_2ea)&&_28f.test(_2e0.previous())){
_2e0.push();
var last=_2e0.skip_whitespace(true),_2ec=true,_2ed=false;
if(last==="+"||last==="-"){
if(_2e0.previous()!==last){
_2ec=false;
}else{
last=_2e0.skip_whitespace(true);
_2ed=true;
}
}
_2e0.pop();
_2e0.pop();
if(_2ec&&((!_2ed&&(last===_285))||last===_28e||last===_28b||last===_280||_290.test(last)||last.charAt(last.length-1)==="\""||last.charAt(last.length-1)==="'"||_291.test(last)&&!/^(new|return|case|var)$/.test(last))){
if(_2eb){
_2e4[1]=":";
}else{
_2e4[1]=_2ea;
if(!_2e8){
_2e4[1]+=":";
}
var _2e6=_2e5.atoms.length;
while(_2e5.atoms[_2e6--]!==_2ea){
}
_2e5.atoms.length=_2e6;
}
return !_2e8;
}
if(_2e8){
return NO;
}
}
_2e0.pop();
if(_2e8){
return NO;
}
}
}
}
}
}
}
_2e9[2]=MAX(_2e9[2],0);
}
if(_2e3){
if(_2e7===_2e3){
++_2e6;
}else{
if(_2e7===_2e2){
--_2e6;
}
}
}
if(_2e7===_26e){
var _2ee="";
while((_2e7=_2e0.next())&&_2e7!==_28d&&!(/^\w/).test(_2e7)){
_2ee+=_2e7;
}
if(_2e7===_28d){
if(_2e3===_28d){
++_2e6;
}
_2e5.atoms[_2e5.atoms.length]="function"+_2ee+"(";
if(_2e4){
++_2e9[1];
}
}else{
_2e5.atoms[_2e5.atoms.length]=_2e7+" = function";
}
}else{
if(_2e7==_289){
this.directive(_2e0,_2e5);
}else{
if(_2e7==_28a){
this.hash(_2e0,_2e5);
}else{
if(_2e7==_287){
this.brackets(_2e0,_2e5);
}else{
_2e5.atoms[_2e5.atoms.length]=_2e7;
}
}
}
}
}
if(_2e4){
throw new SyntaxError(this.error_message("*** Expected ']' - Unterminated message send or array."));
}
if(!_2e1){
return _2e5;
}
};
_29b.prototype.selector=function(_2ef,_2f0){
var _2f1=_2f0?_2f0:new _298();
_2f1.atoms[_2f1.atoms.length]="sel_getUid(\"";
if(_2ef.skip_whitespace()!=_28d){
throw new SyntaxError(this.error_message("*** Expected '('"));
}
var _2f2=_2ef.skip_whitespace();
if(_2f2==_28e){
throw new SyntaxError(this.error_message("*** Unexpected ')', can't have empty @selector()"));
}
_2f0.atoms[_2f0.atoms.length]=_2f2;
var _2f3,_2f4=true;
while((_2f3=_2ef.next())&&_2f3!=_28e){
if(_2f4&&/^\d+$/.test(_2f3)||!(/^(\w|$|\:)/.test(_2f3))){
if(!(/\S/).test(_2f3)){
if(_2ef.skip_whitespace()==_28e){
break;
}else{
throw new SyntaxError(this.error_message("*** Unexpected whitespace in @selector()."));
}
}else{
throw new SyntaxError(this.error_message("*** Illegal character '"+_2f3+"' in @selector()."));
}
}
_2f1.atoms[_2f1.atoms.length]=_2f3;
_2f4=(_2f3==_27e);
}
_2f1.atoms[_2f1.atoms.length]="\")";
if(!_2f0){
return _2f1;
}
};
_29b.prototype.error_message=function(_2f5){
return _2f5+" <Context File: "+this._URL+(this._currentClass?" Class: "+this._currentClass:"")+(this._currentSelector?" Method: "+this._currentSelector:"")+">";
};
if(!_2.acorn){
_2.acorn={};
_2.acorn.walk={};
}
(function(_2f6){
"use strict";
_2f6.version="0.0.1";
var _2f7,_2f8,_2f9,_2fa;
_2f6.parse=function(inpt,opts){
_2f8=String(inpt);
_2f9=_2f8.length;
_2f7=opts||{};
for(var opt in _2fb){
if(!_2f7.hasOwnProperty(opt)){
_2f7[opt]=_2fb[opt];
}
}
_2fa=_2f7.sourceFile||null;
return _2fc(_2f7.program);
};
var _2fb=_2f6.defaultOptions={ecmaVersion:5,strictSemicolons:false,allowTrailingCommas:true,forbidReserved:false,trackComments:false,trackSpaces:false,locations:false,ranges:false,program:null,sourceFile:null,objj:true};
var _2fd=_2f6.getLineInfo=function(_2fe,_2ff){
for(var line=1,cur=0;;){
_300.lastIndex=cur;
var _301=_300.exec(_2fe);
if(_301&&_301.index<_2ff){
++line;
cur=_301.index+_301[0].length;
}else{
break;
}
}
return {line:line,column:_2ff-cur,lineStart:cur,lineEnd:(_301?_301.index+_301[0].length:_2fe.length)};
};
var _302;
var _303,_304;
var _305,_306;
var _307,_308;
var _309,_30a,_30b;
var _30c,_30d,_30e;
var _30f,_310,_311;
var _312,_313,_314;
var _315,_316,_317;
var _318;
var _319;
var _31a,_31b,_31c;
function _31d(pos,_31e){
if(typeof pos=="number"){
pos=_2fd(_2f8,pos);
}
var _31f=new SyntaxError(_31e);
_31f.line=pos.line;
_31f.column=pos.column;
_31f.lineStart=pos.lineStart;
_31f.lineEnd=pos.lineEnd;
throw _31f;
};
var _320={type:"num"},_321={type:"regexp"},_322={type:"string"};
var _323={type:"name"},_324={type:"eof"};
var _325={keyword:"break"},_326={keyword:"case",beforeExpr:true},_327={keyword:"catch"};
var _328={keyword:"continue"},_329={keyword:"debugger"},_32a={keyword:"default"};
var _32b={keyword:"do",isLoop:true},_32c={keyword:"else",beforeExpr:true};
var _32d={keyword:"finally"},_32e={keyword:"for",isLoop:true},_32f={keyword:"function"};
var _330={keyword:"if"},_331={keyword:"return",beforeExpr:true},_332={keyword:"switch"};
var _333={keyword:"throw",beforeExpr:true},_334={keyword:"try"},_335={keyword:"var"};
var _336={keyword:"while",isLoop:true},_337={keyword:"with"},_338={keyword:"new",beforeExpr:true};
var _339={keyword:"this"};
var _33a={keyword:"void",prefix:true};
var _33b={keyword:"null",atomValue:null},_33c={keyword:"true",atomValue:true};
var _33d={keyword:"false",atomValue:false};
var _33e={keyword:"in",binop:7,beforeExpr:true};
var _33f={keyword:"implementation"},_340={keyword:"outlet"},_341={keyword:"accessors"};
var _342={keyword:"end"},_343={keyword:"import",afterImport:true};
var _344={keyword:"action"},_345={keyword:"selector"},_346={keyword:"class"},_347={keyword:"global"};
var _348={keyword:"{"},_349={keyword:"["};
var _34a={keyword:"filename"},_34b={keyword:"unsigned",okAsIdent:true},_34c={keyword:"signed",okAsIdent:true};
var _34d={keyword:"byte",okAsIdent:true},_34e={keyword:"char",okAsIdent:true},_34f={keyword:"short",okAsIdent:true};
var _350={keyword:"int",okAsIdent:true},_351={keyword:"long",okAsIdent:true},_352={keyword:"#"};
var _353={"break":_325,"case":_326,"catch":_327,"continue":_328,"debugger":_329,"default":_32a,"do":_32b,"else":_32c,"finally":_32d,"for":_32e,"function":_32f,"if":_330,"return":_331,"switch":_332,"throw":_333,"try":_334,"var":_335,"while":_336,"with":_337,"null":_33b,"true":_33c,"false":_33d,"new":_338,"in":_33e,"instanceof":{keyword:"instanceof",binop:7},"this":_339,"typeof":{keyword:"typeof",prefix:true},"void":_33a,"delete":{keyword:"delete",prefix:true}};
var _354={"IBAction":_344,"IBOutlet":_340,"unsigned":_34b,"signed":_34c,"byte":_34d,"char":_34e,"short":_34f,"int":_350,"long":_351};
var _355={"implementation":_33f,"outlet":_340,"accessors":_341,"end":_342,"import":_343,"action":_344,"selector":_345,"class":_346,"global":_347};
var _356={type:"[",beforeExpr:true},_357={type:"]"},_358={type:"{",beforeExpr:true};
var _359={type:"}"},_35a={type:"(",beforeExpr:true},_35b={type:")"};
var _35c={type:",",beforeExpr:true},_35d={type:";",beforeExpr:true};
var _35e={type:":",beforeExpr:true},_35f={type:"."},_360={type:"?",beforeExpr:true};
var _361={type:"@"},_362={type:"..."},_363={type:"#"};
var _364={binop:10,beforeExpr:true},_365={isAssign:true,beforeExpr:true};
var _366={isAssign:true,beforeExpr:true},_367={binop:9,prefix:true,beforeExpr:true};
var _368={postfix:true,prefix:true,isUpdate:true},_369={prefix:true,beforeExpr:true};
var _36a={binop:1,beforeExpr:true},_36b={binop:2,beforeExpr:true};
var _36c={binop:3,beforeExpr:true},_36d={binop:4,beforeExpr:true};
var _36e={binop:5,beforeExpr:true},_36f={binop:6,beforeExpr:true};
var _370={binop:7,beforeExpr:true},_371={binop:8,beforeExpr:true};
var _372={binop:10,beforeExpr:true};
function _373(_374){
_374=_374.split(" ");
var f="",cats=[];
out:
for(var i=0;i<_374.length;++i){
for(var j=0;j<cats.length;++j){
if(cats[j][0].length==_374[i].length){
cats[j].push(_374[i]);
continue out;
}
}
cats.push([_374[i]]);
}
function _375(arr){
if(arr.length==1){
return f+="return str === "+JSON.stringify(arr[0])+";";
}
f+="switch(str){";
for(var i=0;i<arr.length;++i){
f+="case "+JSON.stringify(arr[i])+":";
}
f+="return true}return false;";
};
if(cats.length>3){
cats.sort(function(a,b){
return b.length-a.length;
});
f+="switch(str.length){";
for(var i=0;i<cats.length;++i){
var cat=cats[i];
f+="case "+cat[0].length+":";
_375(cat);
}
f+="}";
}else{
_375(_374);
}
return new Function("str",f);
};
_2f6.makePredicate=_373;
var _376=_373("abstract boolean byte char class double enum export extends final float goto implements import int interface long native package private protected public short static super synchronized throws transient volatile");
var _377=_373("class enum extends super const export import");
var _378=_373("implements interface let package private protected public static yield");
var _379=_373("eval arguments");
var _37a=_373("break case catch continue debugger default do else finally for function if return switch throw try var while with null true false instanceof typeof void delete new in this");
var _37b=_373("IBAction IBOutlet byte char short int long unsigned signed");
var _37c=/[\u1680\u180e\u2000-\u200a\u2028\u2029\u202f\u205f\u3000\ufeff]/;
var _37d="ªµºÀ-ÖØ-öø-ˁˆ-ˑˠ-ˤˬˮͰ-ʹͶͷͺ-ͽΆΈ-ΊΌΎ-ΡΣ-ϵϷ-ҁҊ-ԧԱ-Ֆՙա-ևא-תװ-ײؠ-يٮٯٱ-ۓەۥۦۮۯۺ-ۼۿܐܒ-ܯݍ-ޥޱߊ-ߪߴߵߺࠀ-ࠕࠚࠤࠨࡀ-ࡘࢠࢢ-ࢬऄ-हऽॐक़-ॡॱ-ॷॹ-ॿঅ-ঌএঐও-নপ-রলশ-হঽৎড়ঢ়য়-ৡৰৱਅ-ਊਏਐਓ-ਨਪ-ਰਲਲ਼ਵਸ਼ਸਹਖ਼-ੜਫ਼ੲ-ੴઅ-ઍએ-ઑઓ-નપ-રલળવ-હઽૐૠૡଅ-ଌଏଐଓ-ନପ-ରଲଳଵ-ହଽଡ଼ଢ଼ୟ-ୡୱஃஅ-ஊஎ-ஐஒ-கஙசஜஞடணதந-பம-ஹௐఅ-ఌఎ-ఐఒ-నప-ళవ-హఽౘౙౠౡಅ-ಌಎ-ಐಒ-ನಪ-ಳವ-ಹಽೞೠೡೱೲഅ-ഌഎ-ഐഒ-ഺഽൎൠൡൺ-ൿඅ-ඖක-නඳ-රලව-ෆก-ะาำเ-ๆກຂຄງຈຊຍດ-ທນ-ຟມ-ຣລວສຫອ-ະາຳຽເ-ໄໆໜ-ໟༀཀ-ཇཉ-ཬྈ-ྌက-ဪဿၐ-ၕၚ-ၝၡၥၦၮ-ၰၵ-ႁႎႠ-ჅჇჍა-ჺჼ-ቈቊ-ቍቐ-ቖቘቚ-ቝበ-ኈኊ-ኍነ-ኰኲ-ኵኸ-ኾዀዂ-ዅወ-ዖዘ-ጐጒ-ጕጘ-ፚᎀ-ᎏᎠ-Ᏼᐁ-ᙬᙯ-ᙿᚁ-ᚚᚠ-ᛪᛮ-ᛰᜀ-ᜌᜎ-ᜑᜠ-ᜱᝀ-ᝑᝠ-ᝬᝮ-ᝰក-ឳៗៜᠠ-ᡷᢀ-ᢨᢪᢰ-ᣵᤀ-ᤜᥐ-ᥭᥰ-ᥴᦀ-ᦫᧁ-ᧇᨀ-ᨖᨠ-ᩔᪧᬅ-ᬳᭅ-ᭋᮃ-ᮠᮮᮯᮺ-ᯥᰀ-ᰣᱍ-ᱏᱚ-ᱽᳩ-ᳬᳮ-ᳱᳵᳶᴀ-ᶿḀ-ἕἘ-Ἕἠ-ὅὈ-Ὅὐ-ὗὙὛὝὟ-ώᾀ-ᾴᾶ-ᾼιῂ-ῄῆ-ῌῐ-ΐῖ-Ίῠ-Ῥῲ-ῴῶ-ῼⁱⁿₐ-ₜℂℇℊ-ℓℕℙ-ℝℤΩℨK-ℭℯ-ℹℼ-ℿⅅ-ⅉⅎⅠ-ↈⰀ-Ⱞⰰ-ⱞⱠ-ⳤⳫ-ⳮⳲⳳⴀ-ⴥⴧⴭⴰ-ⵧⵯⶀ-ⶖⶠ-ⶦⶨ-ⶮⶰ-ⶶⶸ-ⶾⷀ-ⷆⷈ-ⷎⷐ-ⷖⷘ-ⷞⸯ々-〇〡-〩〱-〵〸-〼ぁ-ゖゝ-ゟァ-ヺー-ヿㄅ-ㄭㄱ-ㆎㆠ-ㆺㇰ-ㇿ㐀-䶵一-鿌ꀀ-ꒌꓐ-ꓽꔀ-ꘌꘐ-ꘟꘪꘫꙀ-ꙮꙿ-ꚗꚠ-ꛯꜗ-ꜟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꠁꠃ-ꠅꠇ-ꠊꠌ-ꠢꡀ-ꡳꢂ-ꢳꣲ-ꣷꣻꤊ-ꤥꤰ-ꥆꥠ-ꥼꦄ-ꦲꧏꨀ-ꨨꩀ-ꩂꩄ-ꩋꩠ-ꩶꩺꪀ-ꪯꪱꪵꪶꪹ-ꪽꫀꫂꫛ-ꫝꫠ-ꫪꫲ-ꫴꬁ-ꬆꬉ-ꬎꬑ-ꬖꬠ-ꬦꬨ-ꬮꯀ-ꯢ가-힣ힰ-ퟆퟋ-ퟻ豈-舘並-龎ﬀ-ﬆﬓ-ﬗיִײַ-ﬨשׁ-זּטּ-לּמּנּסּףּפּצּ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼＡ-Ｚａ-ｚｦ-ﾾￂ-ￇￊ-ￏￒ-ￗￚ-ￜ";
var _37e="ͱ-ʹ҃-֑҇-ׇֽֿׁׂׅׄؐ-ؚؠ-ىٲ-ۓۧ-ۨۻ-ۼܰ-݊ࠀ-ࠔࠛ-ࠣࠥ-ࠧࠩ-࠭ࡀ-ࡗࣤ-ࣾऀ-ःऺ-़ा-ॏ॑-ॗॢ-ॣ०-९ঁ-ঃ়া-ৄেৈৗয়-ৠਁ-ਃ਼ਾ-ੂੇੈੋ-੍ੑ੦-ੱੵઁ-ઃ઼ા-ૅે-ૉો-્ૢ-ૣ૦-૯ଁ-ଃ଼ା-ୄେୈୋ-୍ୖୗୟ-ୠ୦-୯ஂா-ூெ-ைொ-்ௗ௦-௯ఁ-ఃె-ైొ-్ౕౖౢ-ౣ౦-౯ಂಃ಼ಾ-ೄೆ-ೈೊ-್ೕೖೢ-ೣ೦-೯ംഃെ-ൈൗൢ-ൣ൦-൯ංඃ්ා-ුූෘ-ෟෲෳิ-ฺเ-ๅ๐-๙ິ-ູ່-ໍ໐-໙༘༙༠-༩༹༵༷ཁ-ཇཱ-྄྆-྇ྍ-ྗྙ-ྼ࿆က-ဩ၀-၉ၧ-ၭၱ-ၴႂ-ႍႏ-ႝ፝-፟ᜎ-ᜐᜠ-ᜰᝀ-ᝐᝲᝳក-ឲ៝០-៩᠋-᠍᠐-᠙ᤠ-ᤫᤰ-᤻ᥑ-ᥭᦰ-ᧀᧈ-ᧉ᧐-᧙ᨀ-ᨕᨠ-ᩓ᩠-᩿᩼-᪉᪐-᪙ᭆ-ᭋ᭐-᭙᭫-᭳᮰-᮹᯦-᯳ᰀ-ᰢ᱀-᱉ᱛ-ᱽ᳐-᳒ᴀ-ᶾḁ-ἕ‌‍‿⁀⁔⃐-⃥⃜⃡-⃰ⶁ-ⶖⷠ-ⷿ〡-〨゙゚Ꙁ-ꙭꙴ-꙽ꚟ꛰-꛱ꟸ-ꠀ꠆ꠋꠣ-ꠧꢀ-ꢁꢴ-꣄꣐-꣙ꣳ-ꣷ꤀-꤉ꤦ-꤭ꤰ-ꥅꦀ-ꦃ꦳-꧀ꨀ-ꨧꩀ-ꩁꩌ-ꩍ꩐-꩙ꩻꫠ-ꫩꫲ-ꫳꯀ-ꯡ꯬꯭꯰-꯹ﬠ-ﬨ︀-️︠-︦︳︴﹍-﹏０-９＿";
var _37f=new RegExp("["+_37d+"]");
var _380=new RegExp("["+_37d+_37e+"]");
var _381=/[\n\r\u2028\u2029]/;
var _300=/\r\n|[\n\r\u2028\u2029]/g;
function _382(code){
if(code<65){
return code===36;
}
if(code<91){
return true;
}
if(code<97){
return code===95;
}
if(code<123){
return true;
}
return code>=170&&_37f.test(String.fromCharCode(code));
};
function _383(code){
if(code<48){
return code===36;
}
if(code<58){
return true;
}
if(code<65){
return false;
}
if(code<91){
return true;
}
if(code<97){
return code===95;
}
if(code<123){
return true;
}
return code>=170&&_380.test(String.fromCharCode(code));
};
function _384(){
_300.lastIndex=_313;
var _385=_300.exec(_2f8);
return _385?_385.index+_385[0].length:_2f8.length+1;
};
var _386=function(){
this.line=_312;
this.column=_302-_313;
};
function _387(){
while(_314<=_302){
++_312;
_313=_314;
_314=_384();
}
return new _386();
};
function _388(){
_312=1;
_302=_313=0;
_314=_384();
_30f=true;
_310=null;
_311=null;
_389();
};
function _38a(type,val){
_304=_302;
if(_2f7.locations){
_306=_387();
}
_307=type;
_389();
_308=val;
_30b=_30a;
_30e=_30d;
_30a=_310;
_30d=_311;
_30f=type.beforeExpr;
_318=type.afterImport;
};
function _38b(){
var end=_2f8.indexOf("*/",_302+=2);
if(end===-1){
_31d(_302-2,"Unterminated comment");
}
if(_2f7.trackComments){
(_310||(_310=[])).push(_2f8.slice(_302,end));
}
_302=end+2;
};
function _38c(_38d){
var _38e=_302;
var ch=_2f8.charCodeAt(_302+=_38d);
while(_302<_2f9&&ch!==10&&ch!==13&&ch!==8232&&ch!==8329){
++_302;
ch=_2f8.charCodeAt(_302);
}
if(_2f7.trackComments){
(_310||(_310=[])).push(_2f8.slice(_38e,_302));
}
};
function _38f(){
var _390=_302;
var ch=_2f8.charCodeAt(++_302);
while((ch<14&&ch>8)||ch===32||ch===160||(ch>=5760&&_37c.test(String.fromCharCode(ch)))){
ch=_2f8.charCodeAt(++_302);
}
if(_2f7.trackSpaces){
(_311||(_311=[])).push(_2f8.slice(_390,_302));
}
};
function _389(){
_310=null;
_311=null;
while(_302<_2f9){
var ch=_2f8.charCodeAt(_302);
if(ch===47){
var next=_2f8.charCodeAt(_302+1);
if(next===42){
_38b();
}else{
if(next===47){
_38c(2);
}else{
break;
}
}
}else{
if((ch<14&&ch>8)||ch===32||ch===160||(ch>=5760&&_37c.test(String.fromCharCode(ch)))){
_38f();
}else{
break;
}
}
}
};
function _391(code){
var next=_2f8.charCodeAt(_302+1);
if(next>=48&&next<=57){
return _392(String.fromCharCode(code));
}
if(next===46&&_2f7.objj&&_2f8.charCodeAt(_302+2)===46){
_302+=3;
return _38a(_362);
}
++_302;
return _38a(_35f);
};
function _393(){
var next=_2f8.charCodeAt(_302+1);
if(_30f){
++_302;
return _394();
}
if(next===61){
return _395(_366,2);
}
return _395(_364,1);
};
function _396(){
var next=_2f8.charCodeAt(_302+1);
if(next===61){
return _395(_366,2);
}
return _395(_372,1);
};
function _397(code){
var next=_2f8.charCodeAt(_302+1);
if(next===code){
return _395(code===124?_36a:_36b,2);
}
if(next===61){
return _395(_366,2);
}
return _395(code===124?_36c:_36e,1);
};
function _398(){
var next=_2f8.charCodeAt(_302+1);
if(next===61){
return _395(_366,2);
}
return _395(_36d,1);
};
function _399(code){
var next=_2f8.charCodeAt(_302+1);
if(next===code){
return _395(_368,2);
}
if(next===61){
return _395(_366,2);
}
return _395(_367,1);
};
function _39a(code){
if(_318&&_2f7.objj&&code===60){
var str=[];
for(;;){
if(_302>=_2f9){
_31d(_303,"Unterminated import statement");
}
var ch=_2f8.charCodeAt(++_302);
if(ch===62){
++_302;
return _38a(_34a,String.fromCharCode.apply(null,str));
}
str.push(ch);
}
}
var next=_2f8.charCodeAt(_302+1);
var size=1;
if(next===code){
size=code===62&&_2f8.charCodeAt(_302+2)===62?3:2;
if(_2f8.charCodeAt(_302+size)===61){
return _395(_366,size+1);
}
return _395(_371,size);
}
if(next===61){
size=_2f8.charCodeAt(_302+2)===61?3:2;
}
return _395(_370,size);
};
function _39b(code){
var next=_2f8.charCodeAt(_302+1);
if(next===61){
return _395(_36f,_2f8.charCodeAt(_302+2)===61?3:2);
}
return _395(code===61?_365:_369,1);
};
function _39c(code){
var next=_2f8.charCodeAt(++_302);
if(next===34||next===39){
return _39d(next);
}
if(next===123){
return _38a(_348);
}
if(next===91){
return _38a(_349);
}
var word=_39e(),_39f=_355[word];
if(!_39f){
_31d(_303,"Unrecognized Objective-J keyword '@"+word+"'");
}
return _38a(_39f);
};
function _3a0(code){
switch(code){
case 46:
return _391(code);
case 40:
++_302;
return _38a(_35a);
case 41:
++_302;
return _38a(_35b);
case 59:
++_302;
return _38a(_35d);
case 44:
++_302;
return _38a(_35c);
case 91:
++_302;
return _38a(_356);
case 93:
++_302;
return _38a(_357);
case 123:
++_302;
return _38a(_358);
case 125:
++_302;
return _38a(_359);
case 58:
++_302;
return _38a(_35e);
case 63:
++_302;
return _38a(_360);
case 48:
var next=_2f8.charCodeAt(_302+1);
if(next===120||next===88){
return _3a1();
}
case 49:
case 50:
case 51:
case 52:
case 53:
case 54:
case 55:
case 56:
case 57:
return _392(String.fromCharCode(code));
case 34:
case 39:
return _39d(code);
case 47:
return _393(code);
case 37:
case 42:
return _396();
case 124:
case 38:
return _397(code);
case 94:
return _398();
case 43:
case 45:
return _399(code);
case 60:
case 62:
return _39a(code);
case 61:
case 33:
return _39b(code);
case 64:
if(_2f7.objj){
return _39c(code);
}
return false;
case 35:
if(_2f7.objj){
var _3a2=_302;
var ch=_2f8.charCodeAt(++_302);
while(_302<_2f9&&ch!==10&&ch!==13&&ch!==8232&&ch!==8329){
ch=_2f8.charCodeAt(++_302);
}
return _38a(_352,_2f8.slice(_3a2,_302));
}
return false;
case 126:
return _395(_369,1);
}
return false;
};
function _3a3(_3a4){
_303=_302;
if(_2f7.locations){
_305=_387();
}
_309=_310;
_30c=_311;
if(_3a4){
return _394();
}
if(_302>=_2f9){
return _38a(_324);
}
var code=_2f8.charCodeAt(_302);
if(_382(code)||code===92){
return _3a5();
}
var tok=_3a0(code);
if(tok===false){
var ch=String.fromCharCode(code);
if(ch==="\\"||_37f.test(ch)){
return _3a5();
}
_31d(_302,"Unexpected character '"+ch+"'");
}
return tok;
};
function _395(type,size){
var str=_2f8.slice(_302,_302+size);
_302+=size;
_38a(type,str);
};
function _394(){
var _3a6="",_3a7,_3a8,_3a9=_302;
for(;;){
if(_302>=_2f9){
_31d(_3a9,"Unterminated regular expression");
}
var ch=_2f8.charAt(_302);
if(_381.test(ch)){
_31d(_3a9,"Unterminated regular expression");
}
if(!_3a7){
if(ch==="["){
_3a8=true;
}else{
if(ch==="]"&&_3a8){
_3a8=false;
}else{
if(ch==="/"&&!_3a8){
break;
}
}
}
_3a7=ch==="\\";
}else{
_3a7=false;
}
++_302;
}
var _3a6=_2f8.slice(_3a9,_302);
++_302;
var mods=_39e();
if(mods&&!/^[gmsiy]*$/.test(mods)){
_31d(_3a9,"Invalid regexp flag");
}
return _38a(_321,new RegExp(_3a6,mods));
};
function _3aa(_3ab,len){
var _3ac=_302,_3ad=0;
for(var i=0,e=len==null?Infinity:len;i<e;++i){
var code=_2f8.charCodeAt(_302),val;
if(code>=97){
val=code-97+10;
}else{
if(code>=65){
val=code-65+10;
}else{
if(code>=48&&code<=57){
val=code-48;
}else{
val=Infinity;
}
}
}
if(val>=_3ab){
break;
}
++_302;
_3ad=_3ad*_3ab+val;
}
if(_302===_3ac||len!=null&&_302-_3ac!==len){
return null;
}
return _3ad;
};
function _3a1(){
_302+=2;
var val=_3aa(16);
if(val==null){
_31d(_303+2,"Expected hexadecimal number");
}
if(_382(_2f8.charCodeAt(_302))){
_31d(_302,"Identifier directly after number");
}
return _38a(_320,val);
};
function _392(ch){
var _3ae=_302,_3af=ch===".";
if(!_3af&&_3aa(10)==null){
_31d(_3ae,"Invalid number");
}
if(_3af||_2f8.charAt(_302)==="."){
var next=_2f8.charAt(++_302);
if(next==="-"||next==="+"){
++_302;
}
if(_3aa(10)===null&&ch==="."){
_31d(_3ae,"Invalid number");
}
_3af=true;
}
if(/e/i.test(_2f8.charAt(_302))){
var next=_2f8.charAt(++_302);
if(next==="-"||next==="+"){
++_302;
}
if(_3aa(10)===null){
_31d(_3ae,"Invalid number");
}
_3af=true;
}
if(_382(_2f8.charCodeAt(_302))){
_31d(_302,"Identifier directly after number");
}
var str=_2f8.slice(_3ae,_302),val;
if(_3af){
val=parseFloat(str);
}else{
if(ch!=="0"||str.length===1){
val=parseInt(str,10);
}else{
if(/[89]/.test(str)||_31c){
_31d(_3ae,"Invalid number");
}else{
val=parseInt(str,8);
}
}
}
return _38a(_320,val);
};
var _3b0=[];
function _39d(_3b1){
_302++;
_3b0.length=0;
for(;;){
if(_302>=_2f9){
_31d(_303,"Unterminated string constant");
}
var ch=_2f8.charCodeAt(_302);
if(ch===_3b1){
++_302;
return _38a(_322,String.fromCharCode.apply(null,_3b0));
}
if(ch===92){
ch=_2f8.charCodeAt(++_302);
var _3b2=/^[0-7]+/.exec(_2f8.slice(_302,_302+3));
if(_3b2){
_3b2=_3b2[0];
}
while(_3b2&&parseInt(_3b2,8)>255){
_3b2=_3b2.slice(0,_3b2.length-1);
}
if(_3b2==="0"){
_3b2=null;
}
++_302;
if(_3b2){
if(_31c){
_31d(_302-2,"Octal literal in strict mode");
}
_3b0.push(parseInt(_3b2,8));
_302+=_3b2.length-1;
}else{
switch(ch){
case 110:
_3b0.push(10);
break;
case 114:
_3b0.push(13);
break;
case 120:
_3b0.push(_3b3(2));
break;
case 117:
_3b0.push(_3b3(4));
break;
case 85:
_3b0.push(_3b3(8));
break;
case 116:
_3b0.push(9);
break;
case 98:
_3b0.push(8);
break;
case 118:
_3b0.push(11);
break;
case 102:
_3b0.push(12);
break;
case 48:
_3b0.push(0);
break;
case 13:
if(_2f8.charCodeAt(_302)===10){
++_302;
}
case 10:
break;
default:
_3b0.push(ch);
break;
}
}
}else{
if(ch===13||ch===10||ch===8232||ch===8329){
_31d(_303,"Unterminated string constant");
}
if(ch!==92){
_3b0.push(ch);
}
++_302;
}
}
};
function _3b3(len){
var n=_3aa(16,len);
if(n===null){
_31d(_303,"Bad character escape sequence");
}
return n;
};
var _3b4;
function _39e(){
_3b4=false;
var word,_3b5=true,_3b6=_302;
for(;;){
var ch=_2f8.charCodeAt(_302);
if(_383(ch)){
if(_3b4){
word+=_2f8.charAt(_302);
}
++_302;
}else{
if(ch===92){
if(!_3b4){
word=_2f8.slice(_3b6,_302);
}
_3b4=true;
if(_2f8.charCodeAt(++_302)!=117){
_31d(_302,"Expecting Unicode escape sequence \\uXXXX");
}
++_302;
var esc=_3b3(4);
var _3b7=String.fromCharCode(esc);
if(!_3b7){
_31d(_302-1,"Invalid Unicode escape");
}
if(!(_3b5?_382(esc):_383(esc))){
_31d(_302-4,"Invalid Unicode escape");
}
word+=_3b7;
}else{
break;
}
}
_3b5=false;
}
return _3b4?word:_2f8.slice(_3b6,_302);
};
function _3a5(){
var word=_39e();
var type=_323;
if(!_3b4){
if(_37a(word)){
type=_353[word];
}else{
if(_2f7.objj&&_37b(word)){
type=_354[word];
}else{
if(_2f7.forbidReserved&&(_2f7.ecmaVersion===3?_376:_377)(word)||_31c&&_378(word)){
_31d(_303,"The keyword '"+word+"' is reserved");
}
}
}
}
return _38a(type,word);
};
function next(){
_315=_303;
_316=_304;
_317=_306;
_319=null;
_3a3();
};
function _3b8(_3b9){
_31c=_3b9;
_302=_316;
_389();
_3a3();
};
var _3ba=function(s){
this.type=null;
this.start=_303;
this.end=null;
};
var _3bb=function(s){
this.start=_305;
this.end=null;
if(_2fa!==null){
this.source=_2fa;
}
};
function _3bc(){
var node=new _3ba();
if(_2f7.trackComments&&_309){
node.commentsBefore=_309;
_309=null;
}
if(_2f7.trackSpaces&&_30c){
node.spacesBefore=_30c;
_30c=null;
}
if(_2f7.locations){
node.loc=new _3bb();
}
if(_2f7.ranges){
node.range=[_303,0];
}
return node;
};
function _3bd(_3be){
var node=new _3ba();
node.start=_3be.start;
if(_3be.commentsBefore){
node.commentsBefore=_3be.commentsBefore;
delete _3be.commentsBefore;
}
if(_3be.spacesBefore){
node.spacesBefore=_3be.spacesBefore;
delete _3be.spacesBefore;
}
if(_2f7.locations){
node.loc=new _3bb();
node.loc.start=_3be.loc.start;
}
if(_2f7.ranges){
node.range=[_3be.range[0],0];
}
return node;
};
var _3bf;
function _3c0(node,type){
node.type=type;
node.end=_316;
if(_2f7.trackComments){
if(_30b){
node.commentsAfter=_30b;
_30a=null;
}else{
if(_3bf&&_3bf.end===_316&&_3bf.commentsAfter){
node.commentsAfter=_3bf.commentsAfter;
delete _3bf.commentsAfter;
}
}
if(!_2f7.trackSpaces){
_3bf=node;
}
}
if(_2f7.trackSpaces){
if(_30e){
node.spacesAfter=_30e;
_30e=null;
}else{
if(_3bf&&_3bf.end===_316&&_3bf.spacesAfter){
node.spacesAfter=_3bf.spacesAfter;
delete _3bf.spacesAfter;
}
}
_3bf=node;
}
if(_2f7.locations){
node.loc.end=_317;
}
if(_2f7.ranges){
node.range[1]=_316;
}
return node;
};
function _3c1(stmt){
return _2f7.ecmaVersion>=5&&stmt.type==="ExpressionStatement"&&stmt.expression.type==="Literal"&&stmt.expression.value==="use strict";
};
function eat(type){
if(_307===type){
next();
return true;
}
};
function _3c2(){
return !_2f7.strictSemicolons&&(_307===_324||_307===_359||_381.test(_2f8.slice(_316,_303))||(_319&&_2f7.objj));
};
function _3c3(){
if(!eat(_35d)&&!_3c2()){
_31d(_316,"Expected a semicolon");
}
};
function _3c4(type,_3c5){
if(_307===type){
next();
}else{
_3c5?_31d(_303,_3c5):_3c6();
}
};
function _3c6(){
_31d(_303,"Unexpected token");
};
function _3c7(expr){
if(expr.type!=="Identifier"&&expr.type!=="MemberExpression"){
_31d(expr.start,"Assigning to rvalue");
}
if(_31c&&expr.type==="Identifier"&&_379(expr.name)){
_31d(expr.start,"Assigning to "+expr.name+" in strict mode");
}
};
function _2fc(_3c8){
_388();
_315=_316=_302;
if(_2f7.locations){
_317=_387();
}
_31a=_31c=null;
_31b=[];
_3a3();
var node=_3c8||_3bc(),_3c9=true;
if(!_3c8){
node.body=[];
}
while(_307!==_324){
var stmt=_3ca();
node.body.push(stmt);
if(_3c9&&_3c1(stmt)){
_3b8(true);
}
_3c9=false;
}
return _3c0(node,"Program");
};
var _3cb={kind:"loop"},_3cc={kind:"switch"};
function _3ca(){
if(_319){
return _3cd(_319,_319.object);
}
if(_307===_364){
_3a3(true);
}
var _3ce=_307,node=_3bc();
switch(_3ce){
case _325:
case _328:
next();
var _3cf=_3ce===_325;
if(eat(_35d)||_3c2()){
node.label=null;
}else{
if(_307!==_323){
_3c6();
}else{
node.label=_3d0();
_3c3();
}
}
for(var i=0;i<_31b.length;++i){
var lab=_31b[i];
if(node.label==null||lab.name===node.label.name){
if(lab.kind!=null&&(_3cf||lab.kind==="loop")){
break;
}
if(node.label&&_3cf){
break;
}
}
}
if(i===_31b.length){
_31d(node.start,"Unsyntactic "+_3ce.keyword);
}
return _3c0(node,_3cf?"BreakStatement":"ContinueStatement");
case _329:
next();
_3c3();
return _3c0(node,"DebuggerStatement");
case _32b:
next();
_31b.push(_3cb);
node.body=_3ca();
_31b.pop();
_3c4(_336,"Expected 'while' at end of do statement");
node.test=_3d1();
_3c3();
return _3c0(node,"DoWhileStatement");
case _32e:
next();
_31b.push(_3cb);
_3c4(_35a,"Expected '(' after 'for'");
if(_307===_35d){
return _3d2(node,null);
}
if(_307===_335){
var init=_3bc();
next();
_3d3(init,true);
if(init.declarations.length===1&&eat(_33e)){
return _3d4(node,init);
}
return _3d2(node,init);
}
var init=_3d5(false,true);
if(eat(_33e)){
_3c7(init);
return _3d4(node,init);
}
return _3d2(node,init);
case _32f:
next();
return _3d6(node,true);
case _330:
next();
node.test=_3d1();
node.consequent=_3ca();
node.alternate=eat(_32c)?_3ca():null;
return _3c0(node,"IfStatement");
case _331:
if(!_31a){
_31d(_303,"'return' outside of function");
}
next();
if(eat(_35d)||_3c2()){
node.argument=null;
}else{
node.argument=_3d5();
_3c3();
}
return _3c0(node,"ReturnStatement");
case _332:
next();
node.discriminant=_3d1();
node.cases=[];
_3c4(_358,"Expected '{' in switch statement");
_31b.push(_3cc);
for(var cur,_3d7;_307!=_359;){
if(_307===_326||_307===_32a){
var _3d8=_307===_326;
if(cur){
_3c0(cur,"SwitchCase");
}
node.cases.push(cur=_3bc());
cur.consequent=[];
next();
if(_3d8){
cur.test=_3d5();
}else{
if(_3d7){
_31d(_315,"Multiple default clauses");
}
_3d7=true;
cur.test=null;
}
_3c4(_35e,"Expected ':' after case clause");
}else{
if(!cur){
_3c6();
}
cur.consequent.push(_3ca());
}
}
if(cur){
_3c0(cur,"SwitchCase");
}
next();
_31b.pop();
return _3c0(node,"SwitchStatement");
case _333:
next();
if(_381.test(_2f8.slice(_316,_303))){
_31d(_316,"Illegal newline after throw");
}
node.argument=_3d5();
_3c3();
return _3c0(node,"ThrowStatement");
case _334:
next();
node.block=_3d9();
node.handlers=[];
while(_307===_327){
var _3da=_3bc();
next();
_3c4(_35a,"Expected '(' after 'catch'");
_3da.param=_3d0();
if(_31c&&_379(_3da.param.name)){
_31d(_3da.param.start,"Binding "+_3da.param.name+" in strict mode");
}
_3c4(_35b,"Expected closing ')' after catch");
_3da.guard=null;
_3da.body=_3d9();
node.handlers.push(_3c0(_3da,"CatchClause"));
}
node.finalizer=eat(_32d)?_3d9():null;
if(!node.handlers.length&&!node.finalizer){
_31d(node.start,"Missing catch or finally clause");
}
return _3c0(node,"TryStatement");
case _335:
next();
node=_3d3(node);
_3c3();
return node;
case _336:
next();
node.test=_3d1();
_31b.push(_3cb);
node.body=_3ca();
_31b.pop();
return _3c0(node,"WhileStatement");
case _337:
if(_31c){
_31d(_303,"'with' in strict mode");
}
next();
node.object=_3d1();
node.body=_3ca();
return _3c0(node,"WithStatement");
case _358:
return _3d9();
case _35d:
next();
return _3c0(node,"EmptyStatement");
case _33f:
if(_2f7.objj){
next();
node.classname=_3d0(true);
if(eat(_35e)){
node.superclassname=_3d0(true);
}else{
if(eat(_35a)){
node.categoryname=_3d0(true);
_3c4(_35b,"Expected closing ')' after category name");
}
}
if(eat(_358)){
node.ivardeclarations=[];
for(;;){
if(eat(_359)){
break;
}
_3db(node);
}
node.endOfIvars=_303;
}
node.body=[];
while(!eat(_342)){
if(_307===_324){
_31d(_302,"Expected '@end' after '@implementation'");
}
node.body.push(_3dc());
}
}
return _3c0(node,"ClassDeclarationStatement");
case _343:
next();
if(_307===_322){
node.localfilepath=true;
}else{
if(_307===_34a){
node.localfilepath=false;
}else{
_3c6();
}
}
node.filename=_3dd();
return _3c0(node,"ImportStatement");
case _352:
next();
return _3c0(node,"PreprocessStatement");
case _346:
next();
node.id=_3d0(false);
return _3c0(node,"ClassStatement");
case _347:
next();
node.id=_3d0(false);
return _3c0(node,"GlobalStatement");
default:
var _3de=_308,expr=_3d5();
if(_3ce===_323&&expr.type==="Identifier"&&eat(_35e)){
for(var i=0;i<_31b.length;++i){
if(_31b[i].name===_3de){
_31d(expr.start,"Label '"+_3de+"' is already declared");
}
}
var kind=_307.isLoop?"loop":_307===_332?"switch":null;
_31b.push({name:_3de,kind:kind});
node.body=_3ca();
_31b.pop();
node.label=expr;
return _3c0(node,"LabeledStatement");
}else{
node.expression=expr;
_3c3();
return _3c0(node,"ExpressionStatement");
}
}
};
function _3db(node){
var _3df;
if(eat(_340)){
_3df=true;
}
var type=_3e0();
if(_31c&&_379(type.name)){
_31d(type.start,"Binding "+type.name+" in strict mode");
}
for(;;){
var decl=_3bc();
if(_3df){
decl.outlet=_3df;
}
decl.ivartype=type;
decl.id=_3d0();
if(_31c&&_379(decl.id.name)){
_31d(decl.id.start,"Binding "+decl.id.name+" in strict mode");
}
if(eat(_341)){
decl.accessors={};
if(eat(_35a)){
if(!eat(_35b)){
for(;;){
var _3e1=_3d0(true);
switch(_3e1.name){
case "property":
case "getter":
_3c4(_365,"Expected '=' after 'getter' accessor attribute");
decl.accessors[_3e1.name]=_3d0(true);
break;
case "setter":
_3c4(_365,"Expected '=' after 'setter' accessor attribute");
var _3e2=_3d0(true);
decl.accessors[_3e1.name]=_3e2;
if(eat(_35e)){
_3e2.end=_303;
}
_3e2.name+=":";
break;
case "readwrite":
case "readonly":
case "copy":
decl.accessors[_3e1.name]=true;
break;
default:
_31d(_3e1.start,"Unknown accessors attribute '"+_3e1.name+"'");
}
if(!eat(_35c)){
break;
}
}
_3c4(_35b,"Expected closing ')' after accessor attributes");
}
}
}
_3c0(decl,"IvarDeclaration");
node.ivardeclarations.push(decl);
if(!eat(_35c)){
break;
}
}
_3c3();
};
function _3dc(){
var _3e3=_308,_3e4=_3bc();
if(eat(_367)){
_3e4.methodtype=_3e3;
if(eat(_35a)){
if(eat(_344)){
_3e4.action=true;
}
if(!eat(_35b)){
_3e4.returntype=_3e0();
_3c4(_35b,"Expected closing ')' after method return type");
}
}
var _3e5=true,_3e6=[],args=[];
_3e4.selectors=_3e6;
_3e4.arguments=args;
for(;;){
if(_307!==_35e){
_3e6.push(_3d0(true));
if(_3e5&&_307!==_35e){
break;
}
}else{
_3e6.push(null);
}
_3c4(_35e,"Expected ':' in selector");
var _3e7={};
args.push(_3e7);
if(eat(_35a)){
_3e7.type=_3e0();
_3c4(_35b,"Expected closing ')' after method argument type");
}
_3e7.identifier=_3d0(false);
if(_307===_358||eat(_35d)){
break;
}
if(eat(_35c)){
_3c4(_362,"Expected '...' after ',' in method declaration");
_3e4.parameters=true;
break;
}
_3e5=false;
}
_3e4.startOfBody=_316;
var _3e8=_31a,_3e9=_31b;
_31a=true;
_31b=[];
_3e4.body=_3d9(true);
_31a=_3e8;
_31b=_3e9;
return _3c0(_3e4,"MethodDeclarationStatement");
}else{
return _3ca();
}
};
function _3d1(){
_3c4(_35a,"Expected '(' before expression");
var val=_3d5();
_3c4(_35b,"Expected closing ')' after expression");
return val;
};
function _3d9(_3ea){
var node=_3bc(),_3eb=true,_31c=false,_3ec;
node.body=[];
_3c4(_358,"Expected '{' before block");
while(!eat(_359)){
var stmt=_3ca();
node.body.push(stmt);
if(_3eb&&_3c1(stmt)){
_3ec=_31c;
_3b8(_31c=true);
}
_3eb=false;
}
if(_31c&&!_3ec){
_3b8(false);
}
return _3c0(node,"BlockStatement");
};
function _3d2(node,init){
node.init=init;
_3c4(_35d,"Expected ';' in for statement");
node.test=_307===_35d?null:_3d5();
_3c4(_35d,"Expected ';' in for statement");
node.update=_307===_35b?null:_3d5();
_3c4(_35b,"Expected closing ')' in for statement");
node.body=_3ca();
_31b.pop();
return _3c0(node,"ForStatement");
};
function _3d4(node,init){
node.left=init;
node.right=_3d5();
_3c4(_35b,"Expected closing ')' in for statement");
node.body=_3ca();
_31b.pop();
return _3c0(node,"ForInStatement");
};
function _3d3(node,noIn){
node.declarations=[];
node.kind="var";
for(;;){
var decl=_3bc();
decl.id=_3d0();
if(_31c&&_379(decl.id.name)){
_31d(decl.id.start,"Binding "+decl.id.name+" in strict mode");
}
decl.init=eat(_365)?_3d5(true,noIn):null;
node.declarations.push(_3c0(decl,"VariableDeclarator"));
if(!eat(_35c)){
break;
}
}
return _3c0(node,"VariableDeclaration");
};
function _3d5(_3ed,noIn){
var expr=_3ee(noIn);
if(!_3ed&&_307===_35c){
var node=_3bd(expr);
node.expressions=[expr];
while(eat(_35c)){
node.expressions.push(_3ee(noIn));
}
return _3c0(node,"SequenceExpression");
}
return expr;
};
function _3ee(noIn){
var left=_3ef(noIn);
if(_307.isAssign){
var node=_3bd(left);
node.operator=_308;
node.left=left;
next();
node.right=_3ee(noIn);
_3c7(left);
return _3c0(node,"AssignmentExpression");
}
return left;
};
function _3ef(noIn){
var expr=_3f0(noIn);
if(eat(_360)){
var node=_3bd(expr);
node.test=expr;
node.consequent=_3d5(true);
_3c4(_35e,"Expected ':' in conditional expression");
node.alternate=_3d5(true,noIn);
return _3c0(node,"ConditionalExpression");
}
return expr;
};
function _3f0(noIn){
return _3f1(_3f2(noIn),-1,noIn);
};
function _3f1(left,_3f3,noIn){
var prec=_307.binop;
if(prec!=null&&(!noIn||_307!==_33e)){
if(prec>_3f3){
var node=_3bd(left);
node.left=left;
node.operator=_308;
next();
node.right=_3f1(_3f2(noIn),prec,noIn);
var node=_3c0(node,/&&|\|\|/.test(node.operator)?"LogicalExpression":"BinaryExpression");
return _3f1(node,_3f3,noIn);
}
}
return left;
};
function _3f2(noIn){
if(_307.prefix){
var node=_3bc(),_3f4=_307.isUpdate;
node.operator=_308;
node.prefix=true;
next();
node.argument=_3f2(noIn);
if(_3f4){
_3c7(node.argument);
}else{
if(_31c&&node.operator==="delete"&&node.argument.type==="Identifier"){
_31d(node.start,"Deleting local variable in strict mode");
}
}
return _3c0(node,_3f4?"UpdateExpression":"UnaryExpression");
}
var expr=_3f5();
while(_307.postfix&&!_3c2()){
var node=_3bd(expr);
node.operator=_308;
node.prefix=false;
node.argument=expr;
_3c7(expr);
next();
expr=_3c0(node,"UpdateExpression");
}
return expr;
};
function _3f5(){
return _3f6(_3f7());
};
function _3f6(base,_3f8){
if(eat(_35f)){
var node=_3bd(base);
node.object=base;
node.property=_3d0(true);
node.computed=false;
return _3f6(_3c0(node,"MemberExpression"),_3f8);
}else{
if(_2f7.objj){
var _3f9=_3bc();
}
if(eat(_356)){
var expr=_3d5();
if(_2f7.objj&&_307!==_357){
_3f9.object=expr;
_319=_3f9;
return base;
}
var node=_3bd(base);
node.object=base;
node.property=expr;
node.computed=true;
_3c4(_357,"Expected closing ']' in subscript");
return _3f6(_3c0(node,"MemberExpression"),_3f8);
}else{
if(!_3f8&&eat(_35a)){
var node=_3bd(base);
node.callee=base;
node.arguments=_3fa(_35b,_307===_35b?null:_3d5(true),false);
return _3f6(_3c0(node,"CallExpression"),_3f8);
}
}
}
return base;
};
function _3f7(){
switch(_307){
case _339:
var node=_3bc();
next();
return _3c0(node,"ThisExpression");
case _323:
return _3d0();
case _320:
case _322:
case _321:
return _3dd();
case _33b:
case _33c:
case _33d:
var node=_3bc();
node.value=_307.atomValue;
node.raw=_307.keyword;
next();
return _3c0(node,"Literal");
case _35a:
var _3fb=_305,_3fc=_303;
next();
var val=_3d5();
val.start=_3fc;
val.end=_304;
if(_2f7.locations){
val.loc.start=_3fb;
val.loc.end=_306;
}
if(_2f7.ranges){
val.range=[_3fc,_304];
}
_3c4(_35b,"Expected closing ')' in expression");
return val;
case _349:
var node=_3bc(),_3fd=null;
next();
_3c4(_356,"Expected '[' at beginning of array literal");
if(_307!==_357){
_3fd=_3d5(true,true);
}
node.elements=_3fa(_357,_3fd,true,true);
return _3c0(node,"ArrayLiteral");
case _356:
var node=_3bc(),_3fd=null;
next();
if(_307!==_35c&&_307!==_357){
_3fd=_3d5(true,true);
if(_307!==_35c&&_307!==_357){
return _3cd(node,_3fd);
}
}
node.elements=_3fa(_357,_3fd,true,true);
return _3c0(node,"ArrayExpression");
case _348:
var node=_3bc();
next();
var r=_3fe();
node.keys=r[0];
node.values=r[1];
return _3c0(node,"DictionaryLiteral");
case _358:
return _3ff();
case _32f:
var node=_3bc();
next();
return _3d6(node,false);
case _338:
return _400();
case _345:
var node=_3bc();
next();
_3c4(_35a,"Expected '(' after '@selector'");
_401(node,_35b);
_3c4(_35b,"Expected closing ')' after selector");
return _3c0(node,"SelectorLiteralExpression");
default:
_3c6();
}
};
function _3cd(node,_402){
_403(node,_357);
if(_402.type==="Identifier"&&_402.name==="super"){
node.superObject=true;
}else{
node.object=_402;
}
return _3c0(node,"MessageSendExpression");
};
function _401(node,_404){
var _405=true,_406=[];
for(;;){
if(_307!==_35e){
_406.push(_3d0(true).name);
if(_405&&_307===_404){
break;
}
}
_3c4(_35e,"Expected ':' in selector");
_406.push(":");
if(_307===_404){
break;
}
_405=false;
}
node.selector=_406.join("");
};
function _403(node,_407){
var _408=true,_409=[],args=[],_40a=[];
node.selectors=_409;
node.arguments=args;
for(;;){
if(_307!==_35e){
_409.push(_3d0(true));
if(_408&&eat(_407)){
break;
}
}else{
_409.push(null);
}
_3c4(_35e,"Expected ':' in selector");
args.push(_3d5(true,true));
if(eat(_407)){
break;
}
if(_307===_35c){
node.parameters=[];
while(eat(_35c)){
node.parameters.push(_3d5(true,true));
}
eat(_407);
break;
}
_408=false;
}
};
function _400(){
var node=_3bc();
next();
node.callee=_3f6(_3f7(false),true);
if(eat(_35a)){
node.arguments=_3fa(_35b,_307===_35b?null:_3d5(true),false);
}else{
node.arguments=[];
}
return _3c0(node,"NewExpression");
};
function _3ff(){
var node=_3bc(),_40b=true,_40c=false;
node.properties=[];
next();
while(!eat(_359)){
if(!_40b){
_3c4(_35c,"Expected ',' in object literal");
if(_2f7.allowTrailingCommas&&eat(_359)){
break;
}
}else{
_40b=false;
}
var prop={key:_40d()},_40e=false,kind;
if(eat(_35e)){
prop.value=_3d5(true);
kind=prop.kind="init";
}else{
if(_2f7.ecmaVersion>=5&&prop.key.type==="Identifier"&&(prop.key.name==="get"||prop.key.name==="set")){
_40e=_40c=true;
kind=prop.kind=prop.key.name;
prop.key=_40d();
if(!_307===_35a){
_3c6();
}
prop.value=_3d6(_3bc(),false);
}else{
_3c6();
}
}
if(prop.key.type==="Identifier"&&(_31c||_40c)){
for(var i=0;i<node.properties.length;++i){
var _40f=node.properties[i];
if(_40f.key.name===prop.key.name){
var _410=kind==_40f.kind||_40e&&_40f.kind==="init"||kind==="init"&&(_40f.kind==="get"||_40f.kind==="set");
if(_410&&!_31c&&kind==="init"&&_40f.kind==="init"){
_410=false;
}
if(_410){
_31d(prop.key.start,"Redefinition of property");
}
}
}
}
node.properties.push(prop);
}
return _3c0(node,"ObjectExpression");
};
function _40d(){
if(_307===_320||_307===_322){
return _3f7();
}
return _3d0(true);
};
function _3d6(node,_411){
if(_307===_323){
node.id=_3d0();
}else{
if(_411){
_3c6();
}else{
node.id=null;
}
}
node.params=[];
var _412=true;
_3c4(_35a,"Expected '(' before function parameters");
while(!eat(_35b)){
if(!_412){
_3c4(_35c,"Expected ',' between function parameters");
}else{
_412=false;
}
node.params.push(_3d0());
}
var _413=_31a,_414=_31b;
_31a=true;
_31b=[];
node.body=_3d9(true);
_31a=_413;
_31b=_414;
if(_31c||node.body.body.length&&_3c1(node.body.body[0])){
for(var i=node.id?-1:0;i<node.params.length;++i){
var id=i<0?node.id:node.params[i];
if(_378(id.name)||_379(id.name)){
_31d(id.start,"Defining '"+id.name+"' in strict mode");
}
if(i>=0){
for(var j=0;j<i;++j){
if(id.name===node.params[j].name){
_31d(id.start,"Argument name clash in strict mode");
}
}
}
}
}
return _3c0(node,_411?"FunctionDeclaration":"FunctionExpression");
};
function _3fa(_415,_416,_417,_418){
if(_416&&eat(_415)){
return [_416];
}
var elts=[],_419=true;
while(!eat(_415)){
if(_419){
_419=false;
if(_418&&_307===_35c&&!_416){
elts.push(null);
}else{
elts.push(_416);
}
}else{
_3c4(_35c,"Expected ',' between expressions");
if(_417&&_2f7.allowTrailingCommas&&eat(_415)){
break;
}
if(_418&&_307===_35c){
elts.push(null);
}else{
elts.push(_3d5(true));
}
}
}
return elts;
};
function _3fe(){
_3c4(_358,"Expected '{' before dictionary");
var keys=[],_41a=[],_41b=true;
while(!eat(_359)){
if(!_41b){
_3c4(_35c,"Expected ',' between expressions");
if(_2f7.allowTrailingCommas&&eat(_359)){
break;
}
}
keys.push(_3d5(true,true));
_3c4(_35e,"Expected ':' between dictionary key and value");
_41a.push(_3d5(true,true));
_41b=false;
}
return [keys,_41a];
};
function _3d0(_41c){
var node=_3bc();
node.name=_307===_323?_308:(((_41c&&!_2f7.forbidReserved)||_307.okAsIdent)&&_307.keyword)||_3c6();
next();
return _3c0(node,"Identifier");
};
function _3dd(){
var node=_3bc();
node.value=_308;
node.raw=_2f8.slice(_303,_304);
next();
return _3c0(node,"Literal");
};
function _3e0(){
var node=_3bc();
if(_307===_323){
node.name=_308;
next();
if(_308==="<"){
next();
node.protocol=_3d0(true);
if(_308!==">"){
_3c6();
}
next();
}
}else{
node.name=_307.keyword;
if(!eat(_33a)){
var _41d;
if(eat(_34c)||eat(_34b)){
_41d=_307.keyword||true;
}
if(eat(_34e)||eat(_34d)||eat(_34f)){
if(_41d){
node.name+=" "+_41d;
}
_41d=_307.keyword||true;
}else{
if(eat(_350)){
if(_41d){
node.name+=" "+_41d;
}
_41d=_307.keyword||true;
}
if(eat(_351)){
if(_41d){
node.name+=" "+_41d;
}
_41d=_307.keyword||true;
if(eat(_351)){
node.name+=" "+_41d;
}
}
}
if(!_41d){
node.name=(!_2f7.forbidReserved&&_307.keyword)||_3c6();
next();
}
}
}
return _3c0(node,"ObjectiveJType");
};
})(typeof _2==="undefined"?(self.acorn={}):_2.acorn);
if(!_2.acorn){
_2.acorn={};
_2.acorn.walk={};
}
(function(_41e){
"use strict";
_41e.simple=function(node,_41f,base,_420){
if(!base){
base=_41e;
}
function c(node,st,_421){
var type=_421||node.type,_422=_41f[type];
if(_422){
_422(node,st);
}
base[type](node,st,c);
};
c(node,_420);
};
_41e.recursive=function(node,_423,_424,base){
var _425=_41e.make(_424,base);
function c(node,st,_426){
_425[_426||node.type](node,st,c);
};
c(node,_423);
};
_41e.make=function(_427,base){
if(!base){
base=_41e;
}
var _428={};
for(var type in base){
_428[type]=base[type];
}
for(var type in _427){
_428[type]=_427[type];
}
return _428;
};
function _429(node,st,c){
c(node,st);
};
function _42a(node,st,c){
};
_41e.Program=_41e.BlockStatement=function(node,st,c){
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
};
_41e.Statement=_429;
_41e.EmptyStatement=_42a;
_41e.ExpressionStatement=function(node,st,c){
c(node.expression,st,"Expression");
};
_41e.IfStatement=function(node,st,c){
c(node.test,st,"Expression");
c(node.consequent,st,"Statement");
if(node.alternate){
c(node.alternate,st,"Statement");
}
};
_41e.LabeledStatement=function(node,st,c){
c(node.body,st,"Statement");
};
_41e.BreakStatement=_41e.ContinueStatement=_42a;
_41e.WithStatement=function(node,st,c){
c(node.object,st,"Expression");
c(node.body,st,"Statement");
};
_41e.SwitchStatement=function(node,st,c){
c(node.discriminant,st,"Expression");
for(var i=0;i<node.cases.length;++i){
var cs=node.cases[i];
if(cs.test){
c(cs.test,st,"Expression");
}
for(var j=0;j<cs.consequent.length;++j){
c(cs.consequent[j],st,"Statement");
}
}
};
_41e.ReturnStatement=function(node,st,c){
if(node.argument){
c(node.argument,st,"Expression");
}
};
_41e.ThrowStatement=function(node,st,c){
c(node.argument,st,"Expression");
};
_41e.TryStatement=function(node,st,c){
c(node.block,st,"Statement");
for(var i=0;i<node.handlers.length;++i){
c(node.handlers[i].body,st,"ScopeBody");
}
if(node.finalizer){
c(node.finalizer,st,"Statement");
}
};
_41e.WhileStatement=function(node,st,c){
c(node.test,st,"Expression");
c(node.body,st,"Statement");
};
_41e.DoWhileStatement=function(node,st,c){
c(node.body,st,"Statement");
c(node.test,st,"Expression");
};
_41e.ForStatement=function(node,st,c){
if(node.init){
c(node.init,st,"ForInit");
}
if(node.test){
c(node.test,st,"Expression");
}
if(node.update){
c(node.update,st,"Expression");
}
c(node.body,st,"Statement");
};
_41e.ForInStatement=function(node,st,c){
c(node.left,st,"ForInit");
c(node.right,st,"Expression");
c(node.body,st,"Statement");
};
_41e.ForInit=function(node,st,c){
if(node.type=="VariableDeclaration"){
c(node,st);
}else{
c(node,st,"Expression");
}
};
_41e.DebuggerStatement=_42a;
_41e.FunctionDeclaration=function(node,st,c){
c(node,st,"Function");
};
_41e.VariableDeclaration=function(node,st,c){
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i];
if(decl.init){
c(decl.init,st,"Expression");
}
}
};
_41e.Function=function(node,st,c){
c(node.body,st,"ScopeBody");
};
_41e.ScopeBody=function(node,st,c){
c(node,st,"Statement");
};
_41e.Expression=_429;
_41e.ThisExpression=_42a;
_41e.ArrayExpression=_41e.ArrayLiteral=function(node,st,c){
for(var i=0;i<node.elements.length;++i){
var elt=node.elements[i];
if(elt){
c(elt,st,"Expression");
}
}
};
_41e.DictionaryLiteral=function(node,st,c){
for(var i=0;i<node.keys.length;i++){
var key=node.keys[i];
c(key,st,"Expression");
var _42b=node.values[i];
c(_42b,st,"Expression");
}
};
_41e.ObjectExpression=function(node,st,c){
for(var i=0;i<node.properties.length;++i){
c(node.properties[i].value,st,"Expression");
}
};
_41e.FunctionExpression=_41e.FunctionDeclaration;
_41e.SequenceExpression=function(node,st,c){
for(var i=0;i<node.expressions.length;++i){
c(node.expressions[i],st,"Expression");
}
};
_41e.UnaryExpression=_41e.UpdateExpression=function(node,st,c){
c(node.argument,st,"Expression");
};
_41e.BinaryExpression=_41e.AssignmentExpression=_41e.LogicalExpression=function(node,st,c){
c(node.left,st,"Expression");
c(node.right,st,"Expression");
};
_41e.ConditionalExpression=function(node,st,c){
c(node.test,st,"Expression");
c(node.consequent,st,"Expression");
c(node.alternate,st,"Expression");
};
_41e.NewExpression=_41e.CallExpression=function(node,st,c){
c(node.callee,st,"Expression");
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
c(node.arguments[i],st,"Expression");
}
}
};
_41e.MemberExpression=function(node,st,c){
c(node.object,st,"Expression");
if(node.computed){
c(node.property,st,"Expression");
}
};
_41e.Identifier=_41e.Literal=_42a;
_41e.ClassDeclarationStatement=function(node,st,c){
if(node.ivardeclarations){
for(var i=0;i<node.ivardeclarations.length;++i){
c(node.ivardeclarations[i],st,"IvarDeclaration");
}
}
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
};
_41e.ImportStatement=_42a;
_41e.IvarDeclaration=_42a;
_41e.MethodDeclarationStatement=_42a;
_41e.PreprocessStatement=_42a;
_41e.ClassStatement=_42a;
_41e.GlobalStatement=_42a;
_41e.MethodDeclarationStatement=function(node,st,c){
c(node.body,st,"Statement");
};
_41e.MessageSendExpression=function(node,st,c){
if(!node.superObject){
c(node.object,st,"Expression");
}
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
c(node.arguments[i],st,"Expression");
}
}
if(node.parameters){
for(var i=0;i<node.parameters.length;++i){
c(node.parameters[i],st,"Expression");
}
}
};
_41e.SelectorLiteralExpression=_42a;
function _42c(prev){
return {vars:Object.create(null),prev:prev};
};
_41e.scopeVisitor=_41e.make({Function:function(node,_42d,c){
var _42e=_42c(_42d);
for(var i=0;i<node.params.length;++i){
_42e.vars[node.params[i].name]={type:"argument",node:node.params[i]};
}
if(node.id){
var decl=node.type=="FunctionDeclaration";
(decl?_42d:_42e).vars[node.id.name]={type:decl?"function":"function name",node:node.id};
}
c(node.body,_42e,"ScopeBody");
},TryStatement:function(node,_42f,c){
c(node.block,_42f,"Statement");
for(var i=0;i<node.handlers.length;++i){
var _430=node.handlers[i],_431=_42c(_42f);
_431.vars[_430.param.name]={type:"catch clause",node:_430.param};
c(_430.body,_431,"ScopeBody");
}
if(node.finalizer){
c(node.finalizer,_42f,"Statement");
}
},VariableDeclaration:function(node,_432,c){
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i];
_432.vars[decl.id.name]={type:"var",node:decl.id};
if(decl.init){
c(decl.init,_432,"Expression");
}
}
}});
})(typeof _2=="undefined"?acorn.walk={}:_2.acorn.walk);
var _433=function(prev,base){
this.vars=Object.create(null);
if(base){
for(var key in base){
this[key]=base[key];
}
}
this.prev=prev;
if(prev){
this.compiler=prev.compiler;
}
};
_433.prototype.compiler=function(){
return this.compiler;
};
_433.prototype.rootScope=function(){
return this.prev?this.prev.rootScope():this;
};
_433.prototype.isRootScope=function(){
return !this.prev;
};
_433.prototype.currentClassName=function(){
return this.classDef?this.classDef.className:this.prev?this.prev.currentClassName():null;
};
_433.prototype.getIvarForCurrentClass=function(_434){
if(this.ivars){
var ivar=this.ivars[_434];
if(ivar){
return ivar;
}
}
var prev=this.prev;
if(prev&&!this.classDef){
return prev.getIvarForCurrentClass(_434);
}
return null;
};
_433.prototype.getLvar=function(_435,_436){
if(this.vars){
var lvar=this.vars[_435];
if(lvar){
return lvar;
}
}
var prev=this.prev;
if(prev&&(!_436||!this.methodtype)){
return prev.getLvar(_435,_436);
}
return null;
};
_433.prototype.currentMethodType=function(){
return this.methodType?this.methodType:this.prev?this.prev.currentMethodType():null;
};
_433.prototype.copyAddedSelfToIvarsToParent=function(){
if(this.prev&&this.addedSelfToIvars){
for(var key in this.addedSelfToIvars){
var _437=this.addedSelfToIvars[key],_438=(this.prev.addedSelfToIvars||(this.prev.addedSelfToIvars=Object.create(null)))[key]||(this.prev.addedSelfToIvars[key]=[]);
_438.push.apply(_438,_437);
}
}
};
_433.prototype.addMaybeWarning=function(_439){
var _43a=this.rootScope();
(_43a._maybeWarnings||(_43a._maybeWarnings=[])).push(_439);
};
_433.prototype.maybeWarnings=function(){
return this.rootScope()._maybeWarnings;
};
var _43b="";
var _43c=_2.acorn.makePredicate("self _cmd undefined localStorage arguments");
var _43d=function(_43e,aURL,_43f,pass,_440){
this.source=_43e;
this.URL=new CFURL(aURL);
this.pass=pass;
this.jsBuffer=new _298();
this.imBuffer=null;
this.cmBuffer=null;
this.warnings=[];
try{
this.tokens=_2.acorn.parse(_43e);
}
catch(e){
if(e.lineStart){
var _441=this.prettifyMessage(e,"ERROR");
console.log(_441);
}
throw e;
}
this.dependencies=[];
this.flags=_43f|_43d.Flags.IncludeDebugSymbols;
this.classDefs=_440?_440:Object.create(null);
this.lastPos=0;
_442(this.tokens,new _433(null,{compiler:this}),pass===2?_443:_444);
};
_2.ObjJAcornCompiler=_43d;
_2.ObjJAcornCompiler.compileToExecutable=function(_445,aURL,_446){
_43d.currentCompileFile=aURL;
return new _43d(_445,aURL,_446,2).executable();
};
_2.ObjJAcornCompiler.compileToIMBuffer=function(_447,aURL,_448,_449){
return new _43d(_447,aURL,_448,2,_449).IMBuffer();
};
_2.ObjJAcornCompiler.compileFileDependencies=function(_44a,aURL,_44b){
_43d.currentCompileFile=aURL;
return new _43d(_44a,aURL,_44b,1).executable();
};
_43d.prototype.compilePass2=function(){
_43d.currentCompileFile=this.URL;
this.pass=2;
this.jsBuffer=new _298();
this.warnings=[];
_442(this.tokens,new _433(null,{compiler:this}),_443);
for(var i=0;i<this.warnings.length;i++){
var _44c=this.prettifyMessage(this.warnings[i],"WARNING");
console.log(_44c);
}
return this.jsBuffer.toString();
};
var _43b="";
_2.setCurrentCompilerFlags=function(_44d){
_43b=_44d;
};
_2.currentCompilerFlags=function(_44e){
return _43b;
};
_43d.Flags={};
_43d.Flags.IncludeDebugSymbols=1<<0;
_43d.Flags.IncludeTypeSignatures=1<<1;
_43d.prototype.addWarning=function(_44f){
this.warnings.push(_44f);
};
_43d.prototype.getIvarForClass=function(_450,_451){
var ivar=_451.getIvarForCurrentClass(_450);
if(ivar){
return ivar;
}
var c=this.getClassDef(_451.currentClassName());
while(c){
var _452=c.ivars;
if(_452){
var _453=_452[_450];
if(_453){
return _453;
}
}
c=this.getClassDef(c.superClassName);
}
};
_43d.prototype.getClassDef=function(_454){
if(!_454){
return null;
}
var c=this.classDefs[_454];
if(c){
return c;
}
if(objj_getClass){
var _455=objj_getClass(_454);
if(_455){
var _456=class_copyIvarList(_455),_457=_456.length,_458=Object.create(null),_459=_455.super_class;
for(var i=0;i<_457;i++){
var ivar=_456[i];
_458[ivar.name]={"type":ivar.type,"name":ivar.name};
}
c={"className":_454,"ivars":_458};
if(_459){
c.superClassName=_459.name;
}
this.classDefs[_454]=c;
return c;
}
}
return null;
};
_43d.prototype.executable=function(){
if(!this._executable){
this._executable=new _2a7(this.jsBuffer?this.jsBuffer.toString():null,this.dependencies,this.URL,null,this);
}
return this._executable;
};
_43d.prototype.IMBuffer=function(){
return this.imBuffer;
};
_43d.prototype.JSBuffer=function(){
return this.jsBuffer;
};
_43d.prototype.prettifyMessage=function(_45a,_45b){
var line=this.source.substring(_45a.lineStart,_45a.lineEnd),_45c="\n"+line;
_45c+=(new Array(_45a.column+1)).join(" ");
_45c+=(new Array(Math.min(1,line.length)+1)).join("^")+"\n";
_45c+=_45b+" line "+_45a.line+" in "+this.URL+": "+_45a.message;
return _45c;
};
_43d.prototype.error_message=function(_45d,node){
var pos=_2.acorn.getLineInfo(this.source,node.start),_45e={message:_45d,line:pos.line,column:pos.column,lineStart:pos.lineStart,lineEnd:pos.lineEnd};
return new SyntaxError(this.prettifyMessage(_45e,"ERROR"));
};
_43d.prototype.pushImport=function(url){
if(!_43d.importStack){
_43d.importStack=[];
}
_43d.importStack.push(url);
};
_43d.prototype.popImport=function(){
_43d.importStack.pop();
};
function _45f(_460,node,code){
var _461=_2.acorn.getLineInfo(code,node.start);
_461.message=_460;
return _461;
};
function _442(node,_462,_463){
function c(node,st,_464){
_463[_464||node.type](node,st,c);
};
c(node,_462);
};
var _444=_2.acorn.walk.make({ImportStatement:function(node,st,c){
var _465=node.filename.value;
st.compiler.dependencies.push(new _2d6(new CFURL(_465),node.localfilepath));
}});
var _443=_2.acorn.walk.make({Program:function(node,st,c){
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.end);
var _466=st.maybeWarnings();
if(_466){
for(var i=0;i<_466.length;i++){
var _467=_466[i];
if(!st.getLvar(_467.identifier)&&typeof _1[_467.identifier]==="undefined"&&typeof window[_467.identifier]==="undefined"&&!st.compiler.getClassDef(_467.identifier)){
st.compiler.addWarning(_467.message);
}
}
}
},Function:function(node,_468,c){
var _469=new _433(_468);
for(var i=0;i<node.params.length;++i){
_469.vars[node.params[i].name]={type:"argument",node:node.params[i]};
}
if(node.id){
var decl=node.type=="FunctionDeclaration";
(decl?_468:_469).vars[node.id.name]={type:decl?"function":"function name",node:node.id};
_468.compiler.jsBuffer.atoms[_468.compiler.jsBuffer.atoms.length]=_468.compiler.source.substring(_468.compiler.lastPos,node.start);
_468.compiler.jsBuffer.atoms[_468.compiler.jsBuffer.atoms.length]=node.id.name;
_468.compiler.jsBuffer.atoms[_468.compiler.jsBuffer.atoms.length]=" = function";
_468.compiler.lastPos=node.id.end;
}
c(node.body,_469,"ScopeBody");
_469.copyAddedSelfToIvarsToParent();
},TryStatement:function(node,_46a,c){
c(node.block,_46a,"Statement");
for(var i=0;i<node.handlers.length;++i){
var _46b=node.handlers[i],_46c=new _433(_46a);
_46c.vars[_46b.param.name]={type:"catch clause",node:_46b.param};
c(_46b.body,_46c,"ScopeBody");
_46c.copyAddedSelfToIvarsToParent();
}
if(node.finalizer){
c(node.finalizer,_46a,"Statement");
}
},VariableDeclaration:function(node,_46d,c){
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i],_46e=decl.id.name;
_46d.vars[_46e]={type:"var",node:decl.id};
if(decl.init){
c(decl.init,_46d,"Expression");
}
if(_46d.addedSelfToIvars){
var _46f=_46d.addedSelfToIvars[_46e];
if(_46f){
var _470=_46d.compiler.jsBuffer.atoms;
for(var i=0;i<_46f.length;i++){
var dict=_46f[i];
_470[dict.index]="";
_46d.compiler.addWarning(_45f("Local declaration of '"+_46e+"' hides instance variable",dict.node,_46d.compiler.source));
}
_46d.addedSelfToIvars[_46e]=[];
}
}
}
},AssignmentExpression:function(node,st,c){
var _471=st.assignment;
st.assignment=true;
c(node.left,st,"Expression");
st.assignment=_471;
c(node.right,st,"Expression");
if(st.isRootScope()&&node.left.type==="Identifier"&&!st.getLvar(node.left.name)){
st.vars[node.left.name]={type:"global",node:node.left};
}
},MemberExpression:function(node,st,c){
c(node.object,st,"Expression");
st.secondMemberExpression=!node.computed;
c(node.property,st,"Expression");
st.secondMemberExpression=false;
},ImportStatement:function(node,st,c){
var _472=st.compiler.jsBuffer;
if(!_472){
return;
}
_472.atoms[_472.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.start);
_472.atoms[_472.atoms.length]="objj_executeFile(\"";
_472.atoms[_472.atoms.length]=node.filename.value;
_472.atoms[_472.atoms.length]=node.localfilepath?"\", YES);":"\", NO);";
st.compiler.lastPos=node.end;
},ClassDeclarationStatement:function(node,st,c){
var _473,_474=st.compiler.jsBuffer,_475=node.classname.name,_476=new _433(st);
st.compiler.imBuffer=new _298();
st.compiler.cmBuffer=new _298();
st.compiler.classBodyBuffer=new _298();
_474.atoms[_474.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.start);
if(node.superclassname){
_473=st.compiler.getClassDef(_475);
if(_473&&_473.ivars){
throw st.compiler.error_message("Duplicate class "+_475,node.classname);
}
if(!st.compiler.getClassDef(node.superclassname.name)){
var _477="Can't find superclass "+node.superclassname.name;
for(var i=_43d.importStack.length;--i>=0;){
_477+="\n"+Array((_43d.importStack.length-i)*2+1).join(" ")+"Imported by: "+_43d.importStack[i];
}
throw st.compiler.error_message(_477,node.superclassname);
}
_473={"className":_475,"superClassName":node.superclassname.name,"ivars":Object.create(null),"methods":Object.create(null)};
_474.atoms[_474.atoms.length]="{var the_class = objj_allocateClassPair("+node.superclassname.name+", \""+_475+"\"),\nmeta_class = the_class.isa;";
}else{
if(node.categoryname){
_473=st.compiler.getClassDef(_475);
if(!_473){
throw st.compiler.error_message("Class "+_475+" not found ",node.classname);
}
_474.atoms[_474.atoms.length]="{\nvar the_class = objj_getClass(\""+_475+"\")\n";
_474.atoms[_474.atoms.length]="if(!the_class) throw new SyntaxError(\"*** Could not find definition for class \\\""+_475+"\\\"\");\n";
_474.atoms[_474.atoms.length]="var meta_class = the_class.isa;";
}else{
_473={"className":_475,"superClassName":null,"ivars":Object.create(null),"methods":Object.create(null)};
_474.atoms[_474.atoms.length]="{var the_class = objj_allocateClassPair(Nil, \""+_475+"\"),\nmeta_class = the_class.isa;";
}
}
_476.classDef=_473;
st.compiler.currentSuperClass="objj_getClass(\""+_475+"\").super_class";
st.compiler.currentSuperMetaClass="objj_getMetaClass(\""+_475+"\").super_class";
var _478=true,_479=false;
if(node.ivardeclarations){
for(var i=0;i<node.ivardeclarations.length;++i){
var _47a=node.ivardeclarations[i],_47b=_47a.ivartype?_47a.ivartype.name:null,_47c=_47a.id.name,ivar={"type":_47b,"name":_47c};
if(_478){
_478=false;
_474.atoms[_474.atoms.length]="class_addIvars(the_class, [";
}else{
_474.atoms[_474.atoms.length]=", ";
}
if(st.compiler.flags&_43d.Flags.IncludeTypeSignatures){
_474.atoms[_474.atoms.length]="new objj_ivar(\""+_47c+"\", \""+_47b+"\")";
}else{
_474.atoms[_474.atoms.length]="new objj_ivar(\""+_47c+"\")";
}
if(_47a.outlet){
ivar.outlet=true;
}
_473.ivars[_47c]=ivar;
if(!_476.ivars){
_476.ivars=Object.create(null);
}
_476.ivars[_47c]={type:"ivar",name:_47c,node:_47a.id,ivar:ivar};
if(!_479&&_47a.accessors){
_479=true;
}
}
}
if(!_478){
_474.atoms[_474.atoms.length]="]);";
}
if(_479){
var _47d=new _298();
_47d.atoms[_47d.atoms.length]=st.compiler.source.substring(node.start,node.endOfIvars);
_47d.atoms[_47d.atoms.length]="\n";
for(var i=0;i<node.ivardeclarations.length;++i){
var _47a=node.ivardeclarations[i],_47b=_47a.ivartype?_47a.ivartype.name:null,_47c=_47a.id.name,_47e=_47a.accessors;
if(!_47e){
continue;
}
var _47f=(_47e.property&&_47e.property.name)||_47c,_480=(_47e.getter&&_47e.getter.name)||_47f,_481="- ("+(_47b?_47b:"id")+")"+_480+"\n{\nreturn "+_47c+";\n}\n";
_47d.atoms[_47d.atoms.length]=_481;
if(_47e.readonly){
continue;
}
var _482=_47e.setter?_47e.setter.name:null;
if(!_482){
var _483=_47f.charAt(0)=="_"?1:0;
_482=(_483?"_":"")+"set"+_47f.substr(_483,1).toUpperCase()+_47f.substring(_483+1)+":";
}
var _484="- (void)"+_482+"("+(_47b?_47b:"id")+")newValue\n{\n";
if(_47e.copy){
_484+="if ("+_47c+" !== newValue)\n"+_47c+" = [newValue copy];\n}\n";
}else{
_484+=_47c+" = newValue;\n}\n";
}
_47d.atoms[_47d.atoms.length]=_484;
}
_47d.atoms[_47d.atoms.length]="\n@end";
var b=_47d.toString().replace(/@accessors(\(.*\))?/g,"");
var _485=_43d.compileToIMBuffer(b,"Accessors",st.compiler.flags,st.compiler.classDefs);
st.compiler.imBuffer.atoms[st.compiler.imBuffer.atoms.length]=_485;
}
st.compiler.classDefs[_475]=_473;
if(node.body.length>0){
st.compiler.lastPos=node.body[0].start;
for(var i=0;i<node.body.length;++i){
var body=node.body[i];
c(body,_476,"Statement");
}
_474.atoms[_474.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,body.end);
}
if(!node.categoryname){
_474.atoms[_474.atoms.length]="objj_registerClassPair(the_class);\n";
}
if(st.compiler.imBuffer.atoms.length!==0){
_474.atoms[_474.atoms.length]="class_addMethods(the_class, [";
_474.atoms.push.apply(_474.atoms,st.compiler.imBuffer.atoms);
_474.atoms[_474.atoms.length]="]);\n";
}
if(st.compiler.cmBuffer.atoms.length!==0){
_474.atoms[_474.atoms.length]="class_addMethods(meta_class, [";
_474.atoms.push.apply(_474.atoms,st.compiler.cmBuffer.atoms);
_474.atoms[_474.atoms.length]="]);\n";
}
_474.atoms[_474.atoms.length]="}";
st.compiler.jsBuffer=_474;
st.compiler.lastPos=node.end;
},MethodDeclarationStatement:function(node,st,c){
var _486=st.compiler.jsBuffer,_487=new _433(st),_488=node.selectors,_489=node.arguments,_48a=[node.returntype?node.returntype.name:"id"],_48b=_488[0].name;
_486.atoms[_486.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.start);
st.compiler.jsBuffer=node.methodtype==="-"?st.compiler.imBuffer:st.compiler.cmBuffer;
for(var i=0;i<_489.length;i++){
if(i===0){
_48b+=":";
}else{
_48b+=(_488[i]?_488[i].name:"")+":";
}
}
if(st.compiler.jsBuffer.atoms.length!==0){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=", ";
}
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="new objj_method(sel_getUid(\"";
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=_48b;
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="\"), function";
if(st.compiler.flags&_43d.Flags.IncludeDebugSymbols){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=" $"+st.currentClassName()+"__"+_48b.replace(/:/g,"_");
}
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="(self, _cmd";
_487.methodType=node.methodtype;
if(_489){
for(var i=0;i<_489.length;i++){
var _48c=_489[i],_48d=_48c.identifier.name;
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=", ";
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=_48d;
_48a.push(_48c.type?_48c.type.name:null);
_487.vars[_48d]={type:"method argument",node:_48c};
}
}
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=")";
st.compiler.lastPos=node.startOfBody;
c(node.body,_487,"Statement");
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.body.end);
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="\n";
if(st.compiler.flags&_43d.Flags.IncludeDebugSymbols){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=","+JSON.stringify(_48a);
}
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=")";
st.compiler.jsBuffer=_486;
st.compiler.lastPos=node.end;
},MessageSendExpression:function(node,st,c){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.start);
st.compiler.lastPos=node.object?node.object.start:node.arguments.length?node.arguments[0].start:node.end;
if(node.superObject){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="objj_msgSendSuper(";
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="{ receiver:self, super_class:"+(st.currentMethodType()==="+"?st.compiler.currentSuperMetaClass:st.compiler.currentSuperClass)+" }";
}else{
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="objj_msgSend(";
c(node.object,st,"Expression");
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.object.end);
}
var _48e=node.selectors,_48f=node.arguments,_490=_48e[0].name;
for(var i=0;i<_48f.length;i++){
if(i===0){
_490+=":";
}else{
_490+=(_48e[i]?_48e[i].name:"")+":";
}
}
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=", \"";
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=_490;
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="\"";
if(node.arguments){
for(var i=0;i<node.arguments.length;i++){
var _491=node.arguments[i];
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=", ";
st.compiler.lastPos=_491.start;
c(_491,st,"Expression");
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,_491.end);
st.compiler.lastPos=_491.end;
}
}
if(node.parameters){
for(var i=0;i<node.parameters.length;++i){
var _492=node.parameters[i];
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=", ";
st.compiler.lastPos=_492.start;
c(_492,st,"Expression");
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,_492.end);
st.compiler.lastPos=_492.end;
}
}
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=")";
st.compiler.lastPos=node.end;
},Identifier:function(node,st,c){
if(st.currentMethodType()==="-"&&!st.secondMemberExpression){
var _493=node.name,lvar=st.getLvar(_493,true),ivar=st.compiler.getIvarForClass(_493,st);
if(ivar){
if(lvar){
st.compiler.addWarning(_45f("Local declaration of '"+_493+"' hides instance variable",node,st.compiler.source));
}else{
var _494=node.start,_495=st.compiler;
do{
_495.jsBuffer.atoms[_495.jsBuffer.atoms.length]=_495.source.substring(_495.lastPos,_494);
_495.lastPos=_494;
}while(_495.source.substr(_494++,1)==="(");
((st.addedSelfToIvars||(st.addedSelfToIvars=Object.create(null)))[_493]||(st.addedSelfToIvars[_493]=[])).push({node:node,index:_495.jsBuffer.atoms.length});
_495.jsBuffer.atoms[_495.jsBuffer.atoms.length]="self.";
}
}else{
if(!_43c(_493)&&!st.getLvar(_493)&&typeof _1[_493]==="undefined"&&typeof window[_493]==="undefined"&&!st.compiler.getClassDef(_493)){
var _496;
if(st.assignment){
_496=_45f("Creating global variable inside function or method '"+_493+"'",node,st.compiler.source);
st.vars[_493]={type:"global",node:node};
}else{
_496=_45f("Using unknown class or uninitialized global variable '"+_493+"'",node,st.compiler.source);
}
st.addMaybeWarning({identifier:_493,message:_496});
}
}
}
},ArrayLiteral:function(node,st,c){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.start);
st.compiler.lastPos=node.start;
if(!node.elements.length){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="objj_msgSend(objj_msgSend(CPArray, \"alloc\"), \"init\")";
}else{
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="objj_msgSend(objj_msgSend(CPArray, \"alloc\"), \"initWithObjects:count:\", [";
for(var i=0;i<node.elements.length;i++){
var elt=node.elements[i];
if(i){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=", ";
}
st.compiler.lastPos=elt.start;
c(elt,st,"Expression");
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,elt.end);
}
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="], "+node.elements.length+")";
}
st.compiler.lastPos=node.end;
},DictionaryLiteral:function(node,st,c){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.start);
st.compiler.lastPos=node.start;
if(!node.keys.length){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="objj_msgSend(objj_msgSend(CPDictionary, \"alloc\"), \"init\")";
}else{
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="objj_msgSend(objj_msgSend(CPDictionary, \"alloc\"), \"initWithObjectsAndKeys:\"";
for(var i=0;i<node.keys.length;i++){
var key=node.keys[i],_497=node.values[i];
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=", ";
st.compiler.lastPos=_497.start;
c(_497,st,"Expression");
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,_497.end);
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=", ";
st.compiler.lastPos=key.start;
c(key,st,"Expression");
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,key.end);
}
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=")";
}
st.compiler.lastPos=node.end;
},SelectorLiteralExpression:function(node,st,c){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.start);
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="sel_getUid(\"";
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=node.selector;
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="\")";
st.compiler.lastPos=node.end;
},Literal:function(node,st,c){
if(node.raw&&node.raw.charAt(0)==="@"){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.start);
st.compiler.lastPos=node.start+1;
}
},ObjectExpression:function(node,st,c){
for(var i=0;i<node.properties.length;++i){
var prop=node.properties[i];
if(prop.key.raw&&prop.key.raw.charAt(0)==="@"){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,prop.key.start);
st.compiler.lastPos=prop.key.start+1;
}
c(prop.value,st,"Expression");
}
},PreprocessStatement:function(node,st,c){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.start);
st.compiler.lastPos=node.start;
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="//";
},ClassStatement:function(node,st,c){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.start);
st.compiler.lastPos=node.start;
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="//";
var _498=node.id.name;
if(!st.compiler.getClassDef(_498)){
classDef={"className":_498};
st.compiler.classDefs[_498]=classDef;
}
st.vars[node.id.name]={type:"class",node:node.id};
},GlobalStatement:function(node,st,c){
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]=st.compiler.source.substring(st.compiler.lastPos,node.start);
st.compiler.lastPos=node.start;
st.compiler.jsBuffer.atoms[st.compiler.jsBuffer.atoms.length]="//";
st.rootScope().vars[node.id.name]={type:"global",node:node.id};
}});
function _2d6(aURL,_499){
this._URL=aURL;
this._isLocal=_499;
};
_2.FileDependency=_2d6;
_2d6.prototype.URL=function(){
return this._URL;
};
_2d6.prototype.isLocal=function(){
return this._isLocal;
};
_2d6.prototype.toMarkedString=function(){
var _49a=this.URL().absoluteString();
return (this.isLocal()?_21e:_21d)+";"+_49a.length+";"+_49a;
};
_2d6.prototype.toString=function(){
return (this.isLocal()?"LOCAL: ":"STD: ")+this.URL();
};
var _49b=0,_49c=1,_49d=2,_49e=0;
function _2a7(_49f,_4a0,aURL,_4a1,_4a2,_4a3){
if(arguments.length===0){
return this;
}
this._code=_49f;
this._function=_4a1||null;
this._URL=_1bf(aURL||new CFURL("(Anonymous"+(_49e++)+")"));
this._compiler=_4a2||null;
this._fileDependencies=_4a0;
this._filenameTranslateDictionary=_4a3;
if(_4a0.length){
this._fileDependencyStatus=_49b;
this._fileDependencyCallbacks=[];
}else{
this._fileDependencyStatus=_49d;
}
if(this._function){
return;
}
if(!_4a2){
this.setCode(_49f);
}
};
_2.Executable=_2a7;
_2a7.prototype.path=function(){
return this.URL().path();
};
_2a7.prototype.URL=function(){
return this._URL;
};
_2a7.prototype.functionParameters=function(){
var _4a4=["global","objj_executeFile","objj_importFile"];
return _4a4;
};
_2a7.prototype.functionArguments=function(){
var _4a5=[_1,this.fileExecuter(),this.fileImporter()];
return _4a5;
};
_2a7.prototype.execute=function(){
if(this._compiler){
var _4a6=this.fileDependencies(),_97=0,_4a7=_4a6.length;
this._compiler.pushImport(this.URL().lastPathComponent());
for(;_97<_4a7;++_97){
var _4a8=_4a6[_97],_4a9=_4a8.isLocal(),URL=_4a8.URL();
this.fileExecuter()(URL,_4a9);
}
this._compiler.popImport();
this.setCode(this._compiler.compilePass2());
this._compiler=null;
}
var _4aa=_4ab;
_4ab=CFBundle.bundleContainingURL(this.URL());
var _4ac=this._function.apply(_1,this.functionArguments());
_4ab=_4aa;
return _4ac;
};
_2a7.prototype.code=function(){
return this._code;
};
_2a7.prototype.setCode=function(code){
this._code=code;
var _4ad=this.functionParameters().join(",");
this._function=new Function(_4ad,code);
};
_2a7.prototype.fileDependencies=function(){
return this._fileDependencies;
};
_2a7.prototype.hasLoadedFileDependencies=function(){
return this._fileDependencyStatus===_49d;
};
var _4ae=0,_4af=[],_4b0={};
_2a7.prototype.loadFileDependencies=function(_4b1){
var _4b2=this._fileDependencyStatus;
if(_4b1){
if(_4b2===_49d){
return _4b1();
}
this._fileDependencyCallbacks.push(_4b1);
}
if(_4b2===_49b){
if(_4ae){
throw "Can't load";
}
_4b3(this);
}
};
function _4b3(_4b4){
_4af.push(_4b4);
_4b4._fileDependencyStatus=_49c;
var _4b5=_4b4.fileDependencies(),_97=0,_4b6=_4b5.length,_4b7=_4b4.referenceURL(),_4b8=_4b7.absoluteString(),_4b9=_4b4.fileExecutableSearcher();
_4ae+=_4b6;
for(;_97<_4b6;++_97){
var _4ba=_4b5[_97],_4bb=_4ba.isLocal(),URL=_4ba.URL(),_4bc=(_4bb&&(_4b8+" ")||"")+URL;
if(_4b0[_4bc]){
if(--_4ae===0){
_4bd();
}
continue;
}
_4b0[_4bc]=YES;
_4b9(URL,_4bb,_4be);
}
};
function _4be(_4bf){
--_4ae;
if(_4bf._fileDependencyStatus===_49b){
_4b3(_4bf);
}else{
if(_4ae===0){
_4bd();
}
}
};
function _4bd(){
var _4c0=_4af,_97=0,_4c1=_4c0.length;
_4af=[];
for(;_97<_4c1;++_97){
_4c0[_97]._fileDependencyStatus=_49d;
}
for(_97=0;_97<_4c1;++_97){
var _4c2=_4c0[_97],_4c3=_4c2._fileDependencyCallbacks,_4c4=0,_4c5=_4c3.length;
for(;_4c4<_4c5;++_4c4){
_4c3[_4c4]();
}
_4c2._fileDependencyCallbacks=[];
}
};
_2a7.prototype.referenceURL=function(){
if(this._referenceURL===_29){
this._referenceURL=new CFURL(".",this.URL());
}
return this._referenceURL;
};
_2a7.prototype.fileImporter=function(){
return _2a7.fileImporterForURL(this.referenceURL());
};
_2a7.prototype.fileExecuter=function(){
return _2a7.fileExecuterForURL(this.referenceURL());
};
_2a7.prototype.fileExecutableSearcher=function(){
return _2a7.fileExecutableSearcherForURL(this.referenceURL());
};
var _4c6={};
_2a7.fileExecuterForURL=function(aURL){
var _4c7=_1bf(aURL),_4c8=_4c7.absoluteString(),_4c9=_4c6[_4c8];
if(!_4c9){
_4c9=function(aURL,_4ca,_4cb){
_2a7.fileExecutableSearcherForURL(_4c7)(aURL,_4ca,function(_4cc){
if(!_4cc.hasLoadedFileDependencies()){
throw "No executable loaded for file at URL "+aURL;
}
_4cc.execute(_4cb);
});
};
_4c6[_4c8]=_4c9;
}
return _4c9;
};
var _4cd={};
_2a7.fileImporterForURL=function(aURL){
var _4ce=_1bf(aURL),_4cf=_4ce.absoluteString(),_4d0=_4cd[_4cf];
if(!_4d0){
_4d0=function(aURL,_4d1,_4d2){
_15c();
_2a7.fileExecutableSearcherForURL(_4ce)(aURL,_4d1,function(_4d3){
_4d3.loadFileDependencies(function(){
_4d3.execute();
_15d();
if(_4d2){
_4d2();
}
});
});
};
_4cd[_4cf]=_4d0;
}
return _4d0;
};
var _4d4={},_4d5={};
function _236(x){
var _4d6=0;
for(var k in x){
if(x.hasOwnProperty(k)){
++_4d6;
}
}
return _4d6;
};
_2a7.resetCachedFileExecutableSearchers=function(){
_4d4={};
_4d5={};
_4cd={};
_4c6={};
_4b0={};
};
_2a7.fileExecutableSearcherForURL=function(_4d7){
var _4d8=_4d7.absoluteString(),_4d9=_4d4[_4d8],_4da=_2a7.filenameTranslateDictionary?_2a7.filenameTranslateDictionary():null;
cachedSearchResults={};
if(!_4d9){
_4d9=function(aURL,_4db,_4dc){
var _4dd=(_4db&&_4d7||"")+aURL,_4de=_4d5[_4dd];
if(_4de){
return _4df(_4de);
}
var _4e0=(aURL instanceof CFURL)&&aURL.scheme();
if(_4db||_4e0){
if(!_4e0){
aURL=new CFURL(aURL,_4d7);
}
_1ac.resolveResourceAtURL(aURL,NO,_4df,_4da);
}else{
_1ac.resolveResourceAtURLSearchingIncludeURLs(aURL,_4df);
}
function _4df(_4e1){
if(!_4e1){
var _4e2=_43d?_43d.currentCompileFile:null;
throw new Error("Could not load file at "+aURL+(_4e2?" when compiling "+_4e2:""));
}
_4d5[_4dd]=_4e1;
_4dc(new _4e3(_4e1.URL(),_4da));
};
};
_4d4[_4d8]=_4d9;
}
return _4d9;
};
var _4e4={};
function _4e3(aURL,_4e5){
aURL=_1bf(aURL);
var _4e6=aURL.absoluteString(),_4e7=_4e4[_4e6];
if(_4e7){
return _4e7;
}
_4e4[_4e6]=this;
var _4e8=_1ac.resourceAtURL(aURL).contents(),_4e9=NULL,_4ea=aURL.pathExtension();
if(_4e8.match(/^@STATIC;/)){
_4e9=_4eb(_4e8,aURL);
}else{
if((_4ea==="j"||!_4ea)&&!_4e8.match(/^{/)){
_4e9=_2.ObjJAcornCompiler.compileFileDependencies(_4e8,aURL,_43d.Flags.IncludeDebugSymbols);
}else{
_4e9=new _2a7(_4e8,[],aURL);
}
}
_2a7.apply(this,[_4e9.code(),_4e9.fileDependencies(),aURL,_4e9._function,_4e9._compiler,_4e5]);
this._hasExecuted=NO;
};
_2.FileExecutable=_4e3;
_4e3.prototype=new _2a7();
_4e3.resetFileExecutables=function(){
_4e4={};
_4ec={};
};
_4e3.prototype.execute=function(_4ed){
if(this._hasExecuted&&!_4ed){
return;
}
this._hasExecuted=YES;
_2a7.prototype.execute.call(this);
};
_4e3.prototype.hasExecuted=function(){
return this._hasExecuted;
};
function _4eb(_4ee,aURL){
var _4ef=new _10b(_4ee);
var _4f0=NULL,code="",_4f1=[];
while(_4f0=_4ef.getMarker()){
var text=_4ef.getString();
if(_4f0===_21c){
code+=text;
}else{
if(_4f0===_21d){
_4f1.push(new _2d6(new CFURL(text),NO));
}else{
if(_4f0===_21e){
_4f1.push(new _2d6(new CFURL(text),YES));
}
}
}
}
var fn=_4e3._lookupCachedFunction(aURL);
if(fn){
return new _2a7(code,_4f1,aURL,fn);
}
return new _2a7(code,_4f1,aURL);
};
var _4ec={};
_4e3._cacheFunction=function(aURL,fn){
aURL=typeof aURL==="string"?aURL:aURL.absoluteString();
_4ec[aURL]=fn;
};
_4e3._lookupCachedFunction=function(aURL){
aURL=typeof aURL==="string"?aURL:aURL.absoluteString();
return _4ec[aURL];
};
var _4f2=1,_4f3=2,_4f4=4,_4f5=8;
objj_ivar=function(_4f6,_4f7){
this.name=_4f6;
this.type=_4f7;
};
objj_method=function(_4f8,_4f9,_4fa){
this.name=_4f8;
this.method_imp=_4f9;
this.types=_4fa;
};
objj_class=function(_4fb){
this.isa=NULL;
this.version=0;
this.super_class=NULL;
this.sub_classes=[];
this.name=NULL;
this.info=0;
this.ivar_list=[];
this.ivar_store=function(){
};
this.ivar_dtable=this.ivar_store.prototype;
this.method_list=[];
this.method_store=function(){
};
this.method_dtable=this.method_store.prototype;
this.allocator=function(){
};
this._UID=-1;
};
objj_object=function(){
this.isa=NULL;
this._UID=-1;
};
class_getName=function(_4fc){
if(_4fc==Nil){
return "";
}
return _4fc.name;
};
class_isMetaClass=function(_4fd){
if(!_4fd){
return NO;
}
return ((_4fd.info&(_4f3)));
};
class_getSuperclass=function(_4fe){
if(_4fe==Nil){
return Nil;
}
return _4fe.super_class;
};
class_setSuperclass=function(_4ff,_500){
_4ff.super_class=_500;
_4ff.isa.super_class=_500.isa;
};
class_addIvar=function(_501,_502,_503){
var _504=_501.allocator.prototype;
if(typeof _504[_502]!="undefined"){
return NO;
}
var ivar=new objj_ivar(_502,_503);
_501.ivar_list.push(ivar);
_501.ivar_dtable[_502]=ivar;
_504[_502]=NULL;
return YES;
};
class_addIvars=function(_505,_506){
var _507=0,_508=_506.length,_509=_505.allocator.prototype;
for(;_507<_508;++_507){
var ivar=_506[_507],name=ivar.name;
if(typeof _509[name]==="undefined"){
_505.ivar_list.push(ivar);
_505.ivar_dtable[name]=ivar;
_509[name]=NULL;
}
}
};
class_copyIvarList=function(_50a){
return _50a.ivar_list.slice(0);
};
class_addMethod=function(_50b,_50c,_50d,_50e){
var _50f=new objj_method(_50c,_50d,_50e);
_50b.method_list.push(_50f);
_50b.method_dtable[_50c]=_50f;
if(!((_50b.info&(_4f3)))&&(((_50b.info&(_4f3)))?_50b:_50b.isa).isa===(((_50b.info&(_4f3)))?_50b:_50b.isa)){
class_addMethod((((_50b.info&(_4f3)))?_50b:_50b.isa),_50c,_50d,_50e);
}
return YES;
};
class_addMethods=function(_510,_511){
var _512=0,_513=_511.length,_514=_510.method_list,_515=_510.method_dtable;
for(;_512<_513;++_512){
var _516=_511[_512];
_514.push(_516);
_515[_516.name]=_516;
}
if(!((_510.info&(_4f3)))&&(((_510.info&(_4f3)))?_510:_510.isa).isa===(((_510.info&(_4f3)))?_510:_510.isa)){
class_addMethods((((_510.info&(_4f3)))?_510:_510.isa),_511);
}
};
class_getInstanceMethod=function(_517,_518){
if(!_517||!_518){
return NULL;
}
var _519=_517.method_dtable[_518];
return _519?_519:NULL;
};
class_getInstanceVariable=function(_51a,_51b){
if(!_51a||!_51b){
return NULL;
}
var _51c=_51a.ivar_dtable[_51b];
return _51c;
};
class_getClassMethod=function(_51d,_51e){
if(!_51d||!_51e){
return NULL;
}
var _51f=(((_51d.info&(_4f3)))?_51d:_51d.isa).method_dtable[_51e];
return _51f?_51f:NULL;
};
class_respondsToSelector=function(_520,_521){
return class_getClassMethod(_520,_521)!=NULL;
};
class_copyMethodList=function(_522){
return _522.method_list.slice(0);
};
class_getVersion=function(_523){
return _523.version;
};
class_setVersion=function(_524,_525){
_524.version=parseInt(_525,10);
};
class_replaceMethod=function(_526,_527,_528){
if(!_526||!_527){
return NULL;
}
var _529=_526.method_dtable[_527],_52a=NULL;
if(_529){
_52a=_529.method_imp;
}
_529.method_imp=_528;
return _52a;
};
var _52b=function(_52c){
var meta=(((_52c.info&(_4f3)))?_52c:_52c.isa);
if((_52c.info&(_4f3))){
_52c=objj_getClass(_52c.name);
}
if(_52c.super_class&&!((((_52c.super_class.info&(_4f3)))?_52c.super_class:_52c.super_class.isa).info&(_4f4))){
_52b(_52c.super_class);
}
if(!(meta.info&(_4f4))&&!(meta.info&(_4f5))){
meta.info=(meta.info|(_4f5))&~(0);
objj_msgSend(_52c,"initialize");
meta.info=(meta.info|(_4f4))&~(_4f5);
}
};
var _52d=function(self,_52e){
var isa=self.isa,_52f=isa.method_dtable[_530];
if(_52f){
var _531=_52f.method_imp.call(this,self,_530,_52e);
if(_531&&_531!==self){
arguments[0]=_531;
return objj_msgSend.apply(this,arguments);
}
}
_52f=isa.method_dtable[_532];
if(_52f){
var _533=isa.method_dtable[_534];
if(_533){
var _535=_52f.method_imp.call(this,self,_532,_52e);
if(_535){
var _536=objj_lookUpClass("CPInvocation");
if(_536){
var _537=objj_msgSend(_536,_538,_535),_97=0,_539=arguments.length;
for(;_97<_539;++_97){
objj_msgSend(_537,_53a,arguments[_97],_97);
}
_533.method_imp.call(this,self,_534,_537);
return objj_msgSend(_537,_53b);
}
}
}
}
_52f=isa.method_dtable[_53c];
if(_52f){
return _52f.method_imp.call(this,self,_53c,_52e);
}
throw class_getName(isa)+" does not implement doesNotRecognizeSelector:. Did you forget a superclass for "+class_getName(isa)+"?";
};
class_getMethodImplementation=function(_53d,_53e){
if(!((((_53d.info&(_4f3)))?_53d:_53d.isa).info&(_4f4))){
_52b(_53d);
}
var _53f=_53d.method_dtable[_53e];
var _540=_53f?_53f.method_imp:_52d;
return _540;
};
var _541={};
objj_allocateClassPair=function(_542,_543){
var _544=new objj_class(_543),_545=new objj_class(_543),_546=_544;
if(_542){
_546=_542;
while(_546.superclass){
_546=_546.superclass;
}
_544.allocator.prototype=new _542.allocator;
_544.ivar_dtable=_544.ivar_store.prototype=new _542.ivar_store;
_544.method_dtable=_544.method_store.prototype=new _542.method_store;
_545.method_dtable=_545.method_store.prototype=new _542.isa.method_store;
_544.super_class=_542;
_545.super_class=_542.isa;
}else{
_544.allocator.prototype=new objj_object();
}
_544.isa=_545;
_544.name=_543;
_544.info=_4f2;
_544._UID=objj_generateObjectUID();
_545.isa=_546.isa;
_545.name=_543;
_545.info=_4f3;
_545._UID=objj_generateObjectUID();
return _544;
};
var _4ab=nil;
objj_registerClassPair=function(_547){
_1[_547.name]=_547;
_541[_547.name]=_547;
_1c6(_547,_4ab);
};
objj_resetRegisterClasses=function(){
for(var key in _541){
delete _1[key];
}
_541={};
_1c9();
};
class_createInstance=function(_548){
if(!_548){
throw new Error("*** Attempting to create object with Nil class.");
}
var _549=new _548.allocator();
_549.isa=_548;
_549._UID=objj_generateObjectUID();
return _549;
};
var _54a=function(){
};
_54a.prototype.member=false;
with(new _54a()){
member=true;
}
if(new _54a().member){
var _54b=class_createInstance;
class_createInstance=function(_54c){
var _54d=_54b(_54c);
if(_54d){
var _54e=_54d.isa,_54f=_54e;
while(_54e){
var _550=_54e.ivar_list,_551=_550.length;
while(_551--){
_54d[_550[_551].name]=NULL;
}
_54e=_54e.super_class;
}
_54d.isa=_54f;
}
return _54d;
};
}
object_getClassName=function(_552){
if(!_552){
return "";
}
var _553=_552.isa;
return _553?class_getName(_553):"";
};
objj_lookUpClass=function(_554){
var _555=_541[_554];
return _555?_555:Nil;
};
objj_getClass=function(_556){
var _557=_541[_556];
if(!_557){
}
return _557?_557:Nil;
};
objj_getMetaClass=function(_558){
var _559=objj_getClass(_558);
return (((_559.info&(_4f3)))?_559:_559.isa);
};
ivar_getName=function(_55a){
return _55a.name;
};
ivar_getTypeEncoding=function(_55b){
return _55b.type;
};
objj_msgSend=function(_55c,_55d){
if(_55c==nil){
return nil;
}
var isa=_55c.isa;
if(!((((isa.info&(_4f3)))?isa:isa.isa).info&(_4f4))){
_52b(isa);
}
var _55e=isa.method_dtable[_55d];
var _55f=_55e?_55e.method_imp:_52d;
switch(arguments.length){
case 2:
return _55f(_55c,_55d);
case 3:
return _55f(_55c,_55d,arguments[2]);
case 4:
return _55f(_55c,_55d,arguments[2],arguments[3]);
}
return _55f.apply(_55c,arguments);
};
objj_msgSendSuper=function(_560,_561){
var _562=_560.super_class;
arguments[0]=_560.receiver;
if(!((((_562.info&(_4f3)))?_562:_562.isa).info&(_4f4))){
_52b(_562);
}
var _563=_562.method_dtable[_561];
var _564=_563?_563.method_imp:_52d;
return _564.apply(_560.receiver,arguments);
};
method_getName=function(_565){
return _565.name;
};
method_getImplementation=function(_566){
return _566.method_imp;
};
method_setImplementation=function(_567,_568){
var _569=_567.method_imp;
_567.method_imp=_568;
return _569;
};
method_exchangeImplementations=function(lhs,rhs){
var _56a=method_getImplementation(lhs),_56b=method_getImplementation(rhs);
method_setImplementation(lhs,_56b);
method_setImplementation(rhs,_56a);
};
sel_getName=function(_56c){
return _56c?_56c:"<null selector>";
};
sel_getUid=function(_56d){
return _56d;
};
sel_isEqual=function(lhs,rhs){
return lhs===rhs;
};
sel_registerName=function(_56e){
return _56e;
};
objj_class.prototype.toString=objj_object.prototype.toString=function(){
var isa=this.isa;
if(class_getInstanceMethod(isa,_56f)){
return objj_msgSend(this,_56f);
}
if(class_isMetaClass(isa)){
return this.name;
}
return "["+isa.name+" Object](-description not implemented)";
};
var _56f=sel_getUid("description"),_530=sel_getUid("forwardingTargetForSelector:"),_532=sel_getUid("methodSignatureForSelector:"),_534=sel_getUid("forwardInvocation:"),_53c=sel_getUid("doesNotRecognizeSelector:"),_538=sel_getUid("invocationWithMethodSignature:"),_570=sel_getUid("setTarget:"),_571=sel_getUid("setSelector:"),_53a=sel_getUid("setArgument:atIndex:"),_53b=sel_getUid("returnValue");
objj_eval=function(_572){
var url=_2.pageURL;
var _573=_2.asyncLoader;
_2.asyncLoader=NO;
var _574=_2.preprocess(_572,url,0);
if(!_574.hasLoadedFileDependencies()){
_574.loadFileDependencies();
}
_1._objj_eval_scope={};
_1._objj_eval_scope.objj_executeFile=_2a7.fileExecuterForURL(url);
_1._objj_eval_scope.objj_importFile=_2a7.fileImporterForURL(url);
var code="with(_objj_eval_scope){"+_574._code+"\n//*/\n}";
var _575;
_575=eval(code);
_2.asyncLoader=_573;
return _575;
};
_2.objj_eval=objj_eval;
_15c();
var _576=new CFURL(window.location.href),_577=document.getElementsByTagName("base"),_578=_577.length;
if(_578>0){
var _579=_577[_578-1],_57a=_579&&_579.getAttribute("href");
if(_57a){
_576=new CFURL(_57a,_576);
}
}
var _57b=new CFURL(window.OBJJ_MAIN_FILE||"main.j"),_1c5=new CFURL(".",new CFURL(_57b,_576)).absoluteURL(),_57c=new CFURL("..",_1c5).absoluteURL();
if(_1c5===_57c){
_57c=new CFURL(_57c.schemeAndAuthority());
}
_1ac.resourceAtURL(_57c,YES);
_2.pageURL=_576;
_2.bootstrap=function(){
_57d();
};
function _57d(){
_1ac.resolveResourceAtURL(_1c5,YES,function(_57e){
var _57f=_1ac.includeURLs(),_97=0,_580=_57f.length;
for(;_97<_580;++_97){
_57e.resourceAtURL(_57f[_97],YES);
}
_2a7.fileImporterForURL(_1c5)(_57b.lastPathComponent(),YES,function(){
_15d();
_586(function(){
var _581=window.location.hash.substring(1),args=[];
if(_581.length){
args=_581.split("/");
for(var i=0,_580=args.length;i<_580;i++){
args[i]=decodeURIComponent(args[i]);
}
}
var _582=window.location.search.substring(1).split("&"),_583=new CFMutableDictionary();
for(var i=0,_580=_582.length;i<_580;i++){
var _584=_582[i].split("=");
if(!_584[0]){
continue;
}
if(_584[1]==null){
_584[1]=true;
}
_583.setValueForKey(decodeURIComponent(_584[0]),decodeURIComponent(_584[1]));
}
main(args,_583);
});
});
});
};
var _585=NO;
function _586(_587){
if(_585||document.readyState==="complete"){
return _587();
}
if(window.addEventListener){
window.addEventListener("load",_587,NO);
}else{
if(window.attachEvent){
window.attachEvent("onload",_587);
}
}
};
_586(function(){
_585=YES;
});
if(typeof OBJJ_AUTO_BOOTSTRAP==="undefined"||OBJJ_AUTO_BOOTSTRAP){
_2.bootstrap();
}
function _1bf(aURL){
if(aURL instanceof CFURL&&aURL.scheme()){
return aURL;
}
return new CFURL(aURL,_1c5);
};
objj_importFile=_2a7.fileImporterForURL(_1c5);
objj_executeFile=_2a7.fileExecuterForURL(_1c5);
objj_import=function(){
CPLog.warn("objj_import is deprecated, use objj_importFile instead");
objj_importFile.apply(this,arguments);
};
})(window,ObjectiveJ);
