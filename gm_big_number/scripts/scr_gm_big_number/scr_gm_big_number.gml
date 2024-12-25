// v2.3.0에 대한 스크립트 어셋 변경됨 자세한 정보는
// https://help.yoyogames.com/hc/en-us/articles/360005277377 참조
function number(num){
	return new __number_class_element__(num);
}

function __number_class_element__(num) constructor{
	if(is_real(num)){
		var _num_fract = int64(0);
		var _frac = frac(abs(num));
		for(var i = 1; i < 63+1; i++){
			_num_fract = _num_fract << 1;
			if(power(0.5,i) < _frac){
				_frac -= power(0.5,i);
				_num_fract += 1;
			}
		}
		num = int64(num);
		self.num_sign = sign(num);
		self.num = [_num_fract, abs(num)];
	} else {
		show_error("big number: defining number with string is not yet implemented!",1);
	}
}

function number_string(numb){
	var _str = "";
	for(var i = 0; i < array_length(numb); i++){
		
	}
}

function number_sum(a,b){
	if(a.sign != -1 && b.sign != -1){
		return __number_sum__(a,b);
	} else if(a.sign == -1 xor b.sign == -1){
		var _abs_cmp = number_cmp(number_abs(a),number_abs(b));
		if(_abs_cmp == -1){
			var _temp = a;
			a = b;
			b = _temp;
		}
		return __number_sub__(a,b);
	} else {
		return __number_sum__(a,b);
	}
}

function number_div(a,b){
	if(array_length(b.num) == 2 && b.num[1] == 0){
		show_error("big number: can't divide with 0",1);
	}
	if(array_length(a.num) == 2 && b.num[1] == 0){
		return number(0);
	}
	return __number_multiply__(a,__number_reciprocal__(b));
}

function number_cmp(a,b){
	if(a.num_sign > b.num_sign){
		return 1;
	} else if(a.num_sign < b.num_sign){
		return -1;
	}
	if(array_length(a.num) > array_length(b.num)){
		return 1;
	} else if(array_length(a.num) < array_length(b.num)){
		return -1;
	}
	for(var i = array_length(a.num)-1; i >= 0; i--){
		for(var ii = 63-1; ii >= 0; ii--){
			var _bit_a = ((a.num[i] & (int64(1) << ii)) != 0);
			var _bit_b = ((b.num[i] & (int64(1) << ii)) != 0);
			if(_bit_a > _bit_b){
				return 1;
			} else if(_bit_a < _bit_b){
				return -1;
			}
		}
	}
	return 0;
}

function number_abs(numb){
	var _new_numb = number(0);
	_new_numb.num_sign = (numb.num_sign == -1) || (numb.num_sign == 1);
	array_copy(_new_numb.num,0,numb.num,0,array_length(numb.num));
	return _new_numb;
}

function __number_multiply__(numb1,numb2){
	var _new_numb = number(0);
	_new_numb.num_sign = numb1.num_sign*numb2.num_sign;
	
	for(var i = 0; i < array_length(numb2.num); i++){
		for(var ii = 0; ii < 63; ii++){
			if(numb2.num & (int64(1) << ii) != 0){
				var _shift = 63*i+ii-63;
				var _temp_num = number(0);
				_temp_num.num_sign = 1;
				if(_shift > 0){
					for(var iii = 0; iii < _shift div 63; iii++){
						_temp_num.num[iii] = 0;
					}
					_temp_num[_shift div 63] = numb1.num << _shift mod 63;
					_temp_num[(_shift div 63)+1] = numb1.num >> (63-(_shift mod 63));
				}
				
				_new_numb = __number_sum__(_new_numb,_temp_num);
			}
		}
	}
	
	return _new_numb;
}

