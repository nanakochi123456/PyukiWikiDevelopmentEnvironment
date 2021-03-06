/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */



var w=window, d=w.document,
	x=0, y=0, ax=0, ay=0,
	h=0, f=0;


	w.oncontextmenu=dmy;



function initVideoSize(x_value, y_value, height, foot) {

	x=x_value;
	y=y_value;
	f=foot;
	var num1 = x_value;
	var num2 = y_value;
	var i = 1, bigNum, smlNum, ansNum;

	if(num1 > num2){
		bigNum = num1;
		smlNum = num2;
	} else {
		bigNum = num2;
		smlNum = num1;
	}

	a = bigNum;
	b = smlNum;

	if(ax == 0 && ay == 0) {
		if(num1 > 0 && num2 > 0){
			while(i > 0){
				if(a % b == 0){
					i = 0;
					ansNum = b;
				} else {
					a = a % b;
				}

				if(i != 0){
					if(b % a == 0){
						i = 0;
						ansNum = a;
					} else {
						b = b % a;
					}
				}
			}
			ax = num1 / ansNum;
			ay = num2 / ansNum;
		}
	}
	if(h == 0) {
		h=height;
	}
	resizeTo(x + h, y + f);
}

function resize() {
	initVideoSize(getBrowserWidth(), getBrowserHeight(), f);
}

function getBrowserWidth() {
        if ( w.innerWidth ) {
                return w.innerWidth;
        }
        else if ( d.documentElement && d.documentElement.clientWidth != 0 ) {
                return d.documentElement.clientWidth;
        }
        else if ( d.body ) {
                return d.body.clientWidth;
        }
        return 0;
}

function getBrowserHeight() {
        if ( w.innerHeight ) {
                return w.innerHeight;
        }
        else if ( d.documentElement && d.documentElement.clientHeight != 0 ) {
                return d.documentElement.clientHeight;
        }
        else if ( d.body ) {
                return d.body.clientHeight;
        }
        return 0;
}



function dmy() {
	return false;
}
function startflowplayer(id, swf, flv, auto, loop, fullscreen) {
	flowplayer(id, swf,
			{
				clip: {
					url: flv,
					autoPlay: auto,
					autoBuffering: true,
					scaling: 'fit'
				},
				canvas: {
					backgroundColor: '#000000',
					backgroundGradient: 'none'
			},
			plugins: {
				controls: {
					height: 24,
					play:true,
					stop:true,
					volume:true,
					mute:true,
					time:true,
					loop: loop,
					fullscreen:fullscreen,
					volumeSliderColor: '#000000',
					tooltipColor: '#5F747C',
					progressColor: '#112233',
					bufferColor: '#445566',
					buttonColor: '#5F747C',
					sliderColor: '#000000',
					backgroundGradient: 'high',
					durationColor: '#ffffff',
					backgroundColor: '#222222',
					progressGradient: 'medium',
					borderRadius: '0',
					buttonOverColor: '#728B94',
					bufferGradient: 'none',
					timeBgColor: '#555555',
					sliderGradient: 'none',
					volumeSliderGradient: 'none',
					tooltipTextColor: '#ffffff',
					timeColor: '#01DAFF'
				 }
			}
		}
	);
}

function startflowplayer_noauto(swf, flv) {
	flowplayer("player", swf,
			{
				clip: {
					url: flv,
					autoPlay: true,
					autoBuffering: true,
					scaling: 'fit'
				},
				canvas: {
					backgroundColor: '#000000',
					backgroundGradient: 'none'
			},
			plugins: {
				controls: {
					height: 24,
					play:true,
					stop:true,
					volume:true,
					mute:true,
					time:true,
					fullscreen:true,
					volumeSliderColor: '#000000',
					tooltipColor: '#5F747C',
					progressColor: '#112233',
					bufferColor: '#445566',
					buttonColor: '#5F747C',
					sliderColor: '#000000',
					backgroundGradient: 'high',
					durationColor: '#ffffff',
					backgroundColor: '#222222',
					progressGradient: 'medium',
					borderRadius: '0',
					buttonOverColor: '#728B94',
					bufferGradient: 'none',
					timeBgColor: '#555555',
					sliderGradient: 'none',
					volumeSliderGradient: 'none',
					tooltipTextColor: '#ffffff',
					timeColor: '#01DAFF'
				 }
			}
		}
	);
}

