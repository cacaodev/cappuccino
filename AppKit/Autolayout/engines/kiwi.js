/*-----------------------------------------------------------------------------
| Copyright (c) 2014-2018, Nucleic Development Team & H. Rutjes.
|
| Distributed under the terms of the Modified BSD License.
|
| The full license is in the file COPYING.txt, distributed with this software.
-----------------------------------------------------------------------------*/
!function(a,b){"function"==typeof define&&define.amd?define([],function(){return a.kiwi=b()}):"object"==typeof module&&module.exports?module.exports=b():a.kiwi=b()}(this,function(){var a;!function(a){function b(a){return a instanceof Array?new f(a):a.__iter__()}function c(a){return a instanceof Array?new g(a):a.__reversed__()}function d(a){return a.__next__()}function e(a,b){if(a instanceof Array){for(var c=0,d=a.length;c<d;++c)if(!1===b(a[c]))return}else for(var e,f=a.__iter__();void 0!==(e=f.__next__());)if(!1===b(e))return}var f=function(){function a(a,b){void 0===b&&(b=0),this._array=a,this._index=Math.max(0,Math.min(b,a.length))}return a.prototype.__next__=function(){return this._array[this._index++]},a.prototype.__iter__=function(){return this},a}();a.ArrayIterator=f;var g=function(){function a(a,b){void 0===b&&(b=a.length),this._array=a,this._index=Math.max(0,Math.min(b,a.length))}return a.prototype.__next__=function(){return this._array[--this._index]},a.prototype.__iter__=function(){return this},a}();a.ReverseArrayIterator=g,a.iter=b,a.reversed=c,a.next=d,a.forEach=e}(a||(a={}));var a;!function(a){var b=function(){function a(a,b){this.first=a,this.second=b}return a.prototype.copy=function(){return new a(this.first,this.second)},a}();a.Pair=b}(a||(a={}));var a;!function(a){function b(a,b,c){for(var d,e,f=0,g=a.length;g>0;)d=g>>1,e=f+d,c(a[e],b)<0?(f=e+1,g-=d+1):g=d;return f}function c(a,c,d){var e=b(a,c,d);return e===a.length?-1:0!==d(a[e],c)?-1:e}function d(a,c,d){var e=b(a,c,d);if(e!==a.length){var f=a[e];if(0===d(f,c))return f}}a.lowerBound=b,a.binarySearch=c,a.binaryFind=d}(a||(a={}));var a;!function(a){var b=function(){function b(){this._array=[]}return b.prototype.size=function(){return this._array.length},b.prototype.empty=function(){return 0===this._array.length},b.prototype.itemAt=function(a){return this._array[a]},b.prototype.takeAt=function(a){return this._array.splice(a,1)[0]},b.prototype.clear=function(){this._array=[]},b.prototype.swap=function(a){var b=this._array;this._array=a._array,a._array=b},b.prototype.__iter__=function(){return a.iter(this._array)},b.prototype.__reversed__=function(){return a.reversed(this._array)},b}();a.ArrayBase=b}(a||(a={}));var a,b=this.__extends||function(a,b){function c(){this.constructor=a}for(var d in b)b.hasOwnProperty(d)&&(a[d]=b[d]);c.prototype=b.prototype,a.prototype=new c};!function(a){function c(a){return function(b,c){return a(b.first,c)}}function d(a,b,c){for(var d=0,e=0,f=a.length,g=b.length,h=[];d<f&&e<g;){var i=a[d],j=b[e],k=c(i.first,j.first);k<0?(h.push(i.copy()),++d):k>0?(h.push(j.copy()),++e):(h.push(j.copy()),++d,++e)}for(;d<f;)h.push(a[d].copy()),++d;for(;e<g;)h.push(b[e].copy()),++e;return h}var e=function(e){function f(a){e.call(this),this._compare=a,this._wrapped=c(a)}return b(f,e),f.prototype.comparitor=function(){return this._compare},f.prototype.indexOf=function(b){return a.binarySearch(this._array,b,this._wrapped)},f.prototype.contains=function(b){return a.binarySearch(this._array,b,this._wrapped)>=0},f.prototype.find=function(b){return a.binaryFind(this._array,b,this._wrapped)},f.prototype.setDefault=function(b,c){var d=this._array,e=a.lowerBound(d,b,this._wrapped);if(e===d.length){var f=new a.Pair(b,c());return d.push(f),f}var g=d[e];if(0!==this._compare(g.first,b)){var f=new a.Pair(b,c());return d.splice(e,0,f),f}return g},f.prototype.insert=function(b,c){var d=this._array,e=a.lowerBound(d,b,this._wrapped);if(e===d.length){var f=new a.Pair(b,c);return d.push(f),f}var g=d[e];if(0!==this._compare(g.first,b)){var f=new a.Pair(b,c);return d.splice(e,0,f),f}return g.second=c,g},f.prototype.update=function(b){var c=this;if(b instanceof f){var e=b;this._array=d(this._array,e._array,this._compare)}else a.forEach(b,function(a){c.insert(a.first,a.second)})},f.prototype.erase=function(b){var c=this._array,d=a.binarySearch(c,b,this._wrapped);if(!(d<0))return c.splice(d,1)[0]},f.prototype.copy=function(){for(var a=new f(this._compare),b=a._array,c=this._array,d=0,e=c.length;d<e;++d)b.push(c[d].copy());return a},f}(a.ArrayBase);a.AssociativeArray=e}(a||(a={}));var c;!function(a){!function(a){a[a.Le=0]="Le",a[a.Ge=1]="Ge",a[a.Eq=2]="Eq"}(a.Operator||(a.Operator={}));var b=function(){function b(b,d,e,f){void 0===f&&(f=a.Strength.required),this._id=c++,this._operator=d,this._strength=a.Strength.clip(f),void 0===e&&b instanceof a.Expression?this._expression=b:this._expression=b.minus(e)}return b.Compare=function(a,b){return a.id()-b.id()},b.prototype.id=function(){return this._id},b.prototype.expression=function(){return this._expression},b.prototype.op=function(){return this._operator},b.prototype.strength=function(){return this._strength},b.prototype.toString=function(){return this._expression.toString()+" "+["<=",">=","="][this._operator]+" 0 ("+this._strength.toString()+")"},b}();a.Constraint=b;var c=0}(c||(c={}));var c;!function(b){function c(b){return new a.AssociativeArray(b)}b.createMap=c}(c||(c={}));var c;!function(a){var b=function(){function b(a){void 0===a&&(a=""),this._value=0,this._context=null,this._id=c++,this._dirty=!1,this._name=a}return b.Compare=function(a,b){return a.id()-b.id()},b.prototype.id=function(){return this._id},b.prototype.name=function(){return this._name},b.prototype.setName=function(a){this._name=a},b.prototype.context=function(){return this._context},b.prototype.setContext=function(a){this._context=a},b.prototype.value=function(){return this._value},b.prototype.setValue=function(a){this._value=a},b.prototype.plus=function(b){return new a.Expression(this,b)},b.prototype.minus=function(b){return new a.Expression(this,"number"==typeof b?-b:[-1,b])},b.prototype.multiply=function(b){return new a.Expression([b,this])},b.prototype.divide=function(b){return new a.Expression([1/b,this])},b.prototype.toJSON=function(){return{name:this._name,value:this._value}},b.prototype.toString=function(){return this._context.prefix+"["+this._name+":"+this._value+"]"},b}();a.Variable=b;var c=0}(c||(c={}));var c;!function(a){function b(b){for(var d=0,e=function(){return 0},f=a.createMap(a.Variable.Compare),g=0,h=b.length;g<h;++g){var i=b[g];if("number"==typeof i)d+=i;else if(i instanceof a.Variable)f.setDefault(i,e).second+=1;else if(i instanceof c){d+=i.constant();for(var j=i.terms(),k=0,l=j.size();k<l;k++){var m=j.itemAt(k);f.setDefault(m.first,e).second+=m.second}}else{if(!(i instanceof Array))throw new Error("invalid Expression argument: "+i);if(2!==i.length)throw new Error("array must have length 2");var n=i[0],o=i[1];if("number"!=typeof n)throw new Error("array item 0 must be a number");if(o instanceof a.Variable)f.setDefault(o,e).second+=n;else{if(!(o instanceof c))throw new Error("array item 1 must be a variable or expression");d+=o.constant()*n;for(var j=o.terms(),k=0,l=j.size();k<l;k++){var m=j.itemAt(k);f.setDefault(m.first,e).second+=m.second*n}}}}return{terms:f,constant:d}}var c=function(){function a(){var a=b(arguments);this._terms=a.terms,this._constant=a.constant}return a.prototype.terms=function(){return this._terms},a.prototype.constant=function(){return this._constant},a.prototype.value=function(){for(var a=this._constant,b=0,c=this._terms.size();b<c;b++){var d=this._terms.itemAt(b);a+=d.first.value()*d.second}return a},a.prototype.plus=function(b){return new a(this,b)},a.prototype.minus=function(b){return new a(this,"number"==typeof b?-b:[-1,b])},a.prototype.multiply=function(b){return new a([b,this])},a.prototype.divide=function(b){return new a([1/b,this])},a.prototype.isConstant=function(){return 0==this._terms.size()},a.prototype.toString=function(){var a=this._terms._array.map(function(a,b){var c="",d=a.second;return 0!==d&&(1!==d&&(c+=d+"*"),c+=a.first.toString()),c}).join(" + "),b=this._constant;return 0!==b&&(this.isConstant()?a+=b:a+=(b<0?" - ":" + ")+Math.abs(b)),a},a}();a.Expression=c}(c||(c={}));var c;!function(a){!function(a){function b(a,b,c,d,e,f,g){void 0===g&&(g=1);var h=0;return h+=Math.max(0,Math.min(1e3,a*g))*Math.pow(10,15),h+=Math.max(0,Math.min(1e3,b*g))*Math.pow(10,12),h+=Math.max(0,Math.min(1e3,c*g))*Math.pow(10,9),h+=Math.max(0,Math.min(1e3,d*g))*Math.pow(10,6),h+=Math.max(0,Math.min(1e3,e*g))*Math.pow(10,3),h+=Math.max(0,Math.min(1e3,f*g))}function c(b){return Math.max(0,Math.min(a.required,b))}a.create=b,a.required=b(1e3,1e3,1e3,1e3,1e3,1e3),a.strong=b(0,0,0,1,0,0),a.medium=b(0,0,0,0,1,0),a.weak=b(0,0,0,0,0,1),a.clip=c}(a.Strength||(a.Strength={}))}(c||(c={}));var c;return function(a){function b(a){return a<0?-a<1e-8:a<1e-8}function c(){return a.createMap(a.Constraint.Compare)}function d(){return a.createMap(i.Compare)}function e(){return a.createMap(a.Variable.Compare)}function f(){return a.createMap(a.Variable.Compare)}var g=function(){function g(){this._cnMap=c(),this._rowMap=d(),this._varMap=e(),this._editMap=f(),this._infeasibleRows=[],this._objective=new k,this._artificial=null,this._idTick=0}return g.prototype.createConstraint=function(b,c,d,e){void 0===e&&(e=a.Strength.required);var f=new a.Constraint(b,c,d,e);return this.addConstraint(f),f},g.prototype.addConstraint=function(a){if(void 0!==this._cnMap.find(a))throw new Error("duplicate constraint");var c=this._createRow(a),d=c.row,e=c.tag,f=this._chooseSubject(d,e);if(f.type()===h.Invalid&&d.allDummies()){if(!b(d.constant()))throw new Error("unsatisfiable constraint");f=e.marker}if(f.type()===h.Invalid){if(!this._addWithArtificialVariable(d))throw new Error("unsatisfiable constraint")}else d.solveFor(f),this._substitute(f,d),this._rowMap.insert(f,d);this._cnMap.insert(a,e),this._optimize(this._objective)},g.prototype.removeConstraint=function(a){var b=this._cnMap.erase(a);if(void 0===b)throw new Error("unknown constraint");this._removeConstraintEffects(a,b.second);var c=b.second.marker,d=this._rowMap.erase(c);if(void 0===d){var e=this._getMarkerLeavingSymbol(c);if(e.type()===h.Invalid)throw new Error("failed to find leaving row");d=this._rowMap.erase(e),d.second.solveForEx(e,c),this._substitute(c,d.second)}this._optimize(this._objective)},g.prototype.hasConstraint=function(a){return this._cnMap.contains(a)},g.prototype.addEditVariable=function(b,c){if(void 0!==this._editMap.find(b))throw new Error("duplicate edit variable");if((c=a.Strength.clip(c))===a.Strength.required)throw new Error("bad required strength");var d=new a.Expression(b),e=new a.Constraint(d,a.Operator.Eq,void 0,c);this.addConstraint(e);var f=this._cnMap.find(e).second,g={tag:f,constraint:e,constant:0};this._editMap.insert(b,g)},g.prototype.removeEditVariable=function(a){var b=this._editMap.erase(a);if(void 0===b)throw new Error("unknown edit variable");this.removeConstraint(b.second.constraint)},g.prototype.hasEditVariable=function(a){return this._editMap.contains(a)},g.prototype.suggestValue=function(a,b){var c=this._editMap.find(a);if(void 0===c)throw new Error("unknown edit variable");var d=this._rowMap,e=c.second,f=b-e.constant;e.constant=b;var g=e.tag.marker,i=d.find(g);if(void 0!==i)return i.second.add(-f)<0&&this._infeasibleRows.push(g),void this._dualOptimize();var j=e.tag.other;if(void 0!==(i=d.find(j)))return i.second.add(f)<0&&this._infeasibleRows.push(j),void this._dualOptimize();for(var k=0,l=d.size();k<l;++k){var m=d.itemAt(k),n=m.second,o=n.coefficientFor(g);0!==o&&n.add(f*o)<0&&m.first.type()!==h.External&&this._infeasibleRows.push(m.first)}this._dualOptimize()},g.prototype.updateVariables=function(){for(var a=this._varMap,b=this._rowMap,c=0,d=a.size();c<d;++c){var e=a.itemAt(c),f=e.first,g=b.find(e.second),h=0;void 0!==g&&(h=g.second.constant()),f.value()!==h&&(f.setValue(h),this._onsolved(f))}},g.prototype.setOnSolved=function(a){this._onsolved=a},g.prototype._getVarSymbol=function(a){var b=this,c=function(){return b._makeSymbol(h.External)};return this._varMap.setDefault(a,c).second},g.prototype._createRow=function(c){for(var d=c.expression(),e=new k(d.constant()),f=d.terms(),g=0,i=f.size();g<i;++g){var l=f.itemAt(g);if(!b(l.second)){var m=this._getVarSymbol(l.first),n=this._rowMap.find(m);void 0!==n?e.insertRow(n.second,l.second):e.insertSymbol(m,l.second)}}var o=this._objective,p=c.strength(),q={marker:j,other:j};switch(c.op()){case a.Operator.Le:case a.Operator.Ge:var r=c.op()===a.Operator.Le?1:-1,s=this._makeSymbol(h.Slack);if(q.marker=s,e.insertSymbol(s,r),p<a.Strength.required){var t=this._makeSymbol(h.Error);q.other=t,e.insertSymbol(t,-r),o.insertSymbol(t,p)}break;case a.Operator.Eq:if(p<a.Strength.required){var u=this._makeSymbol(h.Error),v=this._makeSymbol(h.Error);q.marker=u,q.other=v,e.insertSymbol(u,-1),e.insertSymbol(v,1),o.insertSymbol(u,p),o.insertSymbol(v,p)}else{var w=this._makeSymbol(h.Dummy);q.marker=w,e.insertSymbol(w)}}return e.constant()<0&&e.reverseSign(),{row:e,tag:q}},g.prototype._chooseSubject=function(a,b){for(var c=a.cells(),d=0,e=c.size();d<e;++d){var f=c.itemAt(d);if(f.first.type()===h.External)return f.first}var g=b.marker.type();return(g===h.Slack||g===h.Error)&&a.coefficientFor(b.marker)<0?b.marker:(g=b.other.type(),(g===h.Slack||g===h.Error)&&a.coefficientFor(b.other)<0?b.other:j)},g.prototype._addWithArtificialVariable=function(a){var c=this._makeSymbol(h.Slack);this._rowMap.insert(c,a.copy()),this._artificial=a.copy(),this._optimize(this._artificial);var d=b(this._artificial.constant());this._artificial=null;var e=this._rowMap.erase(c);if(void 0!==e){var f=e.second;if(f.isConstant())return d;var g=this._anyPivotableSymbol(f);if(g.type()===h.Invalid)return!1;f.solveForEx(c,g),this._substitute(g,f),this._rowMap.insert(g,f)}for(var i=this._rowMap,j=0,k=i.size();j<k;++j)i.itemAt(j).second.removeSymbol(c);return this._objective.removeSymbol(c),d},g.prototype._substitute=function(a,b){for(var c=this._rowMap,d=0,e=c.size();d<e;++d){var f=c.itemAt(d);f.second.substitute(a,b),f.second.constant()<0&&f.first.type()!==h.External&&this._infeasibleRows.push(f.first)}this._objective.substitute(a,b),this._artificial&&this._artificial.substitute(a,b)},g.prototype._optimize=function(a){for(;;){var b=this._getEnteringSymbol(a);if(b.type()===h.Invalid)return;var c=this._getLeavingSymbol(b);if(c.type()===h.Invalid)throw new Error("the objective is unbounded");var d=this._rowMap.erase(c).second;d.solveForEx(c,b),this._substitute(b,d),this._rowMap.insert(b,d)}},g.prototype._dualOptimize=function(){for(var a=this._rowMap,b=this._infeasibleRows;0!==b.length;){var c=b.pop(),d=a.find(c);if(void 0!==d&&d.second.constant()<0){var e=this._getDualEnteringSymbol(d.second);if(e.type()===h.Invalid)throw new Error("dual optimize failed");var f=d.second;a.erase(c),f.solveForEx(c,e),this._substitute(e,f),a.insert(e,f)}}},g.prototype._getEnteringSymbol=function(a){for(var b=a.cells(),c=0,d=b.size();c<d;++c){var e=b.itemAt(c),f=e.first;if(e.second<0&&f.type()!==h.Dummy)return f}return j},g.prototype._getDualEnteringSymbol=function(a){for(var b=Number.MAX_VALUE,c=j,d=a.cells(),e=0,f=d.size();e<f;++e){var g=d.itemAt(e),i=g.first,k=g.second;if(k>0&&i.type()!==h.Dummy){var l=this._objective.coefficientFor(i),m=l/k;m<b&&(b=m,c=i)}}return c},g.prototype._getLeavingSymbol=function(a){for(var b=Number.MAX_VALUE,c=j,d=this._rowMap,e=0,f=d.size();e<f;++e){var g=d.itemAt(e),i=g.first;if(i.type()!==h.External){var k=g.second,l=k.coefficientFor(a);if(l<0){var m=-k.constant()/l;m<b&&(b=m,c=i)}}}return c},g.prototype._getMarkerLeavingSymbol=function(a){for(var b=Number.MAX_VALUE,c=b,d=b,e=j,f=e,g=e,i=e,k=this._rowMap,l=0,m=k.size();l<m;++l){var n=k.itemAt(l),o=n.second,p=o.coefficientFor(a);if(0!==p){var q=n.first;if(q.type()===h.External)i=q;else if(p<0){var r=-o.constant()/p;r<c&&(c=r,f=q)}else{var r=o.constant()/p;r<d&&(d=r,g=q)}}}return f!==e?f:g!==e?g:i},g.prototype._removeConstraintEffects=function(a,b){b.marker.type()===h.Error&&this._removeMarkerEffects(b.marker,a.strength()),b.other.type()===h.Error&&this._removeMarkerEffects(b.other,a.strength())},g.prototype._removeMarkerEffects=function(a,b){var c=this._rowMap.find(a);void 0!==c?this._objective.insertRow(c.second,-b):this._objective.insertSymbol(a,-b)},g.prototype._anyPivotableSymbol=function(a){for(var b=a.cells(),c=0,d=b.size();c<d;++c){var e=b.itemAt(c),f=e.first.type();if(f===h.Slack||f===h.Error)return e.first}return j},g.prototype._makeSymbol=function(a){return new i(a,this._idTick++)},g}();a.Solver=g;var h;!function(a){a[a.Invalid=0]="Invalid",a[a.External=1]="External",a[a.Slack=2]="Slack",a[a.Error=3]="Error",a[a.Dummy=4]="Dummy"}(h||(h={}));var i=function(){function a(a,b){this._id=b,this._type=a}return a.Compare=function(a,b){return a.id()-b.id()},a.prototype.id=function(){return this._id},a.prototype.type=function(){return this._type},a}(),j=new i(h.Invalid,-1),k=function(){function c(b){void 0===b&&(b=0),this._cellMap=a.createMap(i.Compare),this._constant=b}return c.prototype.cells=function(){return this._cellMap},c.prototype.constant=function(){return this._constant},c.prototype.isConstant=function(){return this._cellMap.empty()},c.prototype.allDummies=function(){for(var a=this._cellMap,b=0,c=a.size();b<c;++b){if(a.itemAt(b).first.type()!==h.Dummy)return!1}return!0},c.prototype.copy=function(){var a=new c(this._constant);return a._cellMap=this._cellMap.copy(),a},c.prototype.add=function(a){return this._constant+=a},c.prototype.insertSymbol=function(a,c){void 0===c&&(c=1),b(this._cellMap.setDefault(a,function(){return 0}).second+=c)&&this._cellMap.erase(a)},c.prototype.insertRow=function(a,b){void 0===b&&(b=1),this._constant+=a._constant*b;for(var c=a._cellMap,d=0,e=c.size();d<e;++d){var f=c.itemAt(d);this.insertSymbol(f.first,f.second*b)}},c.prototype.removeSymbol=function(a){this._cellMap.erase(a)},c.prototype.reverseSign=function(){this._constant=-this._constant;for(var a=this._cellMap,b=0,c=a.size();b<c;++b){var d=a.itemAt(b);d.second=-d.second}},c.prototype.solveFor=function(a){var b=this._cellMap,c=b.erase(a),d=-1/c.second;this._constant*=d;for(var e=0,f=b.size();e<f;++e)b.itemAt(e).second*=d},c.prototype.solveForEx=function(a,b){this.insertSymbol(a,-1),this.solveFor(b)},c.prototype.coefficientFor=function(a){var b=this._cellMap.find(a);return void 0!==b?b.second:0},c.prototype.substitute=function(a,b){var c=this._cellMap.erase(a);void 0!==c&&this.insertRow(b,c.second)},c}()}(c||(c={})),c});