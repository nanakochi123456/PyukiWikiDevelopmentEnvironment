/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */

eval(function(p,a,c,k,e,d){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('14.2m.G=r(a){$.G(t,a);u t};14.G=r(a,b){9 a=$(a).O(0);u a.G||(a.G=2l 14.1I(a,b))};14.1I=r(a,d){9 b=t;$(a).1o(\'<z P="G"><z P="v"></z><z P="11"></z><z P="2k"></z><z P="h-L L"></z><z P="1B-L L"></z></z>\');9 c=$(".G",a);b.11=$(".11",a).O(0);b.1g=2j;b.K=2i;b.F=2h;8(2g.2f.2e(/2d [0-6]\\./)){$("*",c).1x(r(){8(t.1s.13!="1H"){9 e=t.1s.13;e=t.1s.13.D(5,e.19-2);$(t).T({13:"1H",2c:"2b:2a.29.27(26=1E, 25=24, 23=\'"+e+"\')"})}})}b.1t=r(e){8(B b.w=="1f"){$(b.w).1k("1G",b.1r)}b.v=22;8(B e=="r"){b.w=e}R{8(B e=="1f"||B e=="21"){b.w=$(e);b.w.1n("1G",b.1r);8(b.w.O(0).C){b.V(b.w.O(0).C)}}}u t};b.1r=r(e){8(t.C&&t.C!=b.v){b.V(t.C)}};b.V=r(e){9 f=b.1w(e);8(b.v!=e&&f){b.v=e;b.12=f;b.A=b.1u(b.12);b.1h()}u t};b.1l=r(e){b.A=e;b.12=b.18(e);b.v=b.1b(b.12);b.1h();u t};b.1m=r(i){9 g,m;9 h=i.20||i.1Z;9 f=b.11;8(B i.1F!="Z"){9 l={x:i.1F,y:i.1Y};9 j=h;1q(j){j.10=l.x;j.1p=l.y;l.x+=j.1e;l.y+=j.1d;j=j.S}9 j=f;9 k={x:0,y:0};1q(j){8(B j.10!="Z"){g=j.10-k.x;m=j.1p-k.y;1X}k.x+=j.1e;k.y+=j.1d;j=j.S}j=h;1q(j){j.10=Z;j.1p=Z;j=j.S}}R{9 l=b.1c(f);g=(i.1W||0*(i.1V+$("1o").O(0).1U))-l.x;m=(i.1T||0*(i.1S+$("1o").O(0).1R))-l.y}u{x:g-b.F/2,y:m-b.F/2}};b.17=r(e){8(!M.1j){$(M).1n("N",b.N).1n("U",b.U);M.1j=1E}9 f=b.1m(e);b.1C=s.Q(s.1D(f.x),s.1D(f.y))*2>b.K;b.N(e);u 1i};b.N=r(h){9 i=b.1m(h);8(b.1C){9 g=s.1Q(i.x,-i.y)/6.28;8(g<0){g+=1}b.1l([g,b.A[1],b.A[2]])}R{9 f=s.Q(0,s.W(1,-(i.x/b.K)+0.5));9 e=s.Q(0,s.W(1,-(i.y/b.K)+0.5));b.1l([b.A[0],f,e])}u 1i};b.U=r(){$(M).1k("N",b.N);$(M).1k("U",b.U);M.1j=1i};b.1h=r(){9 e=b.A[0]*6.28;$(".h-L",c).T({1A:s.E(s.1P(e)*b.1g+b.F/2)+"Y",1z:s.E(-s.1O(e)*b.1g+b.F/2)+"Y"});$(".1B-L",c).T({1A:s.E(b.K*(0.5-b.A[1])+b.F/2)+"Y",1z:s.E(b.K*(0.5-b.A[2])+b.F/2)+"Y"});$(".v",c).T("1y",b.1b(b.18([b.A[0],1,0.5])));8(B b.w=="1f"){$(b.w).T({1y:b.v,v:b.A[2]>0.5?"#1N":"#1M"});$(b.w).1x(r(){8(t.C&&t.C!=b.v){t.C=b.v}})}R{8(B b.w=="r"){b.w.1L(b,b.v)}}};b.1c=r(f){9 g={x:f.1e,y:f.1d};8(f.S){9 e=b.1c(f.S);g.x+=e.x;g.y+=e.y}u g};b.1b=r(f){9 i=s.E(f[0]*J);9 h=s.E(f[1]*J);9 e=s.E(f[2]*J);u"#"+(i<16?"0":"")+i.1a(16)+(h<16?"0":"")+h.1a(16)+(e<16?"0":"")+e.1a(16)};b.1w=r(e){8(e.19==7){u[I("H"+e.D(1,3))/J,I("H"+e.D(3,5))/J,I("H"+e.D(5,7))/J]}R{8(e.19==4){u[I("H"+e.D(1,2))/15,I("H"+e.D(2,3))/15,I("H"+e.D(3,4))/15]}}};b.18=r(m){9 o,n,e,j,k;9 i=m[0],p=m[1],f=m[2];n=(f<=0.5)?f*(p+1):f+p-f*p;o=f*2-n;u[t.X(o,n,i+0.1v),t.X(o,n,i),t.X(o,n,i-0.1v)]};b.X=r(f,e,g){g=(g<0)?g+1:((g>1)?g-1:g);8(g*6<1){u f+(e-f)*g*6}8(g*2<1){u e}8(g*3<2){u f+(e-f)*(0.1K-g)*6}u f};b.1u=r(m){9 i,o,p,j,q,f;9 e=m[0],k=m[1],n=m[2];i=s.W(e,s.W(k,n));o=s.Q(e,s.Q(k,n));p=o-i;f=(i+o)/2;q=0;8(f>0&&f<1){q=p/(f<0.5?(2*f):(2-2*f))}j=0;8(p>0){8(o==e&&o!=k){j+=(k-n)/p}8(o==k&&o!=n){j+=(2+(n-e)/p)}8(o==n&&o!=e){j+=(4+(e-k)/p)}j/=6}u[j,q,f]};$("*",c).17(b.17);b.V("#1J");8(d){b.1t(d)}};',62,147,'||||||||if|var||||||||||||||||||function|Math|this|return|color|callback|||div|hsl|typeof|value|substring|round|width|farbtastic|0x|parseInt|255|square|marker|document|mousemove|get|class|max|else|offsetParent|css|mouseup|setColor|min|hueToRGB|px|undefined|mouseX|wheel|rgb|backgroundImage|jQuery|||mousedown|HSLToRGB|length|toString|pack|absolutePosition|offsetTop|offsetLeft|object|radius|updateDisplay|false|dragging|unbind|setHSL|widgetCoords|bind|html|mouseY|while|updateValue|currentStyle|linkTo|RGBToHSL|33333|unpack|each|backgroundColor|top|left|sl|circleDrag|abs|true|offsetX|keyup|none|_farbtastic|000000|66666|call|fff|000|cos|sin|atan2|scrollTop|clientY|pageY|scrollLeft|clientX|pageX|break|offsetY|srcElement|target|string|null|src|crop|sizingMethod|enabled|AlphaImageLoader||Microsoft|DXImageTransform|progid|filter|MSIE|match|appVersion|navigator|194|100|84|overlay|new|fn'.split('|')))