function startflowplayer_noauto_loop(swf, flv) {
	flowplayer("player", swf,
			{
				clip: {
					url: flv,
					autoPlay: true,
					autoBuffering: true,
					scaling: 'fit'
				},
				canvas: {
					backgroundColor: '#000000',
					backgroundGradient: 'none'
			},
			plugins: {
				controls: {
					height: 24,
					play:true,
					stop:true,
					volume:true,
					mute:true,
					time:true,
					loop: true,
					fullscreen:true,
					volumeSliderColor: '#000000',
					tooltipColor: '#5F747C',
					progressColor: '#112233',
					bufferColor: '#445566',
					buttonColor: '#5F747C',
					sliderColor: '#000000',
					backgroundGradient: 'high',
					durationColor: '#ffffff',
					backgroundColor: '#222222',
					progressGradient: 'medium',
					borderRadius: '0',
					buttonOverColor: '#728B94',
					bufferGradient: 'none',
					timeBgColor: '#555555',
					sliderGradient: 'none',
					volumeSliderGradient: 'none',
					tooltipTextColor: '#ffffff',
					timeColor: '#01DAFF'
				 }
			}
		}
	);
}

function startflowplayer_auto(swf, flv) {
	flowplayer("player", swf,
			{
				clip: {
					url: flv,
					autoPlay: false,
					autoBuffering: true,
					scaling: 'fit'
				},
				canvas: {
					backgroundColor: '#000000',
					backgroundGradient: 'none'
			},
			plugins: {
				controls: {
					height: 24,
					play:true,
					stop:true,
					volume:true,
					mute:true,
					time:true,
					fullscreen:true,
					volumeSliderColor: '#000000',
					tooltipColor: '#5F747C',
					progressColor: '#112233',
					bufferColor: '#445566',
					buttonColor: '#5F747C',
					sliderColor: '#000000',
					backgroundGradient: 'high',
					durationColor: '#ffffff',
					backgroundColor: '#222222',
					progressGradient: 'medium',
					borderRadius: '0',
					buttonOverColor: '#728B94',
					bufferGradient: 'none',
					timeBgColor: '#555555',
					sliderGradient: 'none',
					volumeSliderGradient: 'none',
					tooltipTextColor: '#ffffff',
					timeColor: '#01DAFF'
				 }
			}
		}
	);
}

function startflowplayer_auto_loop(swf, flv) {
	flowplayer("player", swf,
			{
				clip: {
					url: flv,
					autoPlay: false,
					autoBuffering: true,
					scaling: 'fit'
				},
				canvas: {
					backgroundColor: '#000000',
					backgroundGradient: 'none'
			},
			plugins: {
				controls: {
					height: 24,
					play:true,
					stop:true,
					volume:true,
					mute:true,
					time:true,
					loop: true,
					fullscreen:true,
					volumeSliderColor: '#000000',
					tooltipColor: '#5F747C',
					progressColor: '#112233',
					bufferColor: '#445566',
					buttonColor: '#5F747C',
					sliderColor: '#000000',
					backgroundGradient: 'high',
					durationColor: '#ffffff',
					backgroundColor: '#222222',
					progressGradient: 'medium',
					borderRadius: '0',
					buttonOverColor: '#728B94',
					bufferGradient: 'none',
					timeBgColor: '#555555',
					sliderGradient: 'none',
					volumeSliderGradient: 'none',
					tooltipTextColor: '#ffffff',
					timeColor: '#01DAFF'
				 }
			}
		}
	);
}