function __number_reciprocal__(numb){
	var _new_numb = number(0);
	
	if(numb.num[0] == 0 && numb.num[1] == 0){
		show_error("big number: can't reciprocal 0",true);
	}
	
	_new_numb.num_sign = numb1.num_sign;
	
	if(array_length(numb.num) >= 3){
		_new_numb.num = [int64(0),int64(0)];
		return _new_numb;
	}
	
	var _numb_result = number(1);
	var _numb_original = number(0);
	_numb_original.num[0] = numb.num[0];
	_numb_original.num[1] = numb.num[1];
	_numb_original.num_sign = 1;
	
	var _n2 = number(2);
	
	for(var i = 0; i < 7; i++){
		_numb_result = __number_multiply__(_numb_result,(__number_sub__(_n2,__number_multiply__(_numb_original,_numb_result))));
	}
	
	_new_numb.num = [];
	for(var i = 0; i < array_length(_numb_result.num); i++){
		_new_numb.num[i] = _numb_result.num[i];
	}
	
	return _new_numb;
}

function __number_sum__(numb1,numb2){
	var _new_numb = number(0);
	_new_numb.num_sign = numb1.num_sign;

	var _base_num = variable_clone(numb1.num);
	var _sum_num = variable_clone(numb2.num);
	
	for(var i = array_length(_sum_num); i < array_length(_base_num); i++){
		_sum_num[i] = 0;
	}
	for(var i = array_length(_base_num); i < array_length(_sum_num); i++){
		_base_num[i] = 0;
	}
	
	var _overed = false;
	for(var i = 0; i < array_length(_base_num); i++){
		var _temp_over;
		var _overed2 = false;
		while(_sum_num[i] != 0){
			_temp_over = _base_num[i] & _sum_num[i];
			_base_num[i] = _base_num[i] ^ _sum_num[i];
			_sum_num[i] = _temp_over << 1;
			
			_overed2 = _overed2 || (_temp_over & (int64(1) << 62) != 0);
		}
		if(_overed){
			_sum_num[i] = int64(1);
			while(_sum_num[i] != 0){
				_temp_over = _base_num[i] & _sum_num[i];
				_base_num[i] = _base_num[i] xor _sum_num[i];
				_sum_num[i] = _temp_over << 1;
			
				_overed2 = _overed2 || (_temp_over & (int64(1) << 62) != 0);
			}
		}
		_overed = _overed2;
		if(_overed2 && array_length(_base_num)-1 < i+1){
			_base_num[i+1] = 0;
			_sum_num[i+1] = 0;
		}
	}
	
	_new_numb.num = _base_num.num;
	return _new_numb;
}

function __number_sub__(numb1,numb2){
	var _new_numb = number(0);
	_new_numb.num_sign = numb1.num_sign;
	
	var _base_num = variable_clone(numb1.num);
	var _sub_num = variable_clone(numb2.num);
	
	for(var i = array_length(_sum_num); i < array_length(_base_num); i++){
		_sub_num[i] = 0;
	}
	for(var i = array_length(_base_num); i < array_length(_sum_num); i++){
		_base_num[i] = 0;
	}
	
	var _overed = false;
	for(var i = array_length(_base_num)-1; i >= 0; i++){
		var _temp_over;
		var _overed2 = false;
		while(_sub_num[i] != 0){
			_temp_over = (~_base_num[i]) & _sub_num[i];
			_base_num[i] = (_base_num[i] ^ _sub_num[i]) & (~_sub_num[i]);
			_sub_num[i] = _temp_over << 1;
			
			_overed2 = _overed2 || (_temp_over & int64(1) != 0);
		}
		if(_overed){
			_sub_num[i] = int64(1);
			_temp_over = (~_base_num[i]) & _sub_num[i];
			_base_num[i] = (_base_num[i] ^ _sub_num[i]) & (~_sub_num[i]);
			_sub_num[i] = _temp_over << 1;
			
			_overed2 = _overed2 || (_temp_over & int64(1) != 0);
		}
		_overed = _overed2;
	}
	for(var i = array_length(_base_num)-1; i >= 2; i++){
		if(_base_num[i] == 0){
			array_delete(_base_num,i,1);
		}
	}
	_new_numb.num = _base_num.num;
	return _new_numb;
}